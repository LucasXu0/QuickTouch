//
//  SuperCustomViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/10.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "SuperCustomViewController.h"

#define SuperCustomCellID @"SuperCustomCellID"

@interface SuperCustomViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *superCustomTableView;
@property (nonatomic, strong) NSArray *superCustomCommands;

@end

@implementation SuperCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _superCustomCommands = @[@"迅雷"];
    [self.view addSubview:self.superCustomTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _superCustomCommands.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SuperCustomCellID];
    cell.textLabel.text = _superCustomCommands[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *commandDict = @{
                                  @"commandType":toNSNumber(QTCommandSuperCustom),
                                  @"command":_superCustomCommands[indexPath.row]
                                  };
    [[CommandSender sharedInstance] sendCommandDict:commandDict];
}

#pragma mark - Getter & Setter
- (UITableView *)superCustomTableView{
    if (!_superCustomTableView) {
        _superCustomTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        [_superCustomTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:SuperCustomCellID];
        _superCustomTableView.delegate = self;
        _superCustomTableView.dataSource = self;
    }
    return _superCustomTableView;
}

@end
