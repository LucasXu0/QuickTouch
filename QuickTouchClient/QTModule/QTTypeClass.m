//
//  QTTypeClass.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/17.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "QTTypeClass.h"
#if TARGET_OS_OSX
#import "QTKey.h"
#endif

@implementation QTTypeClass
@end

@implementation QTTypeModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"qtDesc":@"qtDesc",
             @"qtContent":@"qtContent",
             @"qtType":@"qtType",
             };
}
@end

@implementation QTConfirmModel
@end

@implementation QTSingleWordModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"content":@"content",
             };
}
#if TARGET_OS_OSX
- (void)handleEvent{
    CGKeyCode keyCode = [NSString keyCodeFormKeyString:self.content];
    [QTKey pressNormalKey:keyCode];
}
#endif
@end

@implementation QTPureWordsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"content":@"content",
             @"enter":@"enter"
             };
}
#if TARGET_OS_OSX
- (void)handleEvent{
    NSString *each = @"";
    CGKeyCode keyCode;
    for (int i = 0 ; i < self.content.length ; i++) {
        each = [NSString stringWithFormat:@"%c",[self.content characterAtIndex:i]];
        keyCode = [NSString keyCodeFormKeyString:each];
        [QTKey pressNormalKey:keyCode];
    }
    
    if (self.enter) {
        keyCode = [NSString keyCodeFormKeyString:@"ENTER"];
        [QTKey pressNormalKey:keyCode];
    }
}
#endif
@end

@implementation QTShortCutsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"functionKeys":@"functionKeys",
             @"plainKey":@"plainKey",
             };
}
#if TARGET_OS_OSX
- (void)handleEvent{
    CGKeyCode keyCode = [NSString keyCodeFormKeyString:self.plainKey];
    [QTKey pressNormalKey:keyCode withFlags:self.functionKeys];
}
#endif
@end

@implementation QTClickMenuItemModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"subMenuItem":@"subMenuItem",
             @"menuItem":@"menuItem",
             @"menu":@"menu",
             @"menuBar":@"menuBar",
             @"appName":@"appName",
             };
}
#if TARGET_OS_OSX
- (void)handleEvent{
    if (self.subMenuItem && self.subMenuItem.length > 0) {
        [QTSystemSetting clickSubMenuItem:self.subMenuItem ofMenuItem:self.menuItem ofMenu:self.menu ofMenuBar:self.menuBar ofApplication:self.appName];
    }else{
        [QTSystemSetting clickMenuItem:self.menuItem ofMenu:self.menu ofMenuBar:self.menuBar ofApplication:self.appName];
    }
}
#endif
@end

@implementation QTSystemEventModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"qtSystemEventType":@"qtSystemEventType",
             @"paras":@"paras",
             };
}
#if TARGET_OS_OSX
- (void)handleEvent{
    switch (self.qtSystemEventType) {
        case QTSystemEventSleep:
            [QTSystemSetting sleepNow];
            break;
        case QTSystemEventLaunch:
            [QTSystemSetting launchApp:self.paras[@"appName"]];
            break;
        case QTSystemEventVolume:
            [QTSystemSetting setSystemVolume:[self.paras[@"volume"] intValue]];
            break;
        case QTSystemEventBrightness:
            [QTSystemSetting setSystemBrightness:[self.paras[@"brightness"] floatValue]];
            break;
        default:
            break;
    }
}
#endif
@end

@implementation QTMacToiOSModel
+(NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"type":@"type",
             @"frontmostApp":@"frontmostApp",
             @"brightness":@"brightness",
             @"volume":@"volume",
             };
}
@end
