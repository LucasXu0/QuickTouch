//
//  CommandSender.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import "CommandSender.h"

@implementation CommandSender

+ (instancetype)sharedInstance{
    static CommandSender *sharedInstance = nil;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CommandSender alloc] init];
        sharedInstance.socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    });
    return sharedInstance ;
}

- (void)sendCommandDict:(NSDictionary *)commandDict{
    NSData *commandData = [NSJSONSerialization dataWithJSONObject:commandDict options:NSJSONWritingPrettyPrinted error:nil];
   [self.socket sendData:commandData toHost:QTHOST port:QTPORT withTimeout:1.0 tag:0];
}

@end
