//
//  QTAddItemModel.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/19.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QTTypeModel;
@interface QTAddItemModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSArray<QTTypeModel *> *qtTypeModels;
@end
