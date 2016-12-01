//
//  JCColorfulCircleView.h
//  PDQBook
//
//  Created by Mr.Chou on 2016/11/16.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCColorfulCircleView : UIView

- (void)drawCircleWithColors:(NSArray<UIColor *> *)colors
              colorLocations:(NSArray<NSNumber *> *)locations
          colorWidthMultiple:(CGFloat)widthMultiple
                     percent:(CGFloat)percent
            animatedDuration:(CFTimeInterval)animatedDuration;


@end
