//
//  CustomShortCutViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import "CustomShortCutViewController.h"

#define padding 20
#define shortCutCellID @"shortCutCellID"
#define StoreKey @"CustomShortCutsKey"

@interface CustomShortCutViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITextField *oneFuncTextField;
@property (nonatomic, strong) UITextField *twoFuncTextField;
@property (nonatomic, strong) UITextField *threeFuncTextField;
@property (nonatomic, strong) UITextField *normalKeyTextField;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UITableView *shortCutTableView;
@property (nonatomic, strong) NSMutableArray *shortCuts;

@end

@implementation CustomShortCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.shortCuts = [[NSUserDefaults standardUserDefaults] objectForKey:StoreKey] ? [[NSUserDefaults standardUserDefaults] objectForKey:StoreKey] : [NSMutableArray array];
    
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
    return _shortCuts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:shortCutCellID];
    cell.textLabel.text = _shortCuts[indexPath.row];
    return cell;
}

#pragma mark - Subviews Layout
- (void)configSubviewsLayout {
    [_oneFuncTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(80);
        make.left.equalTo(self.view).with.offset(padding);
        make.right.equalTo(_twoFuncTextField.mas_left).with.offset(-padding);
        make.height.mas_equalTo(30);
        make.width.equalTo(_twoFuncTextField);
    }];
    
    [_twoFuncTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneFuncTextField);
        make.height.equalTo(_oneFuncTextField);
        make.width.equalTo(_oneFuncTextField);
        make.right.equalTo(_threeFuncTextField.mas_left).with.offset(-padding);
        make.left.equalTo(_oneFuncTextField.mas_right).with.offset(padding);
    }];
    
    [_threeFuncTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneFuncTextField);
        make.height.equalTo(_oneFuncTextField);
        make.width.equalTo(_oneFuncTextField);
        make.right.equalTo(_threeFuncTextField.mas_left).with.offset(-padding);
        make.left.equalTo(_twoFuncTextField.mas_right).with.offset(padding);
    }];
    
    [_normalKeyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneFuncTextField);
        make.height.equalTo(_oneFuncTextField);
        make.width.equalTo(_oneFuncTextField);
        make.right.equalTo(self.view.mas_right).with.offset(-padding);
        make.left.equalTo(_threeFuncTextField.mas_right).with.offset(padding);
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_oneFuncTextField.mas_bottom).with.offset(padding/2);
        make.width.equalTo(self.view.mas_width);
    }];
    
    [_shortCutTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_confirmButton.mas_bottom).with.offset(padding / 2);
        make.width.equalTo(self.view);
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
            [_shortCuts addObject:command];
            [[NSUserDefaults standardUserDefaults] setObject:_shortCuts forKey:StoreKey];
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

@end
