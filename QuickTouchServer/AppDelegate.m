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
#import "BabyBluetooth.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSImageView *qrCodeImage;
@property (weak) IBOutlet NSTextField *ipAddressLabel;
@property (weak) IBOutlet NSTextField *sendPortLabel;
@property (weak) IBOutlet NSTextField *receivePortLabel;
@property (weak) IBOutlet NSTextField *iOSIPInfosLabel;

@property (strong) QTProcessor *qtProcessor;

@end

@implementation AppDelegate{
    BabyBluetooth *baby;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    baby = [BabyBluetooth shareBabyBluetooth];
    [self babyDelegate];
    baby.scanForPeripherals().begin().stop(100);

    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserDeafault_iOSLocalIP]) {
        [QTProcessor sharedInstance].host = [[NSUserDefaults standardUserDefaults] objectForKey:UserDeafault_iOSLocalIP];
        self.iOSIPInfosLabel.stringValue = [NSString stringWithFormat:@"iOS IP:%@ Send:%d Rece:%d",[QTProcessor sharedInstance].host,QTRECEIVEPORT,QTSENDPORT];
    }
    
    [QTProcessor sharedInstance].recePort = QTRECEIVEPORT;
    [QTProcessor sharedInstance].sendPort = QTSENDPORT;
    [[QTProcessor sharedInstance] beginReceiving];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(sendMacInfos) name:NSWorkspaceDidActivateApplicationNotification object:nil];

    [self configSubviews];
}

//设置蓝牙委托
-(void)babyDelegate{
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@",peripheral.name);
    }];
    
    //过滤器
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        //最常用的场景是查找某一个前缀开头的设备
        //if ([peripheralName hasPrefix:@"Pxxxx"] ) {
        //    return YES;
        //}
        //return NO;
        NSLog(@"%@",peripheralName);
        //设置查找规则是名称大于1 ， the search rule is peripheral.name length > 1
        if (peripheralName.length >1) {
            return YES;
        }
        return NO;
    }];
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

#pragma mark - Send Mac Infos
- (void)sendMacInfos{
    QTMacToiOSModel *qtMacToiOSModel = [QTMacToiOSModel new];
    qtMacToiOSModel.type = QTMacToiOSFrontmostApp;
    qtMacToiOSModel.frontmostApp = [NSWorkspace sharedWorkspace].frontmostApplication.localizedName;
    QTTypeModel *qtTypeModel = [QTTypeModel new];
    qtTypeModel.qtDesc = @"发送 Mac 系统信息";
    qtTypeModel.qtType = QTMacToiOS;
    qtTypeModel.qtContent = qtMacToiOSModel;
    [[QTProcessor sharedInstance] sendQTTypeModel:qtTypeModel];
}

@end
