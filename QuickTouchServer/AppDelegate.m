//
//  AppDelegate.m
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 2016/11/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "AppDelegate.h"
#import "QRCodeCreator.h"
#import "QTProcessor.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *qrCodeImage;
@property (weak) IBOutlet NSTextField *ipAddressLabel;
@property (weak) IBOutlet NSTextField *sendPortLabel;
@property (weak) IBOutlet NSTextField *receivePortLabel;

@property (strong) QTProcessor *qtProcessor;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    [QTProcessor sharedInstance].recePort = 9527;
    [[QTProcessor sharedInstance] beginReceiving];
    
   // [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(sendMacInfos) name:NSWorkspaceDidActivateApplicationNotification object:nil];

    [self configSubviews];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - Config Subviews
- (void)configSubviews{
    self.ipAddressLabel.stringValue = [NSString stringWithFormat:@"Local IP : %@",[QTSystemSetting getLocalIPAddress]];
    self.sendPortLabel.stringValue = [NSString stringWithFormat:@"Send Port : %d",QTSENDPORT];
    self.receivePortLabel.stringValue = [NSString stringWithFormat:@"Rece Port : %d",QTRECEIVEPORT];
    NSString *qrString = [NSString stringWithFormat:@"%@/%d/%d",[QTSystemSetting getLocalIPAddress],QTRECEIVEPORT,QTSENDPORT];
    self.qrCodeImage.image = [QRCodeCreator qrImageForString:qrString imageSize:150];
}

//#pragma mark - Send Mac Infos
//- (void)sendMacInfos{
//    NSDictionary *macInfos = @{
//                               @"currentAppName":[NSWorkspace sharedWorkspace].frontmostApplication.localizedName,
//                               };
//    NSData *macInfosData = [NSJSONSerialization dataWithJSONObject:macInfos options:NSJSONWritingPrettyPrinted error:nil];
//    [_udpSocket sendData:macInfosData toHost:QTHOST port:QTSENDPORT withTimeout:1.0 tag:0];
//}
@end
