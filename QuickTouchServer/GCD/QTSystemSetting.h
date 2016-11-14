//
//  FTSystemSetting.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/11.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface QTSystemSetting : NSObject


/**
 设置系统亮度

 @param level 0 最低 1 最高
 */
+ (void)setSystemBrightness:(float)level;

/**
  设置/获取系统音量

 @param level 0 最低 100 最高
 */
+ (void)setSystemVolume:(int)level;
+ (SInt32)getSystemVolume;


/**
 使 Mac 休眠

 @param delay 延迟时间
 */
+ (void)sleepWithDelay:(int)delay;
+ (void)sleepNow;


+ (void)clickMenuItemName:(NSString *)itemName
                   ofMenu:(int)menu
            ofMenuBarItem:(int)menuBarItem
                ofMenuBar:(int)menuBar
        ofApplicationName:(NSString *)appName;

+ (void)launchApp:(NSString *)name;

@end
