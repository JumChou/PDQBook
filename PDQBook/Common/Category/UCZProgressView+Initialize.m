//
//  UCZProgressView+Initialize.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/8.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "UCZProgressView+Initialize.h"
#import "CommonDefine.h"

#define Color_Progress      [UIColor colorWithHexString:@"B9C4DA"]
#define Color_ProgressBG    [UIColor colorWithHexString:@"f3f4f4"];

@implementation UCZProgressView (Initialize)

- (id)initProgressTextStyle {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        self.indeterminate = YES;
        self.showsText = YES;
        //self.tintColor = [UIColor whiteColor];
        //self.textColor = [UIColor whiteColor];
        //self.backgroundView.backgroundColor = [UIColor colorWithHexString:@"C9D0DF"];
        UIColor *circleColor = Color_Progress;
        self.tintColor = circleColor;
        self.textColor = circleColor;
        self.backgroundView.backgroundColor = Color_ProgressBG;
        //self.progressView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //self.progressView.usesVibrancyEffect = NO; // Turn off vibrancy effect to display custom color, if uses blur effect
        //self.progressView.lineWidth = [[NSUserDefaults standardUserDefaults] doubleForKey:@"lineWidth"];
        //self.progressView.radius = [[NSUserDefaults standardUserDefaults] doubleForKey:@"radius"];
        //self.progressView.textSize = [[NSUserDefaults standardUserDefaults] doubleForKey:@"textFontSize"];
    }
    
    return self;
}

- (id)initLoadingStyleWithIsUseArcAnim:(BOOL)isUseArcAnimation {
    self = [self initWithFrame:CGRectMake(0, 0, 0, 0)];
    if (self) {
        self.isUseArcAnimation = isUseArcAnimation;
        
        self.indeterminate = YES;
        self.showsText = NO;
        self.tintColor = Color_Progress;
        self.backgroundView.backgroundColor = Color_ProgressBG;
//        self.backgroundView.backgroundColor = [UIColor whiteColor];
        //self.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        //self.usesVibrancyEffect = NO;
    }
    
    return self;
}



@end
