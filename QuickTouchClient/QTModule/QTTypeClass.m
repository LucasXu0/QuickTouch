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
@end

@implementation QTConfirmModel
@end

@implementation QTSingleWordModel
#if TARGET_OS_OSX
- (void)handleEvent{
    CGKeyCode keyCode = [NSString keyCodeFormKeyString:self.content];
    [QTKey pressNormalKey:keyCode];
}
#endif
@end

@implementation QTPureWordsModel
#if TARGET_OS_OSX
- (void)handleEvent{
    NSString *each = @"";
    CGKeyCode keyCode;
    for (int i = 0 ; i < self.content.length ; i++) {
        each = [NSString stringWithFormat:@"%c",[self.content characterAtIndex:i]];
        keyCode = [NSString keyCodeFormKeyString:each];
        [QTKey pressNormalKey:keyCode];
    }
    
    if (self.isEnter) {
        keyCode = [NSString keyCodeFormKeyString:@"ENTER"];
        [QTKey pressNormalKey:keyCode];
    }
}
#endif
@end

@implementation QTShortCutsModel
#if TARGET_OS_OSX
- (void)handleEvent{
    CGKeyCode keyCode = [NSString keyCodeFormKeyString:self.plainKey];
    [QTKey pressNormalKey:keyCode withFlags:self.functionKeys];
}
#endif
@end

@implementation QTClickMenuItemModel
#if TARGET_OS_OSX
- (void)handleEvent{
    if (self.subMenuItem) {
        [QTSystemSetting clickSubMenuItem:self.subMenuItem ofMenuItem:self.menuItem ofMenu:self.menu ofMenuBar:self.menuBar ofApplication:self.appName];
    }else{
        [QTSystemSetting clickMenuItem:self.menuItem ofMenu:self.menu ofMenuBar:self.menuBar ofApplication:self.appName];
    }
}
#endif
@end

@implementation QTSystemEventModel
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
