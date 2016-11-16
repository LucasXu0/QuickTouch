//
//  NSString+KeyCode.h
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 2016/11/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KeyCode)

+ (NSString *)keyStringFormKeyCode:(CGKeyCode)keyCode;
+ (CGKeyCode)keyCodeFormKeyString:(NSString *)keyString;

@end
