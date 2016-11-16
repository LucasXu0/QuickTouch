//
//  QRCodeCreator.h
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/16.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeCreator : NSObject
// 生成二维码
+ (NSImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)imageWidth;
@end
