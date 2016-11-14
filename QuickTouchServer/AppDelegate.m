//
//  AppDelegate.m
//  QuickTouchServer
//
//  Created by TsuiYuenHong on 2016/11/7.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "AppDelegate.h"
#import "GCDAsyncUdpSocket.h"
#include <Carbon/Carbon.h>
#include <CoreFoundation/CoreFoundation.h>
#import "NSString+KeyCode.h"
#import "QTKey.h"
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate () <GCDAsyncUdpSocketDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (strong) GCDAsyncUdpSocket *udpSocket;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Config UDP Socket
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
#warning 错误信息待完善
    [self.udpSocket bindToPort:QTPORT error:nil];
    [self.udpSocket beginReceiving:nil];
    
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(sendMacInfos) name:NSWorkspaceDidActivateApplicationNotification object:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

#pragma mark - send mac infos
- (void)sendMacInfos{
    NSLog(@"%@",[NSWorkspace sharedWorkspace].frontmostApplication.localizedName);
    NSDictionary *macInfos = @{
                               @"currentAppName":[NSWorkspace sharedWorkspace].frontmostApplication.localizedName,
                               
                               };
    NSData *macInfosData = [NSJSONSerialization dataWithJSONObject:macInfos options:NSJSONWritingPrettyPrinted error:nil];
    [self.udpSocket sendData:macInfosData toHost:QTHOST port:9526 withTimeout:1.0 tag:0];
}

#pragma mark - GCDAsyncUdpSocketDelegate
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{    
    // 解析 Command Dict
    NSDictionary *commandDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",commandDict);
    QTCommandType commandType = [commandDict[@"commandType"] integerValue];
    
    switch (commandType) {
        case QTCommandOne:{
            NSString *command = commandDict[@"command"];
            BOOL isEnter = [commandDict[@"isEnter"] boolValue];
            [self handleTypeOneCommand:command isEnter:isEnter];
        }
            break;
        case QTCommandTwo:{
            NSArray *functionkeys = commandDict[@"functionKeys"];
            NSString *commandKey = commandDict[@"commandKeys"];
            [self handleTypeTwoCommandKey:commandKey functionKeys:functionkeys];
        }
            break;
        case QTCommandThree:{
        
        }
            break;
        case QTCommandSpecial:{
            NSString *command = commandDict[@"command"];
            [self handleTypeSpecialCommand:command];
        }
            break;
        case QTCommandMultiKeys:{
            NSString *normalKey = commandDict[@"normalKey"];
            NSArray *functionKeys = commandDict[@"functionKeys"];
            [self handleTypeMultiNormalKey:normalKey functionKeys:functionKeys];
        }
            break;
        case QTCommandSuperCustom:{
            NSString *command = commandDict[@"command"];
            [QTSystemSetting launchApp:command];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 处理 QTCommandType
- (void)handleTypeOneCommand:(NSString *) command isEnter:(BOOL)isEnter{
    NSString *each = @"";
    CGKeyCode keyCode;
     for (int i = 0 ; i < command.length ; i++) {
        each = [NSString stringWithFormat:@"%c",[command characterAtIndex:i]];
        keyCode = [NSString keyCodeFormKeyString:each];
         [QTKey pressNormalKey:keyCode];
     }
    
    if (isEnter) {
        keyCode = [NSString keyCodeFormKeyString:@"ENTER"];
        [QTKey pressNormalKey:keyCode];
    }
}

- (void)handleTypeTwoCommandKey:(NSString *) command functionKeys:(NSArray *)functionKeys{
    CGKeyCode commandKC = [NSString keyCodeFormKeyString:command];
    [QTKey pressNormalKey:commandKC withFlags:functionKeys];
}

- (void)handleTypeSpecialCommand:(NSString *) command{
    CGKeyCode keyCode = [NSString keyCodeFormKeyString:command];
    [QTKey pressNormalKey:keyCode];
}

- (void)handleTypeMultiNormalKey:(NSString *) normalKey functionKeys:(NSArray *)functionKeys{
    CGKeyCode commandKC = [NSString keyCodeFormKeyString:normalKey];
    [QTKey pressNormalKey:commandKC withFlags:functionKeys];
}

@end
