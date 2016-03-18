//
//  ScanAnimView.h
//  AVFoundation-Scan
//
//  Created by Wolf on 16/3/15.
//  Copyright © 2016年 许毓方. All rights reserved.
//  动画

#import <UIKit/UIKit.h>

@interface ScanAnimView : UIView


@property (nonatomic, assign) BOOL isNeedAlpha;
@property (nonatomic, assign) CGFloat speed;


/**
 *  初始化
 *
 *  @param frame         frame
 *  @param imageName     扫描框
 *  @param lineImageName 扫描线
 *
 */
- (instancetype)initWithFrame:(CGRect)frame
              borderImageName:(NSString *)imageName
                lineImageName:(NSString *)lineImageName;

/**
 *  开始动画
 */
-(void)startAnimaion;

/**
 *  暂停动画
 */
-(void)stopAnimaion;

@end
