//
//  QuickTouchViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/14.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QuickTouchViewController.h"
#import "QTProcessor.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "QTAddItemViewController.h"
#import "QTAddItemModel.h"

#define QTCellID @"QTCellID"

@interface QuickTouchViewController () <GCDAsyncUdpSocketDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *appQTTableView;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSilder;
@property (weak, nonatomic) IBOutlet UISlider *volumeSilder;
@property (weak, nonatomic) IBOutlet UIButton *screenShotBuuton;
@property (weak, nonatomic) IBOutlet UIButton *sleepButton;
@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIImageView *appIcon;

@property (nonatomic, strong) NSMutableArray<QTAddItemModel *> *appQTDataSource;

@end

@implementation QuickTouchViewController

- (void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Item" style:UIBarButtonItemStylePlain target:self action:@selector(pushToAddItemVC)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _appNameLabel.text = @"";
    
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:QTQuickTouchVCReloadData object:nil] subscribeNext:^(NSNotification *notication) {
        @strongify(self);
        if (notication.object) {
            QTMacToiOSModel *model = notication.object;
            self.appNameLabel.text = model.frontmostApp;
        }
        _appQTDataSource = [[PINCache sharedCache] objectForKey:_appNameLabel.text];
        [_appQTTableView reloadData];
    }];
    
    // config tableview
    _appQTTableView.delegate = self;
    _appQTTableView.dataSource = self;
    [_appQTTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:QTCellID];
    
    _appQTDataSource = [NSMutableArray new];

    [self configSystemCommands];
}

- (void)pushToAddItemVC{
    QTAddItemViewController *addItemVC = [QTAddItemViewController new];
    addItemVC.title = @"add item";
    [self.navigationController pushViewController:addItemVC animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _appQTDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QTCellID];
    QTAddItemModel *addItemModel = _appQTDataSource[indexPath.row];
    cell.textLabel.text = addItemModel.desc;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     QTAddItemModel *addItemModel = _appQTDataSource[indexPath.row];
    NSArray<QTTypeModel *> *qtTypeModels = addItemModel.qtTypeModels;
    for (QTTypeModel *model in qtTypeModels) {
        [[QTProcessor sharedInstance] sendQTTypeModel:model];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_appQTDataSource.count == 1) {
        _appQTDataSource = [NSMutableArray arrayWithArray:@[]];
    }else{
        [_appQTDataSource removeObjectAtIndex:indexPath.row];
    }
    [[PINCache sharedCache] setObject:_appQTDataSource forKey:_appNameLabel.text];
    [_appQTTableView reloadData];
}

#pragma mark - configSystemCommands
- (void)configSystemCommands{
    
    // 发送截图指令
    [[_screenShotBuuton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        QTShortCutsModel *qtShortCutsModel = [QTShortCutsModel new];
        qtShortCutsModel.functionKeys = @[@"Command", @"Shift"];
        qtShortCutsModel.plainKey = @"4";
        
        QTTypeModel *qtTypeModel = [QTTypeModel new];
        qtTypeModel.qtDesc = @"截图";
        qtTypeModel.qtType = QTShortCuts;
        qtTypeModel.qtContent = qtShortCutsModel;
        
        [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
    }];
    
    [[_sleepButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        QTSystemEventModel *qtSystemEventModel = [QTSystemEventModel new];
        qtSystemEventModel.qtSystemEventType = QTSystemEventSleep;
        
        QTTypeModel *qtTypeModel = [QTTypeModel new];
        qtTypeModel.qtDesc = @"睡眠";
        qtTypeModel.qtType = QTSystemEvent;
        qtTypeModel.qtContent = qtSystemEventModel;
        
        [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
    }];
    
    // 亮度控制
    [[[[_brightnessSilder rac_signalForControlEvents:UIControlEventValueChanged]
        throttle:0.1]
        map:^id(UISlider *slider) {
            NSString *value = [NSString stringWithFormat:@"%.1f",slider.value];
            return @(value.floatValue);}]
        subscribeNext:^(NSNumber *number) {
            QTSystemEventModel *qtSystemEventModel = [QTSystemEventModel new];
            qtSystemEventModel.qtSystemEventType = QTSystemEventBrightness;
            qtSystemEventModel.paras = @{@"brightness":number};
            
            QTTypeModel *qtTypeModel = [QTTypeModel new];
            qtTypeModel.qtDesc = @"调节亮度";
            qtTypeModel.qtType = QTSystemEvent;
            qtTypeModel.qtContent = qtSystemEventModel;
            
            [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
    }];

    // 音量控制
    [[[[_volumeSilder rac_signalForControlEvents:UIControlEventValueChanged]
        map:^id(UISlider *slider) {
            return @((int)(100*slider.value));}]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *number) {
            QTSystemEventModel *qtSystemEventModel = [QTSystemEventModel new];
            qtSystemEventModel.qtSystemEventType = QTSystemEventVolume;
            qtSystemEventModel.paras = @{@"volume":number};
            
            QTTypeModel *qtTypeModel = [QTTypeModel new];
            qtTypeModel.qtDesc = @"调节音量";
            qtTypeModel.qtType = QTSystemEvent;
            qtTypeModel.qtContent = qtSystemEventModel;
            
            [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
        }];
    
    [[_unlockButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        LAContext *context = [LAContext new];
        context.localizedFallbackTitle = @"";
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"解锁 MacBook" reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                QTPureWordsModel *qtPureWordsModel = [QTPureWordsModel new];
                qtPureWordsModel.content = @"tsui";
                qtPureWordsModel.enter = YES;
                
                QTTypeModel *qtTypeModel = [QTTypeModel new];
                qtTypeModel.qtDesc = @"解锁";
                qtTypeModel.qtType = QTPureWords;
                qtTypeModel.qtContent = qtPureWordsModel;
                
                [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
            }
        }];

    }];
    
    [[_upButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        QTSingleWordModel *qtSingleWordModel = [QTSingleWordModel new];
        qtSingleWordModel.content = @"UP";
        
        QTTypeModel *qtTypeModel = [QTTypeModel new];
        qtTypeModel.qtDesc = @"上";
        qtTypeModel.qtType = QTSingleWord;
        qtTypeModel.qtContent = qtSingleWordModel;
        
        [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
    }];

    [[_downButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        QTSingleWordModel *qtSingleWordModel = [QTSingleWordModel new];
        qtSingleWordModel.content = @"DOWN";
        
        QTTypeModel *qtTypeModel = [QTTypeModel new];
        qtTypeModel.qtDesc = @"下";
        qtTypeModel.qtType = QTSingleWord;
        qtTypeModel.qtContent = qtSingleWordModel;
        
        [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
    }];
}

@end
