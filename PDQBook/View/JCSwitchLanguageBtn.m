//
//  JCSwitchLanguageBtn.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/23.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "JCSwitchLanguageBtn.h"
#import "CommonDefine.h"

//#define FONT_B  [UIFont boldSystemFontOfSize:13.f]
#define FONT_B  [UIFont systemFontOfSize:13.f]
#define FONT_N  [UIFont systemFontOfSize:9.f]

@interface JCSwitchLanguageBtn ()

@property (nonatomic, strong) UILabel *labCN;
@property (nonatomic, strong) UILabel *labEN;


@end

@implementation JCSwitchLanguageBtn

+ (JCSwitchLanguageBtn *)buttonWithStatus:(SwitchLanguageBtnStatus)status {
    JCSwitchLanguageBtn *btn = [self buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 35, 35);
//    btn.basicColor = Color_White;
//    btn.selectedColor = Color_LightBlue;
    btn.backgroundColor = [UIColor clearColor];
//    btn.layer.shadowColor = [UIColor blackColor].CGColor;
//    btn.layer.shadowOffset = CGSizeMake(1, 1);
//    btn.layer.shadowOpacity = 0.5;  //阴影透明度，默认0
//    btn.layer.shadowRadius = 4;     //阴影半径，默认3
//    [btn initViews];
    btn.languageStatus = status;
    if (status == SwitchLanguageBtnStatus_CN) {
        [btn setImage:[UIImage imageNamed:@"SwitchLanguageBtn_CN"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"SwitchLanguageBtn_CN"] forState:UIControlStateNormal];
    } else {
        [btn setImage:[UIImage imageNamed:@"SwitchLanguageBtn_EN"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"SwitchLanguageBtn_EN"] forState:UIControlStateNormal];
    }
    
    return btn;
}

- (void)initViews {
    UIView *lineView = [UIView new];
    lineView.backgroundColor = self.basicColor;
    lineView.userInteractionEnabled = NO;
    [self addSubview:lineView];
    [lineView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(-1.f);
        make.centerY.equalTo(self);
        make.width.equalTo(1.f);
        make.height.equalTo(self.height).multipliedBy(1.f/2.f);
    }];
    CGFloat radion = DEGREES_TO_RADIANS(30.f);
    CGAffineTransform transform = CGAffineTransformMakeRotation(radion);
    lineView.transform = transform;
    
    self.labCN = [[UILabel alloc] init];
    self.labCN.backgroundColor = [UIColor clearColor];
    self.labCN.userInteractionEnabled = NO;
    self.labCN.text = @"中";
    self.labCN.textColor = (self.languageStatus == SwitchLanguageBtnStatus_CN ? self.selectedColor : self.basicColor);
    self.labCN.font = (self.languageStatus == SwitchLanguageBtnStatus_CN ? FONT_B : FONT_N);
//    self.labCN.textColor = [UIColor greenColor];
//    self.labCN.font = FONT_N;
    self.labCN.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labCN];
    [self.labCN makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.trailing.equalTo(self.centerX);
        make.width.equalTo(self).multipliedBy(0.5f);
        make.height.equalTo(self).multipliedBy(0.70f);
    }];
    
    self.labEN = [[UILabel alloc] init];
    self.labEN.backgroundColor = [UIColor clearColor];
    self.labEN.userInteractionEnabled = NO;
    self.labEN.text = @"En";
    self.labEN.textColor = (self.languageStatus == SwitchLanguageBtnStatus_EN ? self.selectedColor : self.basicColor);
    self.labEN.font = (self.languageStatus == SwitchLanguageBtnStatus_EN ? FONT_B : FONT_N);
//    self.labEN.textColor = [UIColor redColor];
//    self.labEN.font = FONT_N;
    self.labEN.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.labEN];
    [self.labEN makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.leading.equalTo(self.centerX).offset(-4.f);
        make.width.equalTo(self).multipliedBy(0.5f);
        make.height.equalTo(self).multipliedBy(0.70f);
    }];
    
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    if (self.touchInside) {
        [self switchStatus];
    }
}

- (void)switchStatus {
    if (self.languageStatus == SwitchLanguageBtnStatus_CN) { // 中->英
        self.languageStatus = SwitchLanguageBtnStatus_EN;
//        [self animatedExchangeTheLayer:self.labCN.layer withLayer:self.labEN.layer];
//        self.labCN.textColor = self.basicColor;
//        self.labCN.font = FONT_N;
//        self.labEN.textColor = self.selectedColor;
//        self.labEN.font = FONT_B;
        [self setImage:[UIImage imageNamed:@"SwitchLanguageBtn_EN"] forState:UIControlStateNormal];
        
    } else { // 英->中
        self.languageStatus = SwitchLanguageBtnStatus_CN;
//        [self animatedExchangeTheLayer:self.labEN.layer withLayer:self.labCN.layer];
//        self.labCN.textColor = self.selectedColor;
//        self.labCN.font = FONT_B;
//        self.labEN.textColor = self.basicColor;
//        self.labEN.font = FONT_N;
        [self setImage:[UIImage imageNamed:@"SwitchLanguageBtn_CN"] forState:UIControlStateNormal];
    }
}


- (void)animatedExchangeTheLayer:(CALayer *)layer1 withLayer:(CALayer *)layer2 {
    CFTimeInterval duration = 0.3f;
    
    CATransform3D downPerspective = layer1.transform;
    downPerspective.m34 = -(1.f/50.f);
    CAKeyframeAnimation *keyFrameDownAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D downTransform1 = CATransform3DTranslate(downPerspective, 0.f, 0.f, 0.f);
    CATransform3D downTransform2 = CATransform3DTranslate(downPerspective, 7.f, 5.3f, 15.f);
    CATransform3D downTransform3 = CATransform3DTranslate(downPerspective, 14.f, 10.6f, 0.f);
    NSArray *downValues = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:downTransform1],
                           [NSValue valueWithCATransform3D:downTransform2],
                           [NSValue valueWithCATransform3D:downTransform3],nil];
    [keyFrameDownAnimation setValues:downValues];
    keyFrameDownAnimation.fillMode = kCAFillModeForwards;
//    keyFrameAnimation.autoreverses = YES;
    keyFrameDownAnimation.removedOnCompletion = YES;
    keyFrameDownAnimation.duration = duration;
    keyFrameDownAnimation.delegate = self;
    [layer1 addAnimation:keyFrameDownAnimation forKey:@"test"];
    layer1.transform = downTransform3;
    
    CATransform3D upPerspective = layer2.transform;
    upPerspective.m34 = -(1.f/50.f);
    CAKeyframeAnimation *keyFrameUpAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D upTransform1 = CATransform3DTranslate(upPerspective, 0.f, 0.f, 0.f);
    CATransform3D upTransform2 = CATransform3DTranslate(upPerspective, -7.f, -5.3f, -15.f);
    CATransform3D upTransform3 = CATransform3DTranslate(upPerspective, -14.f, -10.6f, 0.f);
    NSArray *upValues = [NSArray arrayWithObjects:
                         [NSValue valueWithCATransform3D:upTransform1],
                         [NSValue valueWithCATransform3D:upTransform2],
                         [NSValue valueWithCATransform3D:upTransform3],nil];
    [keyFrameUpAnimation setValues:upValues];
    keyFrameUpAnimation.fillMode = kCAFillModeForwards;
    //    keyFrameUpAnimation.autoreverses = YES;
    keyFrameUpAnimation.removedOnCompletion = YES;
    keyFrameUpAnimation.duration = duration;
    keyFrameUpAnimation.delegate = self;
    [layer2 addAnimation:keyFrameUpAnimation forKey:@"test"];
    layer2.transform = upTransform3;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    DebugLog(@"Animation:%@", anim);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
