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

typedef NS_ENUM(NSUInteger, QTCommandType) {
    QTCommandOne = 1, // 普通键 没有功能键 如 pwd / ls
    QTCommandTwo, // 单功能键 + 普通键 如 Command + c
    QTCommandThree, // 双功能键 + 普通键 如 Command + Shift + →
};

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
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

# pragma mark - GCDAsyncUdpSocketDelegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext{    
    // 解析 Command Dict
    NSDictionary *commandDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"%@",commandDict);
    NSUInteger commandType = [commandDict[@"commandType"] integerValue];
    
    switch (commandType) {
        case 1:{
            NSString *command = commandDict[@"command"];
            BOOL isEnter = [commandDict[@"isEnter"] boolValue];
            [self handleTypeOneCommand:command isEnter:isEnter];
        }
            break;
        case 2:{
            NSString *functionkey = commandDict[@"functionkey"];
            NSString *commandKey = commandDict[@"commandKey"];
            [self handleTypeOneCommandKey:nil functionKey:nil];
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
         [self pressKey:keyCode];
     }
    
    if (isEnter) {
        keyCode = [NSString keyCodeFormKeyString:@"ENTER"];
        [self pressKey:keyCode];
    }
}

- (void)handleTypeOneCommandKey:(NSString *) command functionKey:(NSString *)functionKey{
    CGKeyCode keyCode = [NSString keyCodeFormKeyString:@"F11"];
    [self pressKey:keyCode];
}

- (void)pressKey:(CGKeyCode) keyCode{
    CGEventRef eventDown, eventUp;
    eventDown = CGEventCreateKeyboardEvent(nil, keyCode, YES);
    eventUp = CGEventCreateKeyboardEvent(nil, keyCode, NO);
    CGEventPost(kCGHIDEventTap, eventDown);
    sleep(0.0001);
    CGEventPost(kCGHIDEventTap, eventUp);
    CFRelease(eventUp);
    CFRelease(eventDown);
}

@end
