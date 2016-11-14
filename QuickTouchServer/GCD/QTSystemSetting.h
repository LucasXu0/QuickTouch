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


/**
 获取某个 APP menuItem 的全部名称

 @param appName 应用名字
 */
+ (void)fetchAllMenuItemNameOfApp:(NSString *)appName;

/**
 模拟点击 MenuItem
 
 @param item item 名字 如 新建 Finder 窗口
 @param menu menu 名字 如 文件
 @param menuBar 第 X 个 menu bar 通常为1
 @param appName 应用名字 如 Finder
 */
+ (void)clickMenuItem:(NSString *)item
               ofMenu:(NSString *)menu
            ofMenuBar:(NSInteger)menuBar
        ofApplication:(NSString *)appName;

/**
 模拟点击 SubMenuItem
 
 @param item item 名字 如 新建 Finder 窗口
 @param menu menu 名字 如 文件
 @param menuBar 第 X 个 menu bar 通常为1
 @param appName 应用名字 如 Finder
 */
+ (void)clickSubMenuItem:(NSString *)subItem
              ofMenuItem:(NSString *)item
               ofMenu:(NSString *)menu
            ofMenuBar:(NSInteger)menuBar
        ofApplication:(NSString *)appName;


/**
 启动某个 APP

 @param name APP Name
 */
+ (void)launchApp:(NSString *)name;

@end
