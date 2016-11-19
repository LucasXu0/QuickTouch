//
//  QTAddCommnadViewController.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/18.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QTAddCommnadViewControllerDelegate <NSObject>

- (void)commandDidAdd:(QTTypeModel *)model;

@end

@interface QTAddCommnadViewController : UIViewController

@property (nonatomic, weak) id<QTAddCommnadViewControllerDelegate> delegate;

@end
