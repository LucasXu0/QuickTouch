//
//  FTKey.h
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTKey : NSObject

// 这里不直接使用 key 是因为怕出歧义，所以使用 key code
+ (void)pressNormalKey:(CGKeyCode) keyCode;
+ (void)pressNormalKey:(CGKeyCode)keyCode withFlag:(NSString *)flag;
+ (void)pressNormalKey:(CGKeyCode) keyCode withFlags:(NSArray *)flags;

@end
