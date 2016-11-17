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

#define QTCellID @"QTCellID"

@interface QuickTouchViewController () <GCDAsyncUdpSocketDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *unlockButton;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *appQTTableView;
@property (weak, nonatomic) IBOutlet UISlider *brightnessSilder;
@property (weak, nonatomic) IBOutlet UISlider *volumeSilder;
@property (weak, nonatomic) IBOutlet UIButton *screenShotBuuton;
@property (weak, nonatomic) IBOutlet UIButton *sleepButton;

@property (nonatomic, strong) NSMutableDictionary *appQTDataSource;

@end

@implementation QuickTouchViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // config tableview
    _appQTTableView.delegate = self;
    _appQTTableView.dataSource = self;
    [_appQTTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:QTCellID];

    _appNameLabel.text = @"Finder";
    
    [self configAppCommands];
    [self configSystemCommands];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:QTQuickTouchVCReloadData object:nil] subscribeNext:^(NSNotification *notication) {
        _appNameLabel.text = notication.object;
        [_appQTTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_appQTDataSource[_appNameLabel.text] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:QTCellID];
    QTTypeModel *qtTypeModel = _appQTDataSource[_appNameLabel.text][indexPath.row];
    cell.textLabel.text = qtTypeModel.qtDesc;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    QTTypeModel *qtTypeModel = _appQTDataSource[_appNameLabel.text][indexPath.row];
    [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
}

#pragma mark - Config Commands
- (void)configAppCommands{
    _appQTDataSource = [NSMutableDictionary dictionary];
    // 1. Finder
    // 1.1 新建 Finder 窗口
    
    QTClickMenuItemModel *openNewFinderContentModel = [QTClickMenuItemModel new];
    //    openNewFinderModel.desc = @"新建 Finder 窗口";
    openNewFinderContentModel.menuItem = @"新建 Finder 窗口";
    openNewFinderContentModel.menu = @"文件";
    openNewFinderContentModel.menuBar = 1;
    openNewFinderContentModel.appName = @"Finder";
    
    QTTypeModel *openNewFinderModel = [QTTypeModel new];
    openNewFinderModel.qtDesc = @"新建 Finder 窗口";
    openNewFinderModel.qtType = QTClickMenuItem;
    openNewFinderModel.qtContent = openNewFinderContentModel;

    [_appQTDataSource setObject:@[openNewFinderModel] forKey:@"Finder"];
    
//    
//    // 1.2 AirDrop
//    NSDictionary *finderDict1 = @{
//                                  @"desc":@"AirDrop",
//                                  @"command":@{
//                                          @"commandType":toNSNumber(QTCommandClickMenuItem),
//                                          @"menuItem":@"AirDrop",
//                                          @"menu":@"前往",
//                                          @"menuBar":@1,
//                                          @"app":@"Finder",
//                                          }
//                                  };
//    NSArray *finderArray = @[finderDict0,finderDict1];
//    [_appQTDataSource setObject:finderArray forKey:@"Finder"];
//    //2. Xcode
//    //2.1 注释
//    NSDictionary *xcodeDict0 = @{
//                                     @"desc":@"注释",
//                                 @"command":@{
//                                         @"commandType" : toNSNumber(QTCommandTwo),
//                                         @"functionKeys" : @[@"Command"],
//                                         @"commandKeys" : @"/"
//                                         }
//                                 };
//    NSDictionary *xcodeDict1 = @{
//                                 @"desc":@"格式化代码",
//                                 @"command":@{
//                                         @"commandType" : toNSNumber(QTCommandClickSubMenuItem),
//                                         @"subMenuItem":@"Re-Indent",
//                                         @"menuItem":@"Structure",
//                                         @"menu":@"Editor",
//                                         @"menuBar":@1,
//                                         @"app":@"Xcode",
//                                         }
//                                 };
//    NSArray *xcodeArray = @[openNewFinderModel,xcodeDict1];
//    [_appQTDataSource setObject:xcodeArray forKey:@"Xcode"];
}

- (void)configSystemCommands{
    
    // 发送截图指令
    [[_screenShotBuuton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        QTShortCutsModel *qtShortCutsModel = [QTShortCutsModel new];
        qtShortCutsModel.desc = @"截图";
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
        qtSystemEventModel.desc = @"睡眠";
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
            qtSystemEventModel.desc = @"调节亮度";
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
            qtSystemEventModel.desc = @"调节音量";
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
                qtPureWordsModel.desc = @"解锁";
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
}

@end
