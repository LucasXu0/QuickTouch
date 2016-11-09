//
//  FTKey.m
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import "FTKey.h"

@implementation FTKey

+ (void)pressNormalKey:(CGKeyCode)keyCode{
    CGEventRef eventDown, eventUp;
    eventDown = CGEventCreateKeyboardEvent(nil, keyCode, YES);
    eventUp = CGEventCreateKeyboardEvent(nil, keyCode, NO);
    CGEventPost(kCGHIDEventTap, eventDown);
    sleep(0.0001);
    CGEventPost(kCGHIDEventTap, eventUp);
    CFRelease(eventUp);
    CFRelease(eventDown);
}

@end
