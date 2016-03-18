//
//  QRCodeHelper.h
//  AVFoundation-Scan
//
//  Created by Wolf on 16/3/17.
//  Copyright © 2016年 许毓方. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface QRCodeHelper : NSObject


/**
 *  解析二维码
 *
 *  @param image 原图片
 *
 *  @return 字符串
 */
+ (NSString *)decodeImage:(UIImage *)image;



// http://blog.sina.com.cn/s/blog_693de6100102vtjk.html

/**
 *  生成二维码
 *
 *  @param text  文字
 *  @param imge  图片
 *  @param width 生成后的图片宽高一致, !!! >=62 否则只能扫描( AVFoundation ), 不能解析(生成,解析: CoreImage )
 *
 */
+ (UIImage *)generateQRImageFromText:(NSString *)text image:(UIImage *)imge andSizeWidth:(CGFloat)width;


/**
 *  图片换色, 还扫描不了
 *
 *  @param image 原图
 *  @param red   rgb
 *
 */
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue;


/**
 *  添加中间小图标
 *
 *  @param sourceImage 源二维码
 *  @param cWidth      源二维码图的大小宽
 *  @param img         图标的图片
 *  @param width       图标放在二维码上的大小, !!! 1/5可以,不知道纠错是在哪里设置
 *
 *  @return 加完图标的二维码图
 */
+ (UIImage *)addSourceImage:(UIImage *)sourceImage containSizeWidth:(CGFloat)cWidth image:(UIImage *)img sizeWidth:(CGFloat)width;


@end
