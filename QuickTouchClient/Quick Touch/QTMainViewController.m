//
//  QTMainViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/21.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTMainViewController.h"
#import "QTHeaderView.h"
#import "QTFooterView.h"
@interface QTMainViewController ()

@property (nonatomic, strong) QTHeaderView *headerView;
@property (nonatomic, strong) QTFooterView *footerView;

@end

@implementation QTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.footerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (QTHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[QTHeaderView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 130)];
        _headerView.appName = @"xcode";
        _headerView.userName = @"Tsui YuenHong";
    }
    return _headerView;
}

- (QTFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[QTFooterView alloc] initWithFrame:CGRectMake(0, 560, self.view.frame.size.width, 120)];
    }
    return _footerView;
}

@end
