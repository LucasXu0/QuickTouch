//
//  FTKey.h
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTKey : NSObject

+ (void)pressNormalKey:(CGKeyCode) keyCode;
+ (void)pressNormalKey:(CGKeyCode) keyCode withFlags:(NSArray *)flags;

@end
