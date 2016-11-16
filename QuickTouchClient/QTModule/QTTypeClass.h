//
//  QTTypeClass.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/17.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QTType) {
    QTConfirm = 1, // confirm message.
    QTMouseEvent, // like click mouse.
    QTSingleWord, // like 'a','ENTER','F1'. 'F1' means F1 key.
    QTPureWords, // like 'abcd','F1'. 'F1' means twos letters(F & 1).
    QTShortCuts, // like 'Command + C', 'Command + v'.
    QTClickMenuItem, // like click menu bar.
    QTSystemSetting, // like launch app, control volume etc.
};

typedef NS_ENUM(NSInteger, QTSystemSettingType) {
    QTSystemSettingLaunch = 1, // launch app
    QTSystemSettingBrightness, // control brightness
    QTSystemSettingVolume, // control volume
    QTSystemSettingSleep, // mac sleep
};


@interface QTTypeClass : NSObject
@end

@interface QTTypeModel : NSObject
@property (nonatomic, assign) QTType qtType;
@property (nonatomic, strong) id qtContent;
@end

@interface QTConfirmModel : NSObject
@end

//example:
//QTSingleWordModel *model = [QTSingleWordModel new];
//model.desc = @"press F1 key";
//model.content = @"F1";
//model.enter = NO;
@interface QTSingleWordModel : NSObject
@property (nonatomic, copy) NSString *desc; // command description
@property (nonatomic, copy) NSString *content;
@end


//example:
//QTPureWordsModel *model = [QTPureWordsModel new];
//model.desc = @"list all files";
//model.content = @"ls -a";
//model.enter = NO;
@interface QTPureWordsModel : NSObject
@property (nonatomic, copy) NSString *desc; // command description
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign, getter=isEnter) BOOL enter; // press enter key after excute content
@end

//example:
//QTShortCutsModel *model = [QTShortCutsModel new];
//model.desc = @"Copy";
//model.functionKeys = @[@"Command"];
//model.plainKey = @"C";
@interface QTShortCutsModel : NSObject
@property (nonatomic, copy) NSString *desc; // command description
@property (nonatomic, strong) NSArray *functionKeys; // Command / Control / Alt / Shift / Fn ( but Fn key did not seem to have effect )
@property (nonatomic, copy) NSString *plainKey; // a b c d ...
@end

//example:
//QTClickMenuItemModel *model = [QTClickMenuItemModel new];
//model.desc = @"open AirDrop";
//model.menuItem = @"AirDrop";
//model.menu = @"前往";
//model.menuBar = @1;
//model.appName = @"Finder";
@interface QTClickMenuItemModel : NSObject
@property (nonatomic, copy) NSString *desc; // command description
@property (nonatomic, copy) NSString *subMenuItem; // optional, if just click menu item without aonther sub menu
@property (nonatomic, copy) NSString *menuItem;
@property (nonatomic, copy) NSString *menu;
@property (nonatomic, assign) NSInteger menuBar; // normoally set @1
@property (nonatomic, copy) NSString *appName;
@end

//example:
//QTSystemSettingModel *model = [QTSystemSettingModel new];
//model.desc = @"Make Mac Sleep";
//model.qtSystemSettingType = QTSystemSettingSleep;
//model.paras = @{@"delay":30};
@interface QTSystemSettingModel : NSObject
@property (nonatomic, copy) NSString *desc; // command description
@property (nonatomic, assign) QTSystemSettingType qtSystemSettingType;
@property (nonatomic, strong) id paras;
@end


