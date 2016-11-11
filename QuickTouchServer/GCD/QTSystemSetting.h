//
//  FTSystemSetting.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/11.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTSystemSetting : NSObject


/**
 设置系统亮度

 @param level 0 最低 1 最高
 */
+ (void)setSystemBrightness:(float)level;

@end
