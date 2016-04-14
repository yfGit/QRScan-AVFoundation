//
//  ViewController.m
//  AVFoundation-Scan
//
//  Created by Wolf on 16/3/14.
//  Copyright © 2016年 许毓方. All rights reserved.
//

#import "ViewController.h"
#import "ScanViewController.h"
#import "QRCodeHelper.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

/** 扫描结果 */
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

/** 文字 */
@property (weak, nonatomic) IBOutlet UITextField *textFeild;
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgView;


@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];


    // 方法注释在 .h

    self.view.backgroundColor = [UIColor whiteColor];
    _imgView.layer.borderColor = [UIColor redColor].CGColor;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap)];
    [_imgView addGestureRecognizer:tap];
    
    UITapGestureRecognizer *qrTapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrTap)];
    [_qrImgView addGestureRecognizer:qrTapG];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textFeild resignFirstResponder];
}



#pragma mark - 扫描
- (IBAction)scan:(UIButton *)sender {
    [self.navigationController pushViewController:[[ScanViewController alloc] init] animated:YES];
}



#pragma mark - 解析

- (IBAction)resolutionImage:(id)sender {

    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate      = self;
    imgPicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
}




#pragma mark - 生成
- (IBAction)generateQR:(UIButton *)sender {
    
    UIImage *image = [QRCodeHelper generateQRImageFromText:_textFeild.text
                                                     image:_imgView.image
                                              andSizeWidth:_imgView.frame.size.width
                      ];
    
    

    // 颜色
    image = [QRCodeHelper imageBlackToTransparent:image withRed:200 andGreen:0 andBlue:0];
    
    if (_imgView.image) {
        
        image = [QRCodeHelper addSourceImage:image
                            containSizeWidth:_qrImgView.frame.size.width
                                       image:_imgView.image
                                   sizeWidth:_qrImgView.frame.size.width/5];
    }
    
    _qrImgView.image = image;
    
    _bgView.alpha = 1;
}


#pragma mark - imageView - Action

- (void)imageTap
{
    // 根据需求变换 editing
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate      = self;
    imgPicker.sourceType    = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
}

- (void)qrTap
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"保存到相册" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImageWriteToSavedPhotosAlbum(_qrImgView.image, nil, nil, nil);
        _bgView.alpha = 0;
        
    }];
    [alert addAction:action];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
   
}

#pragma mark - 清空 textfield,imageView
- (IBAction)clearup:(UIButton *)sender {
    
    _textFeild.text = @"";
    _imgView.image  = nil;
}

#pragma mark - delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image   = info[UIImagePickerControllerOriginalImage];
    NSString *str    = [QRCodeHelper decodeImage:image];
    _resultLabel.text = str;
    _imgView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
