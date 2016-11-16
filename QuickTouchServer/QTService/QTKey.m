//
//  FTKey.m
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 09/11/2016.
//  Copyright © 2016 TsuiYuenHong. All rights reserved.
//

#import "QTKey.h"

@implementation QTKey

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

+ (void)pressNormalKey:(CGKeyCode)keyCode withFlag:(NSString *)flag{
    CGEventRef eventDown, eventUp;
    eventDown = CGEventCreateKeyboardEvent(nil, keyCode, YES);
    CGEventSetFlags(eventDown, eventFlag(flag));
    eventUp = CGEventCreateKeyboardEvent(nil, keyCode, NO);
    CGEventSetFlags(eventUp, eventFlag(flag));
    CGEventPost(kCGHIDEventTap, eventDown);
    sleep(0.0001);
    CGEventPost(kCGHIDEventTap, eventUp);
    CFRelease(eventUp);
    CFRelease(eventDown);
}

+ (void)pressNormalKey:(CGKeyCode)keyCode withFlags:(NSArray *)flags{
    CGEventRef eventDown, eventUp;
    CGEventFlags cgFlags;
    int tag = 0;
    for (NSString *flag in flags) {
        if (!flag.length) {
            continue ;
        }
        if (0 == tag) {
            cgFlags = eventFlag(flag);
            tag = 1;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wconditional-uninitialized"
        cgFlags = eventFlag(flag) | cgFlags;
#pragma clang diagnostic pop
    }
    eventDown = CGEventCreateKeyboardEvent(nil, keyCode, YES);
    CGEventSetFlags(eventDown, cgFlags);
    eventUp = CGEventCreateKeyboardEvent(nil, keyCode, NO);
    CGEventSetFlags(eventUp, cgFlags);
    CGEventPost(kCGHIDEventTap, eventDown);
    sleep(0.0001);
    CGEventPost(kCGHIDEventTap, eventUp);
    CFRelease(eventUp);
    CFRelease(eventDown);
}

CGEventFlags eventFlag(NSString *flag){
    if ([flag isEqual: @"Command"]) {
        return kCGEventFlagMaskCommand;
    }else if([flag isEqual: @"Shift"]){
        return kCGEventFlagMaskShift;
    }else if([flag isEqualToString:@"Control"]){
        return kCGEventFlagMaskControl;
    }else if([flag isEqualToString:@"Alt"]){
        return kCGEventFlagMaskAlternate;
    }else if([flag isEqualToString:@"Fn"]){
        return kCGEventFlagMaskSecondaryFn;
    }
    return kCGEventFlagMaskHelp;
}

@end
