//
//  OneViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import "OneViewController.h"

#define oneCellID @"oneCell"

@interface OneViewController () <UITableViewDataSource, UITableViewDelegate, GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) NSArray *commands;
@property (nonatomic, strong) UITableView *oneTableView;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commands = @[@"pwd", @"ls"];
    [self.view addSubview:self.oneTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commands.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oneCellID];
    cell.textLabel.text = self.commands[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *command = self.commands[indexPath.row];
    NSDictionary *commandDict = @{@"commandType":toNSNumber(QTCommandOne),@"command":command,@"isEnter":@YES};
    [[CommandSender sharedInstance] sendCommandDict:commandDict];
}

#pragma mark - Getter & Setter
- (UITableView *)oneTableView{
    if (!_oneTableView) {
        _oneTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _oneTableView.delegate = self;
        _oneTableView.dataSource = self;
        [_oneTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:oneCellID];
    }
    return _oneTableView;
}

@end
