

//
//  ScanAnimView.m
//  AVFoundation-Scan
//
//  Created by Wolf on 16/3/15.
//  Copyright © 2016年 许毓方. All rights reserved.
//

#import "ScanAnimView.h"

@interface ScanAnimView ()


/**
 *  记录当前线条绘制的位置
 */
@property (nonatomic,assign) CGPoint position;

/**
 *  定时器
 */
@property (nonatomic,strong)NSTimer  *timer;

/**
 *  扫描线
 */
@property (nonatomic, copy) NSString *lineName;

@end


@implementation ScanAnimView



#pragma mark- init
- (instancetype)initWithFrame:(CGRect)frame
              borderImageName:(NSString *)imageName
                lineImageName:(NSString *)lineImageName
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        if (imageName) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
            imgView.image = [UIImage imageNamed:imageName];
            [self addSubview:imgView];
        }
        
        
        if (!lineImageName) {
            return self;
        }
        
        _lineName = lineImageName;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    if ( _lineName == nil || _lineName == NULL) {
        return ;
    }
    
    CGPoint newPosition = self.position;
    if (_speed) {
        newPosition.y += _speed;
    }else {
        newPosition.y += 1;
    }
    
    // 判断y到达底部，从新开始下降, 视觉调整
    if (newPosition.y > rect.size.height) {
        newPosition.y = 0;
    }
    
    
    // 重新赋值position
    self.position = newPosition;
    
    // 绘制图片
    UIImage *image = [UIImage imageNamed:_lineName];
    CGRect frame   = CGRectMake(self.position.x, self.position.y, self.bounds.size.width, image.size.height);
    
    [image drawInRect:frame
            blendMode:kCGBlendModeNormal
                alpha:1];
    
}

#pragma mark- action
- (void)startAnimaion
{
    [_timer setFireDate:[NSDate distantPast]];
}

- (void)stopAnimaion
{
    [_timer setFireDate:[NSDate distantFuture]];
}



@end
