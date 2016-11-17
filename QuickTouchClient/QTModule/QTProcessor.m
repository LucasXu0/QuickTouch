//
//  QTProcessor.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/16.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTProcessor.h"
#import <MJExtension/MJExtension.h>

@implementation QTProcessor

+ (instancetype)sharedInstance{
    static QTProcessor *sharedInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[QTProcessor alloc] init];
        sharedInstance.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:sharedInstance delegateQueue:dispatch_get_main_queue()];
    });
    return sharedInstance ;
}

#pragma mark - Send Data
- (void)sendQTDataModel:(id)dataModel{
    NSDictionary *dataDict = [dataModel mj_keyValues];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
    [_socket sendData:data withTimeout:-1.0 tag:0];
}

#pragma mark - Receive Data
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
}

- (void)configHostAndPort:(NSArray *)array{
    self.host = array[0];
    self.sendPort = [array[1] intValue];
    self.RecePort = [array[2] intValue];
}


@end
