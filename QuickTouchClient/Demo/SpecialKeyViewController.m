//
//  SpecialKeyViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import "SpecialKeyViewController.h"

#define specialCellID @"specialCell"

@interface SpecialKeyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *commands;
@property (nonatomic, strong) UITableView *specialTableView;

@end

@implementation SpecialKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _commands = [NSMutableArray arrayWithCapacity:17];
    for (int i = 1; i < 16; i++) {
        NSString *fKey = [NSString stringWithFormat:@"F%d",i];
        [_commands addObject:fKey];
    }
    
    [_commands addObject:@"VolumeUp"];
    [_commands addObject:@"VolumeDown"];
    
    [self.view addSubview:self.specialTableView];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:specialCellID];
    cell.textLabel.text = self.commands[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *command = self.commands[indexPath.row];
    NSDictionary *commandDict = @{@"commandType":toNSNumber(QTCommandSpecial), @"command":command};
    [[CommandSender sharedInstance] sendCommandDict:commandDict];
}

#pragma mark - Getter & Setter
- (UITableView *)specialTableView{
    if (!_specialTableView) {
        _specialTableView = [[UITableView alloc] initWithFrame:self.view.frame];
        _specialTableView.delegate = self;
        _specialTableView.dataSource = self;
        [_specialTableView registerClass:[UITableViewCell self] forCellReuseIdentifier:specialCellID];
    }
    return _specialTableView;
}


@end
