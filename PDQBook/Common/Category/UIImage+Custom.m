//
//  UIImage+Custom.m
//  AirPPT
//
//  Created by Mr.Chou on 15/6/10.
//  Copyright (c) 2015年 周 骏豪. All rights reserved.
//

#import "UIImage+Custom.h"
#import <Accelerate/Accelerate.h>
#import "AppDelegate.h"

@implementation UIImage (Custom)

/**
 *  获得高斯模糊图片
 *
 *  @param blur 0~1浮点系数
 *
 *  @return image
 */
- (UIImage *)blurryImageWithBlurLevel:(CGFloat)blur {
    if ((blur < 0.0f) || (blur > 1.0f)) {
        blur = 0.5f;
    }
    
    int boxSize = (int)(blur * 100);
    boxSize -= (boxSize % 2) + 1;
    
    CGImageRef img = self.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL,
                                       0, 0, boxSize, boxSize, NULL,
                                       kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(self.CGImage));
    
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}


#pragma mark - 页面截图
/**
 获得view截图
 
 @param view 需要截图的view
 @param rect view中需要截图的rect
 
 @return UIImage
 */
+ (UIImage *)imageWithSnapshotView:(UIView *)view inRect:(CGRect)rect {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage,rect)];
    return image;
}

/**
 获得屏幕截图
 
 @return UIImage
 */
+ (UIImage *)imageWithSnapshotScreen {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *mainWindow = appDelegate.window;
//    UIGraphicsBeginImageContext(mainWindow.frame.size);
//    [mainWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsBeginImageContextWithOptions(mainWindow.bounds.size, YES, 1);
    [mainWindow drawViewHierarchyInRect:mainWindow.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //将截图存入相册
    return image;
}











@end
