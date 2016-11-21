//
//  QTProcessor.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/16.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTProcessor.h"

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
    [_socket setMaxReceiveIPv4BufferSize:65532];
    [_socket bindToPort:_recePort error:nil];
    [_socket beginReceiving:nil];
}

#pragma mark - Send Data
- (void)sendQTTypeModel:(QTTypeModel *)typeModel{
    [_socket sendData:[self qtConvertModelToData:typeModel] toHost:_host port:_sendPort withTimeout:-1.0 tag:0];
}

- (NSData *)qtConvertModelToData:(QTTypeModel *)dataModel{
    NSDictionary *dataModelDict = [MTLJSONAdapter JSONDictionaryFromModel:dataModel error:nil];
    if ([dataModel.qtContent isKindOfClass:[MTLModel class]]) {
        NSDictionary *qtContentDict = [MTLJSONAdapter JSONDictionaryFromModel:dataModel.qtContent error:nil];
        [dataModelDict setValue:qtContentDict forKey:@"qtContent"];
    }
    return  [NSJSONSerialization dataWithJSONObject:dataModelDict options:NSJSONWritingPrettyPrinted error:nil];
}

#pragma mark - Receive Data
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{
    NSDictionary *dataModelDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",dataModelDict);
    QTTypeModel *dataModel = [MTLJSONAdapter modelOfClass:QTTypeModel.class fromJSONDictionary:dataModelDict error:nil];
    switch (dataModel.qtType) {
        case QTConfirm:{
            
        }
            break;
        case QTMouseEvent:{
        
        }
            break;
#if TARGET_OS_OSX
        case QTSingleWord:{
            QTSingleWordModel *model = [MTLJSONAdapter modelOfClass:QTSingleWordModel.class fromJSONDictionary:dataModel.qtContent error:nil];
            [model handleEvent];
        }
            break;
        case QTPureWords:{
            QTPureWordsModel *model = [MTLJSONAdapter modelOfClass:QTPureWordsModel.class fromJSONDictionary:dataModel.qtContent error:nil];
            [model handleEvent];
        
        }
            break;
        case QTShortCuts:{
            QTShortCutsModel *model = [MTLJSONAdapter modelOfClass:QTShortCutsModel.class fromJSONDictionary:dataModel.qtContent error:nil];
            [model handleEvent];
        }
            break;
        case QTClickMenuItem:{
            QTClickMenuItemModel *model = [MTLJSONAdapter modelOfClass:QTClickMenuItemModel.class fromJSONDictionary:dataModel.qtContent error:nil];
            [model handleEvent];
        }
            break;
        case QTSystemEvent:{
            QTSystemEventModel *model = [MTLJSONAdapter modelOfClass:QTSystemEventModel.class fromJSONDictionary:dataModel.qtContent error:nil];
            [model handleEvent];
        }
            break;
        case QTiOSHost:{
            _host = dataModel.qtContent;
            [[NSUserDefaults standardUserDefaults] setObject:_host forKey:UserDeafault_iOSLocalIP];
        }
            break;
#endif
#if TARGET_OS_IOS
        case QTMacToiOS:{
            QTMacToiOSModel *model = [MTLJSONAdapter modelOfClass:QTMacToiOSModel.class fromJSONDictionary:dataModel.qtContent error:nil];
            switch (model.type) {
                case QTMacToiOSFrontmostApp:{
                    [[NSNotificationCenter defaultCenter] postNotificationName:QTQuickTouchVCReloadData object:model];
                }
                    break;
                default:
                    break;
            }
        }
            break;
#endif
        default:
            break;
    }
}

- (void)configHostAndPort:(NSArray *)array{
    _host = array[0];
    _sendPort = [array[1] intValue];
    _recePort = [array[2] intValue];
}

@end
