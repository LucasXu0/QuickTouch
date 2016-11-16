//
//  ScanQRCodeViewController.m
//  QuickTouchClient
//
//  Created by TsuiYuenHong on 2016/11/16.
//  Copyright © 2016年 TsuiYuenHong. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+SDExtension.h"
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
static const CGFloat kMargin = 30;
static const CGFloat kBorderW = 100;
@interface ScanQRCodeViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) UIView *scanWindow;
@property (nonatomic, weak)   UIView *maskView;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMaskView];
    [self setupTipTitleView];
    [self setupScanWindowView];
    [self beginScanning];

}

- (void)setupMaskView
{
    UIView *mask = [[UIView alloc] init];
    _maskView = mask;
    
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    mask.layer.borderWidth = kBorderW;
    
    mask.bounds = CGRectMake(0, 0, self.view.sd_width + kBorderW + kMargin , self.view.sd_width + kBorderW + kMargin);
    mask.center = CGPointMake(self.view.sd_width * 0.5, self.view.sd_height * 0.5);
    mask.sd_y = 0;
    
    [self.view addSubview:mask];
}

- (void)beginScanning
{
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    CGRect scanCrop=[self getScanCrop:_scanWindow.bounds readerViewBounds:self.view.frame];
    output.rectOfInterest = scanCrop;
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    [_session startRunning];
}

-(void)setupTipTitleView{
    
    UIView *mask=[[UIView alloc]initWithFrame:CGRectMake(0, _maskView.sd_y+_maskView.sd_height, self.view.sd_width, kBorderW)];
    mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:mask];
    
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.sd_height*0.9-kBorderW*2, self.view.bounds.size.width, kBorderW)];
    tipLabel.text = @"将取景框对准二维码，即可自动扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font=[UIFont systemFontOfSize:12];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
    
}
- (void)setupScanWindowView{
    CGFloat scanWindowH = self.view.frame.size.width - kMargin * 2;
    CGFloat scanWindowW = self.view.frame.size.width - kMargin * 2;
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW, scanWindowW, scanWindowH)];
    _scanWindow.clipsToBounds = YES;
    [self.view addSubview:_scanWindow];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        NSDictionary *commandDict = @{
                                      @"commandType":toNSNumber(QTCommandConfirm),
                                      @"iOSLocalIP":[self localIPAddress],
                                      };
        [[CommandSender sharedInstance] sendCommandDict:commandDict];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *qrString = metadataObject.stringValue;
        NSArray *qrArray = [qrString componentsSeparatedByString:@"/"];
        [[NSUserDefaults standardUserDefaults] setObject:qrArray forKey:QTHostPortInfos];
        [[CommandSender sharedInstance] configHostAndPort:qrArray];
        
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"扫描成功" message:@"端口配置成功" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertC animated:NO completion:nil];
        
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            [self dismissViewControllerAnimated:alertC completion:nil];
            [self.navigationController popViewControllerAnimated:NO];
        });
    }
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds{
    CGFloat x,y,width,height;
    
    x = (CGRectGetHeight(readerViewBounds)-CGRectGetHeight(rect))/2/CGRectGetHeight(readerViewBounds);
    y = (CGRectGetWidth(readerViewBounds)-CGRectGetWidth(rect))/2/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)localIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
