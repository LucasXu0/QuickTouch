//
//  MainViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "MainViewController.h"
#import "QuickTouchViewController.h"
#import "ScanQRCodeViewController.h"

#define cellID @"commandTypesCell"

@interface MainViewController () <GCDAsyncUdpSocketDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *kcopyButton;
@property (nonatomic, strong) UIButton *kpasteButton;
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSArray *commandTypes;
//@property

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化数据源
    self.commandTypes = @[@"Quick Touch"];
    
    [self.view addSubview:self.mainTableView];


    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStylePlain target:self action:@selector(scanQRCode)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scanQRCode{
    [self.navigationController pushViewController:[ScanQRCodeViewController new] animated:NO];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commandTypes.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = self.commandTypes[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch ((int)indexPath.row) {
        case 0:{
            QuickTouchViewController *QTVC = [QuickTouchViewController new];
            QTVC.title = @"Quick Touch";
            [self.navigationController pushViewController:QTVC animated:NO];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getter & Setter
-(UITableView *)mainTableView {
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [_mainTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:cellID];
    }
    return _mainTableView;
}
@end
