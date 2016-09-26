//
//  UIImage+Custom.h
//  AirPPT
//
//  Created by Mr.Chou on 15/6/10.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Custom)

/**
 *  获得高斯模糊图片
 *
 *  @param blur 0~1浮点系数
 *
 *  @return image
 */
- (UIImage *)blurryImageWithBlurLevel:(CGFloat)blur;


#pragma mark - 页面截图
/**
 获得view截图

 @param view 需要截图的view
 @param rect view中需要截图的rect

 @return UIImage
 */
+ (UIImage *)imageWithSnapshotView:(UIView *)view inRect:(CGRect)rect;

/**
 获得屏幕截图
 
 @return UIImage
 */
+ (UIImage *)imageWithSnapshotScreen;


@end
