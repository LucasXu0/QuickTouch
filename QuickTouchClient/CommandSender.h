//
//  CommandSender.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface CommandSender : NSObject <GCDAsyncUdpSocketDelegate>
@property (nonatomic, strong) GCDAsyncUdpSocket *socket;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) uint16_t sendPort;
@property (nonatomic, assign) uint16_t RecePort;
+ (instancetype)sharedInstance;
- (void)sendCommandDict:(NSDictionary *)commandDict;
- (void)configHostAndPort:(NSArray *)array;
@end
