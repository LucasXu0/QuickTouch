//
//  NSString+KeyCode.h
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 2016/11/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_OSX
#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#endif

@interface NSString (KeyCode)

#if TARGET_OS_OSX
+ (NSString *)keyStringFormKeyCode:(CGKeyCode)keyCode;
+ (CGKeyCode)keyCodeFormKeyString:(NSString *)keyString;
#endif

@end
