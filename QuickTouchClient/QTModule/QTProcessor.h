//
//  QTProcessor.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/16.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

@interface QTProcessor : NSObject <GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket *socket;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) uint16_t sendPort;
@property (nonatomic, assign) uint16_t RecePort;

+ (instancetype)sharedInstance;
- (void)sendQTDataModel:(id)dataModel;
- (void)configHostAndPort:(NSArray *)array;

@end
