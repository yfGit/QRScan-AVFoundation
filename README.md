# QRScan-AVFoundation
AVFoundation 二维码扫描



##扫描: AVFoundation, 生成: CIFilter  解析: CIDetector(5S或以上)
===
##实现的效果:
###1. 扫描区域Rect, 扫描背景, 扫描线和速度 接口
###2. 生成图片(size>=62, 否则只能扫描不能解析(OriginalImage)), 颜色自定义
###3. 解析图片,CIDetector (5S或以上)
###4. 添加图片
<p align="left" >
  <img src="1.png" alt="KYAnimatedPageControl" title="KYAnimatedPageControl" width = "280">
  <img src="2.png" alt="KYAnimatedPageControl" title="KYAnimatedPageControl" width = "280">
  <img src="3.png" alt="KYAnimatedPageControl" title="KYAnimatedPageControl" width = "280">
</p>

##Usage
```
/**
 *  初始化
 *  没有扫描框线, 整个 frame 扫描
 */
- (instancetype)initWithFrame:(CGRect)frame;
```

```
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
```

##License
This project is under MIT License. See LICENSE file for more information.
