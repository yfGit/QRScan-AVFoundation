//
//  ScanViewController.m
//  AVFoundation-Scan
//
//  Created by Wolf on 16/3/14.
//  Copyright © 2016年 许毓方. All rights reserved.
//

#import "ScanViewController.h"

#import "ScanView.h"
#import "ViewController.h"

@interface ScanViewController ()
{}

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) ScanView *scanView;
@end

@implementation ScanViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_scanView.isScan) {
        [_scanView startRunning];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_scanView.isScan) {
        [_scanView stopRunning];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描";
    
    
    CGRect frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64);
    CGRect scanFrame = CGRectMake(frame.size.width/2-100, frame.size.height/2-100-64, 200, 200);
    
    
    _scanView = [[ScanView alloc] initWithFrame:frame
                                      scanFrame:scanFrame
                                borderImageName:@"frame_icon"
                                  lineImageName:@"line"];
    _scanView.speed = .5;
   
    
    [self.view addSubview:_scanView];

    [_scanView startRunning]; 
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(_scanView) weakScan = _scanView;
    _scanView.scanComplete = ^(NSString *codeStr) {
        
        weakSelf.infoLabel.text = codeStr;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakScan startRunning];
//            [weakSelf.navigationController pushViewController:[[ViewController alloc] init] animated:YES];
        });
    };
    
    
    
    
    
    
    
    
    // 测试-提示框
    UILabel *label  = [[UILabel alloc] init];
    label.frame     = CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, CGRectGetMaxY(scanFrame)+64, 200, 40);
    label.text      = @"将二维码放入框中 ,即开始扫描";
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    // 测试-显示字符
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.frame        = CGRectMake(0, CGRectGetMaxY(label.frame)+20, [UIScreen mainScreen].bounds.size.width, 40);
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_infoLabel];
}



- (void)dealloc
{
    NSLog(@"%s",__func__);
}



@end
