//
//  MacInfosViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/10.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "MacInfosViewController.h"

@interface MacInfosViewController ()<GCDAsyncUdpSocketDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentAppName;
@property (nonatomic, strong) GCDAsyncUdpSocket *socket;

@end

@implementation MacInfosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.socket bindToPort:9526 error:nil];
    [self.socket beginReceiving:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.socket = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSDictionary *macInfos = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.currentAppName.text = [NSString stringWithFormat:@"正在运行程序:%@",macInfos[@"currentAppName"]];

}

@end
