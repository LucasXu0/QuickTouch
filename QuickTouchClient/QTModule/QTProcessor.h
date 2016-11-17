//
//  QTProcessor.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/16.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"
#import "QTTypeClass.h"

@interface QTProcessor : NSObject <GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *socket;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) uint16_t sendPort;
@property (nonatomic, assign) uint16_t recePort;

+ (instancetype)sharedInstance;
- (void)sendQTTypeModel:(QTTypeModel *)typeModel;
- (void)configHostAndPort:(NSArray *)array; // array example : @[@"192.168.1.10", 9527, 9526]
- (void)beginReceiving;

@end
