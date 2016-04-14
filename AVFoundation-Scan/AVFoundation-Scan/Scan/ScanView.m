
//
//  ScanView.m
//  AVFoundation-Scan
//
//  Created by Wolf on 16/3/14.
//  Copyright © 2016年 许毓方. All rights reserved.
//

#import "ScanView.h"
#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import "ScanInterestView.h"
#import "ScanAnimView.h"


@interface ScanView ()<AVCaptureMetadataOutputObjectsDelegate>
{}
// 二维码
@property (nonatomic, strong) AVCaptureSession *session;

@property (nonatomic, strong) ScanInterestView *interestView;
@property (nonatomic, strong) ScanAnimView *animView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end


@implementation ScanView



#pragma mark- init
- (void)didMoveToSuperview
{
    if (_speed > 0.0) {
        _animView.speed = _speed;
    }
}


- (instancetype)initWithFrame:(CGRect)frame
                    scanFrame:(CGRect)scanFrame
              borderImageName:(NSString *)imageName
                lineImageName:(NSString *)lineImageName;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupScanWithScanFrame:scanFrame borderImageName:imageName lineImageName:lineImageName];
    
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupScanWithScanFrame:CGRectZero borderImageName:nil lineImageName:nil];
    }
    return self;
}


- (void)setupScanWithScanFrame:(CGRect)scanFrame
               borderImageName:(NSString *)imageName
                 lineImageName:(NSString *)lineImageName
{
    
    // 判断是否允许使用相机 iOS7 and later 设置--隐私--相机
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            NSString *str = [NSString stringWithFormat:@"请在系统设置－%@－相机中打开允许使用相机",  [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return ;
        }
    }
    
    // 摄像头
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 输入流
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"%@",error.localizedDescription);
        return;
    }
    // 输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 代理,主线程刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    // 初始化链接对象
    _session = [[AVCaptureSession alloc] init];
    
    // 采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    [_session addInput:input];
    [_session addOutput:output];
    
    // 支持的编码格式
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // 预览图层
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = self.bounds;
    _previewLayer = previewLayer;
    [self.layer addSublayer:previewLayer];
    
    // 精确扫描, 坑, 这个值是按比例0~1设置，而且X、Y要调换位置，width、height调换位置
    if (!CGRectIsEmpty(scanFrame) || !CGRectEqualToRect(self.frame, scanFrame)) {
        
        // 区域
        output.rectOfInterest = CGRectMake(scanFrame.origin.y / self.frame.size.height,
                                           scanFrame.origin.x / self.frame.size.width,
                                           scanFrame.size.height / self.frame.size.height,
                                           scanFrame.size.width / self.frame.size.width);
        
        // 显示
        _interestView = [[ScanInterestView alloc] initWithFrame:self.bounds];
        [self addSubview:_interestView];  // drawRect 在控制器viewDidLoad走完后才调
        _interestView.scanFrame = scanFrame;
        
        
        // 动画
        _animView = [[ScanAnimView alloc] initWithFrame:scanFrame borderImageName:imageName lineImageName:lineImageName];
        
        [self addSubview:_animView];
    }
    
//    [_session startRunning];
}

#pragma mark- action

- (BOOL)isScan
{
    return _session.isRunning;
}


- (void)startRunning
{
    if (!_session.isRunning) {
        
        [[_previewLayer connection] setEnabled:YES];
        [_session startRunning];
        [_animView startAnimaion];
    }
}

- (void)stopRunning
{
    if (_session.isRunning) {
        
        [_session stopRunning];
        [[_previewLayer connection] setEnabled:NO];
        [_animView stopAnimaion];
    }
}


#pragma mark- delegate 
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (!_session.isRunning) return; // 不止调一次
    
    if (metadataObjects.count > 0) {
        
        [self stopRunning]; // 坑
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *code = metadataObject.stringValue;
        
        if (self.scanComplete) {
            self.scanComplete(code);
        }
    }
}







@end
