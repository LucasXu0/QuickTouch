//
//  QTTypeClass.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/17.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"
typedef NS_ENUM(NSInteger, QTType) {
    QTConfirm = 1, // confirm message.
    QTMouseEvent, // like click mouse.
    QTSingleWord, // like 'a','ENTER','F1'. 'F1' means F1 key.
    QTPureWords, // like 'abcd','F1'. 'F1' means twos letters(F & 1).
    QTShortCuts, // like 'Command + C', 'Command + v'.
    QTClickMenuItem, // like click menu bar.
    QTSystemEvent, // like launch app, control volume etc.
    QTMacToiOS, // infos mac send to iOS
    QTiOSHost,
};

typedef NS_ENUM(NSInteger, QTSystemEventType) {
    QTSystemEventLaunch = 1, // launch app
    QTSystemEventBrightness, // control brightness
    QTSystemEventVolume, // control volume
    QTSystemEventSleep, // mac sleep
};

typedef NS_ENUM(NSInteger, QTMacToiOSType) {
    QTMacToiOSFrontmostApp = 1, // Mac frontmost app
    QTMacToiOSBrightness, // Mac current brightness
    QTMacToiOSVolume, // Mac current volume
};

@interface QTTypeClass : NSObject
@end

@interface QTConfirmModel : NSObject
@end

@interface QTTypeModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *qtDesc; // command description
@property (nonatomic, assign) QTType qtType;
@property (nonatomic, strong) id qtContent;
@end

//example:
//QTSingleWordModel *model = [QTSingleWordModel new];
//model.content = @"F1";
//model.enter = NO;
@interface QTSingleWordModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *content;
- (void)handleEvent;
@end


//example:
//QTPureWordsModel *model = [QTPureWordsModel new];
//model.content = @"ls -a";
//model.enter = NO;
@interface QTPureWordsModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign ) BOOL enter; // press enter key after excute content
- (void)handleEvent;
@end

//example:
//QTShortCutsModel *model = [QTShortCutsModel new];
//model.functionKeys = @[@"Command"];
//model.plainKey = @"C";
@interface QTShortCutsModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong) NSArray *functionKeys; // Command / Control / Alt / Shift / Fn ( but Fn key did not seem to have effect )
@property (nonatomic, copy) NSString *plainKey; // a b c d ...
- (void)handleEvent;
@end

//example:
//QTClickMenuItemModel *model = [QTClickMenuItemModel new];
//model.menuItem = @"AirDrop";
//model.menu = @"前往";
//model.menuBar = @1;
//model.appName = @"Finder";
@interface QTClickMenuItemModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *subMenuItem; // optional, if just click menu item without aonther sub menu
@property (nonatomic, copy) NSString *menuItem;
@property (nonatomic, copy) NSString *menu;
@property (nonatomic, assign) NSInteger menuBar; // normoally set @1
@property (nonatomic, copy) NSString *appName;
- (void)handleEvent;
@end

//example:
//QTSystemSettingModel *model = [QTSystemSettingModel new];
//model.desc = @"Make Mac Sleep";
//model.qtSystemSettingType = QTSystemSettingSleep;
//model.paras = @{@"delay":30};
@interface QTSystemEventModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, assign) QTSystemEventType qtSystemEventType;
@property (nonatomic, strong) id paras;
- (void)handleEvent;
@end

@interface QTMacToiOSModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, assign) QTMacToiOSType type;
@property (nonatomic, strong) NSString *frontmostApp;
@property (nonatomic, strong) NSString *brightness;
@property (nonatomic, strong) NSString *volume;
@end
