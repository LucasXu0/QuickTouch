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
    
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
    mask.layer.borderWidth = kBorderW;
    
    mask.bounds = CGRectMake(0, 0, self.view.sd_width + kBorderW + kMargin , self.view.sd_width + kBorderW + kMargin);
    mask.center = CGPointMake(self.view.sd_width * 0.5, self.view.sd_height * 0.5);
    mask.sd_y = 0;
    
    [self.view addSubview:mask];
    _maskView = mask;
}

- (void)beginScanning
{
    // 取后置摄像头为输入设备
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 初始化输入源
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) return;
    // 初始化输出源
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
    // 设置代理
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    CGRect scanCrop=[self getScanCrop:_scanWindow.bounds readerViewBounds:self.view.frame];
    output.rectOfInterest = scanCrop;
    
    // 生成会话
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    
    // 设置识别类型为二维码
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.frame;
    [self.view.layer insertSublayer:layer atIndex:0];
    
    // 开始识别
    [_session startRunning];
}

-(void)setupTipTitleView{
    
    UIView *mask = [[UIView alloc] initWithFrame:CGRectMake(0, _maskView.sd_y+_maskView.sd_height, self.view.sd_width, kBorderW)];
    mask.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
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
//        NSDictionary *commandDict = @{
//                                      @"commandType":toNSNumber(QTCommandConfirm),
//                                      @"iOSLocalIP":[Util localIPAddress],
//                                      };
//        [[CommandSender sharedInstance] sendCommandDict:commandDict];
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        NSString *qrString = metadataObject.stringValue;
        NSArray *qrArray = [qrString componentsSeparatedByString:@"/"];
        [[NSUserDefaults standardUserDefaults] setObject:qrArray forKey:QTHostPortInfos];
        [[QTProcessor sharedInstance] configHostAndPort:qrArray];
        
        
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


@end
