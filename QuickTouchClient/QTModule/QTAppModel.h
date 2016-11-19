//
//  QTAppModel.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/18.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTAppModel : NSObject

@property (nonatomic, copy) NSString *appName;
@property (nonatomic, strong) NSArray< NSArray <QTTypeClass *> *> *appCommands;

@end
