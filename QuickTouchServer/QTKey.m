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
    if ([flag isEqual: @"command"]) {
        return kCGEventFlagMaskCommand;
    }else if([flag isEqual: @"shift"]){
        return kCGEventFlagMaskShift;
    }else if([flag isEqualToString:@"control"]){
        return kCGEventFlagMaskControl;
    }
    return kCGEventFlagMaskSecondaryFn;
}

//typedef CF_OPTIONS(uint64_t, CGEventFlags) { /* Flags for events */
//    /* Device-independent modifier key bits. */
//    kCGEventFlagMaskAlphaShift =          NX_ALPHASHIFTMASK,
//    kCGEventFlagMaskShift =               NX_SHIFTMASK,
//    kCGEventFlagMaskControl =             NX_CONTROLMASK,
//    kCGEventFlagMaskAlternate =           NX_ALTERNATEMASK,
//    kCGEventFlagMaskCommand =             NX_COMMANDMASK,
//    
//    /* Special key identifiers. */
//    kCGEventFlagMaskHelp =                NX_HELPMASK,
//    kCGEventFlagMaskSecondaryFn =         NX_SECONDARYFNMASK,
//    
//    /* Identifies key events from numeric keypad area on extended keyboards. */
//    kCGEventFlagMaskNumericPad =          NX_NUMERICPADMASK,
//    
//    /* Indicates if mouse/pen movement events are not being coalesced */
//    kCGEventFlagMaskNonCoalesced =        NX_NONCOALSESCEDMASK
//};

@end
