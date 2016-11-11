//
//  FTSystemSetting.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/11.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTSystemSetting.h"

@implementation QTSystemSetting

+ (void)setSystemBrightness:(float)level{
    io_iterator_t iterator;
    kern_return_t result = IOServiceGetMatchingServices(kIOMasterPortDefault, IOServiceMatching("IODisplayConnect"), &iterator);
    if (result == kIOReturnSuccess) {
        io_object_t service;
        while ((service = IOIteratorNext(iterator))) {
            IODisplaySetFloatParameter(service, kNilOptions, CFSTR(kIODisplayBrightnessKey), level);
            IOObjectRelease(service);
            return;
        }
    }
}

+ (void)setSystemVolume:(int)level{
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat: @"set volume output volume %d",level]];
    [script executeAndReturnError:nil];
}

+ (SInt32)getSystemVolume{
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:@"output volume of (get volume settings)"];
    return [[script executeAndReturnError:nil] int32Value];
}

+ (void)sleepWithDelay:(int)delay{
    NSAppleScript *sleepScript = [[NSAppleScript alloc] initWithSource:[NSString stringWithFormat:@"delay %d \n tell application \"System Events\" \n\t sleep \n end tell",delay]];
    [sleepScript executeAndReturnError:nil];
}

+ (void)sleepNow{
    [QTSystemSetting sleepWithDelay:0];
}

@end
