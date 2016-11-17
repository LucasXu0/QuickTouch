//
//  QTProcessor.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/16.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTProcessor.h"
#import "MJExtension.h"

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

- (void)beginReceiving{
#warning 错误信息待完善
    [self.socket bindToPort:self.recePort error:nil];
    [self.socket beginReceiving:nil];
}

#pragma mark - Send Data
- (void)sendQTDataModel:(QTTypeModel *)dataModel{
    [_socket sendData:[self qtConvertModelToData:dataModel] toHost:_host port:_sendPort withTimeout:-1.0 tag:0];
}

- (NSData *)qtConvertModelToData:(QTTypeModel *)dataModel{
    
    NSMutableDictionary *dataModelDict = [dataModel mj_keyValues];
    id qtContent = dataModel.qtContent;
    NSDictionary *qtContentDict = [qtContent mj_keyValues];
    [dataModelDict setObject:qtContentDict forKey:@"qtContent"];
    return  [NSJSONSerialization dataWithJSONObject:dataModelDict options:NSJSONWritingPrettyPrinted error:nil];
}

#pragma mark - Receive Data
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSDictionary *dataModelDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    QTTypeModel *dataModel = [QTTypeModel mj_objectWithKeyValues:dataModelDict];
    switch (dataModel.qtType) {
        case QTConfirm:{
            
        }
            break;
        case QTMouseEvent:{
        
        }
            break;
        case QTSingleWord:{
            QTSingleWordModel *model = [QTSingleWordModel mj_objectWithKeyValues:dataModel.qtContent];
            [model handleEvent];
        }
            break;
        case QTPureWords:{
            QTPureWordsModel *model = [QTPureWordsModel mj_objectWithKeyValues:dataModel.qtContent];
            [model handleEvent];
        
        }
            break;
        case QTShortCuts:{
            QTShortCutsModel *model = [QTShortCutsModel mj_objectWithKeyValues:dataModel.qtContent];
            [model handleEvent];
        }
            break;
        case QTClickMenuItem:{
            QTClickMenuItemModel *model = [QTClickMenuItemModel mj_objectWithKeyValues:dataModel.qtContent];
            [model handleEvent];
        }
            break;
        case QTSystemEvent:{
            QTSystemEventModel *model = [QTSystemEventModel mj_objectWithKeyValues:dataModel.qtContent];
            [model handleEvent];
        }
            break;
        case QTMacToiOS:{
        
        }
            break;
        default:
            break;
    }
}

- (void)configHostAndPort:(NSArray *)array{
    self.host = array[0];
    self.sendPort = [array[1] intValue];
    self.recePort = [array[2] intValue];
}


@end
