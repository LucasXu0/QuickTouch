//
//  CustomShortCutViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import "CustomShortCutViewController.h"

#define padding 10
#define shortCutCellID @"shortCutCellID"
#define shortCutStrsKey @"shortCutStrsKey"
#define shortCutCommandssKey @"shortCutCommandssKey"

@interface CustomShortCutViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *oneFuncTextField;
@property (nonatomic, strong) UITextField *twoFuncTextField;
@property (nonatomic, strong) UITextField *threeFuncTextField;
@property (nonatomic, strong) UITextField *normalKeyTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *shortCutTableView;
@property (nonatomic, strong) NSMutableArray *shortCutStrs;
@property (nonatomic, strong) NSMutableArray *shortCutCommands;

@end

@implementation CustomShortCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:shortCutStrsKey]) {
        NSArray *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:shortCutStrsKey];
        _shortCutStrs = [NSMutableArray arrayWithArray:tmp];
    } else {
        _shortCutStrs = [NSMutableArray new];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:shortCutCommandssKey]) {
        NSArray *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:shortCutCommandssKey];
        _shortCutCommands = [NSMutableArray arrayWithArray:tmp];
    } else {
        _shortCutCommands = [NSMutableArray new];
    }
    
    [self.view addSubview:self.oneFuncTextField];
    [self.view addSubview:self.twoFuncTextField];
    [self.view addSubview:self.threeFuncTextField];
    [self.view addSubview:self.normalKeyTextField];
    [self.view addSubview:self.confirmButton];
    [self.view addSubview:self.shortCutTableView];
    
    [self configSubviewsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _shortCutStrs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shortCutCellID];
    cell.textLabel.text = _shortCutStrs[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [[CommandSender sharedInstance] sendCommandDict:_shortCutCommands[indexPath.row]];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_shortCutCommands removeObjectAtIndex:indexPath.row];
    [_shortCutStrs removeObjectAtIndex:indexPath.row];
    [self storeDataSource];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Subviews Layout
- (void)configSubviewsLayout {
    [_oneFuncTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(80);
        make.left.equalTo(self.view.mas_left).with.offset(padding);
        make.right.equalTo(_twoFuncTextField.mas_left).with.offset(-padding);
        make.height.mas_equalTo(30);
        make.width.equalTo(_twoFuncTextField.mas_width);
    }];
    
    [_twoFuncTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneFuncTextField.mas_top);
        make.height.equalTo(_oneFuncTextField.mas_height);
        make.width.equalTo(_oneFuncTextField.mas_width);
        make.right.equalTo(_threeFuncTextField.mas_left).with.offset(-padding);
        make.left.equalTo(_oneFuncTextField.mas_right).with.offset(padding);
    }];
    
    [_threeFuncTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneFuncTextField.mas_top);
        make.height.equalTo(_oneFuncTextField.mas_height);
        make.width.equalTo(_oneFuncTextField.mas_width);
        make.right.equalTo(_normalKeyTextField.mas_left).with.offset(-padding);
        make.left.equalTo(_twoFuncTextField.mas_right).with.offset(padding);
    }];

    [_normalKeyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneFuncTextField.mas_top);
        make.height.equalTo(_oneFuncTextField.mas_height);
        make.width.equalTo(_oneFuncTextField.mas_width);
        make.right.equalTo(self.view.mas_right).with.offset(-padding);
        make.left.equalTo(_threeFuncTextField.mas_right).with.offset(padding);
    }];

    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneFuncTextField.mas_bottom).with.offset(padding/2);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [_shortCutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confirmButton.mas_bottom).with.offset(padding / 2);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

#pragma mark - Getter & Setter
- (UITextField *)oneFuncTextField{
    if (!_oneFuncTextField) {
        _oneFuncTextField = [UITextField new];
        _oneFuncTextField.placeholder = @"Func 1";
        
    }
    return _oneFuncTextField;
}

- (UITextField *)twoFuncTextField{
    if (!_twoFuncTextField) {
        _twoFuncTextField = [UITextField new];
        _twoFuncTextField.placeholder = @"Func 2";
    }
    return _twoFuncTextField;
}

- (UITextField *)threeFuncTextField{
    if (!_threeFuncTextField) {
        _threeFuncTextField = [UITextField new];
        _threeFuncTextField.placeholder = @"Func 3";
    }
    return _threeFuncTextField;
}

- (UITextField *)normalKeyTextField{
    if (!_normalKeyTextField) {
        _normalKeyTextField = [UITextField new];
        _normalKeyTextField.placeholder = @"Key";
    }
    return _normalKeyTextField;
}

- (UIButton *)confirmButton{
    if (!_confirmButton) {
        _confirmButton = [UIButton new];
        [_confirmButton setTitle:@"添加快捷键" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [[_confirmButton rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
            NSString *command = [NSString stringWithFormat:@"%@+%@+%@+%@",_oneFuncTextField.text,_twoFuncTextField.text,_threeFuncTextField.text,_normalKeyTextField.text];
            [_shortCutStrs addObject:command];
            
            NSArray *functionKeys = @[_oneFuncTextField.text,_twoFuncTextField.text,_threeFuncTextField.text];
            NSString *normalKey = _normalKeyTextField.text;
            NSDictionary *commandDict = @{
                                          @"functionKeys":functionKeys,
                                          @"normalKey":normalKey,
                                          @"commandType":toNSNumber(QTCommandMultiKeys),
                                          };
            [_shortCutCommands addObject:commandDict];

            [self storeDataSource];
            
            [_shortCutTableView reloadData];
        }];
    }
    return _confirmButton;
}

- (UITableView *)shortCutTableView{
    if (!_shortCutTableView) {
        _shortCutTableView = [UITableView new];
        [_shortCutTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:shortCutCellID];
        _shortCutTableView.delegate = self;
        _shortCutTableView.dataSource = self;
    }
    return _shortCutTableView;
}

- (void)storeDataSource{
    [[NSUserDefaults standardUserDefaults] setObject:_shortCutStrs forKey:shortCutStrsKey];
    [[NSUserDefaults standardUserDefaults] setObject:_shortCutCommands forKey:shortCutCommandssKey];
}

@end
