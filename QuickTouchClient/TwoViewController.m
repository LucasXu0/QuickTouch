//
//  TwoViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import "TwoViewController.h"

#define twoCellID @"twoCell"

@interface TwoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *commands;
@property (nonatomic, strong) UITableView *twoTableView;

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.commands = @[@"Command + C",@"Command + V"];
    [self.view addSubview:self.twoTableView];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:twoCellID];
    cell.textLabel.text = self.commands[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *command = self.commands[indexPath.row];
    NSDictionary *commandDict = [self handleCommand:command];
    [[CommandSender sharedInstance] sendCommandDict:commandDict];
}

#pragma mark - Getter & Setter
- (UITableView *)twoTableView{
    if (!_twoTableView) {
        _twoTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _twoTableView.delegate = self;
        _twoTableView.dataSource = self;
        [_twoTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:twoCellID];
    }
    return _twoTableView;
}

- (NSDictionary *)handleCommand:(NSString *)command{
    NSRange plusRange = [command rangeOfString:@" + "];
    NSString *functionKey = [command substringToIndex:plusRange.location];
    NSString *commandKey = [command substringFromIndex:plusRange.location + plusRange.length];
    NSLog(@"%@_%@",functionKey,commandKey);
    return @{@"commandType":toNSNumber(QTCommandTwo) ,@"functionKey":functionKey, @"commandKey":commandKey};
}

@end
