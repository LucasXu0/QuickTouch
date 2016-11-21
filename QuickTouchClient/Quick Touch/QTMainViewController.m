//
//  QTMainViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/21.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTMainViewController.h"
#import "QTHeaderView.h"
@interface QTMainViewController ()

@property (nonatomic, strong) QTHeaderView *headerView;

@end

@implementation QTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (QTHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[QTHeaderView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 70)];
        _headerView.appName = @"xcode";
        _headerView.userName = @"Tsui YuenHong";
    }
    return _headerView;
}

@end
