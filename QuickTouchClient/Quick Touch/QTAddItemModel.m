//
//  QTAddItemModel.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/19.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTAddItemModel.h"

@implementation QTAddItemModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"desc":@"desc",
             @"qtTypeModels":@"qtTypeModels",
             };
}
@end
