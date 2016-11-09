//
//  FTKey.h
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTKey : NSObject


/**
 根据 key code 触发相应键

 @param keyCode Key Code
 */
+ (void)pressNormalKey:(CGKeyCode) keyCode;

@end
