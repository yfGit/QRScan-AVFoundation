//
//  ScanView.h
//  AVFoundation-Scan
//
//  Created by Wolf on 16/3/14.
//  Copyright © 2016年 许毓方. All rights reserved.
//  AVFoundation

#import <UIKit/UIKit.h>

@interface ScanView : UIView

#pragma mark - Properties

/** 是否在扫描 */
@property (nonatomic, assign) BOOL isScan;


/** 动画下降速度,> 0.0 默认 1.0 */
@property (nonatomic, assign) CGFloat speed;


/** 扫描成功返回字符串 */
@property (nonatomic, copy) void(^scanComplete)(NSString *codeStr);


#pragma mark - Init
/**
 *  初始化
 *  没有扫描框线, 整个 frame 扫描
 */
- (instancetype)initWithFrame:(CGRect)frame;



/**
 *  初始化
 *
 *  @param frame         预览frame
 *  @param scanFrame     精准扫描区域,相对frame的位置
 *  @param imageName     扫描框,可以为nil
 *  @param lineImageName 扫描线,可以为nil
 *  
 *  Tip: 如果 CGRectZero, 或等于上一个frame(全屏扫描), scanFrame,imageName, LineImageName 都将无效(没有扫描框和线), 相当于另一个初始化
 */
- (instancetype)initWithFrame:(CGRect)frame
                    scanFrame:(CGRect)scanFrame
              borderImageName:(NSString *)imageName
                lineImageName:(NSString *)lineImageName;



#pragma mark - Method
/**
 *  开始扫描, 一开始没有运行, 自定义可能的下载请求
 */
- (void)startRunning;

/**
 *  暂停扫描
 */
- (void)stopRunning;


@end
