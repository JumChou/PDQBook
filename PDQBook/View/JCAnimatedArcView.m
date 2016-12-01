//
//  JCAnimatedArcView.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/11/11.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "JCAnimatedArcView.h"

#define Color_Track_Default     [UIColor colorWithHexString:@"E9E9E9"]
//#define Color_Track_Default     [UIColor colorWithHexString:@"6f8fff"]
//#define Color_Track_Default     Color_Blue


@interface JCAnimatedArcView ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) CAShapeLayer *arcTrackLayer;
@property (nonatomic, strong) CAShapeLayer *arcLayer;

@end

@implementation JCAnimatedArcView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        Color_Blue
        self.bgView = [[UIImageView alloc] initWithImage:nil];
        self.bgView.backgroundColor = [UIColor clearColor];
        self.bgView.userInteractionEnabled = YES;
        [self addSubview:self.bgView];
        [self.bgView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    
    return self;
}


/**
 *  画单色整环（需在布局完成后调用）
 *
 *  @param color            画笔颜色
 *  @param lineWidth        线宽度
 *  @param percent          完成百分比
 *  @param animatedDuration 动画duration（0为无动画效果）
 */
- (void)drawArcWithColor:(UIColor *)color
               lineWidth:(CGFloat)lineWidth
                 percent:(CGFloat)percent
        animatedDuration:(CFTimeInterval)animatedDuration {
    [self setNeedsLayout];
    [self layoutIfNeeded]; // 立即更新布局
    
    CGFloat radius = (self.frame.size.width - lineWidth)/2;
    CGFloat trackStartAngle = 1.5*M_PI;
    CGFloat trackEndAngle = trackStartAngle + 2*M_PI;
    CGFloat startAngle = 1.526*M_PI;
    if (percent > 97.21) {
        percent = 97.21;
    }
    CGFloat endAngle = startAngle + (2*M_PI*percent);
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    [trackPath addArcWithCenter:self.bgView.center radius:radius startAngle:trackStartAngle endAngle:trackEndAngle clockwise:YES];
    self.arcTrackLayer = [CAShapeLayer layer];
    self.arcTrackLayer.frame = self.bgView.bounds;
    self.arcTrackLayer.fillColor = [UIColor clearColor].CGColor;
    self.arcTrackLayer.strokeColor = Color_Track_Default.CGColor;
    self.arcTrackLayer.lineWidth = lineWidth;
    self.arcTrackLayer.lineCap = kCALineCapRound;
    self.arcTrackLayer.path = trackPath.CGPath;
    [self.bgView.layer addSublayer:self.arcTrackLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.bgView.center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.arcLayer = [CAShapeLayer layer];
    self.arcLayer.frame = self.bgView.bounds;
    self.arcLayer.fillColor = [UIColor clearColor].CGColor;
    self.arcLayer.strokeColor = color.CGColor;
    self.arcLayer.lineWidth = lineWidth;
    self.arcLayer.lineCap = kCALineCapRound;
    self.arcLayer.path = path.CGPath;
    [self.bgView.layer addSublayer:self.arcLayer];
    
    if (animatedDuration) {
        [self drawLineAnimation:self.arcLayer duration:animatedDuration];
    }
}


/**
 *  画彩色整环（需在布局完成后调用）
 *
 *  @param lineWidth        线宽度
 *  @param percent          完成百分比
 *  @param animatedDuration 动画duration（0为无动画效果）
 */
- (void)drawColorfulArcWithLineWidth:(CGFloat)lineWidth
                             percent:(CGFloat)percent
                    animatedDuration:(CFTimeInterval)animatedDuration {
    [self setNeedsLayout];
    [self layoutIfNeeded]; // 立即更新布局
    
    CGFloat radius = (self.frame.size.width - lineWidth)/2;
    CGFloat trackStartAngle = 1.5*M_PI;
    CGFloat trackEndAngle = trackStartAngle + 2*M_PI;
    CGFloat startAngle = 1.526*M_PI;
    startAngle = 1.5*M_PI;
    if (percent > 97.21) {
        percent = 97.21;
    }
    CGFloat endAngle = startAngle + (2*M_PI*percent);
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    [trackPath addArcWithCenter:self.bgView.center radius:radius startAngle:trackStartAngle endAngle:trackEndAngle clockwise:YES];
    self.arcTrackLayer = [CAShapeLayer layer];
    self.arcTrackLayer.frame = self.bgView.bounds;
    self.arcTrackLayer.fillColor = [UIColor clearColor].CGColor;
    self.arcTrackLayer.strokeColor = Color_Track_Default.CGColor;
    self.arcTrackLayer.lineWidth = lineWidth;
    self.arcTrackLayer.lineCap = kCALineCapRound;
    self.arcTrackLayer.path = trackPath.CGPath;
    [self.bgView.layer addSublayer:self.arcTrackLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.bgView.center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.arcLayer = [CAShapeLayer layer];
    self.arcLayer.frame = self.bgView.bounds;
    self.arcLayer.fillColor = [UIColor clearColor].CGColor;
    self.arcLayer.strokeColor = [UIColor blackColor].CGColor;
    self.arcLayer.lineWidth = lineWidth;
    self.arcLayer.lineCap = kCALineCapRound;
    self.arcLayer.path = path.CGPath;
    
    UIColor *redColor = [UIColor colorWithHexString:@"ff4b5a"];
    UIColor *yellowColor = [UIColor yellowColor];
    UIColor *greenColor = [UIColor colorWithRGBA:@"rgba(96, 178, 167, 1.00)"];
    UIColor *blueColor = [UIColor colorWithHexString:@"37bbeb"];
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *rightGradientLayer = [CAGradientLayer layer];
    rightGradientLayer.frame = CGRectMake(self.bgView.center.x, 0, self.bgView.center.x, self.bgView.bounds.size.height);
    rightGradientLayer.colors = @[(__bridge id)redColor.CGColor, (__bridge id)yellowColor.CGColor];
    rightGradientLayer.locations = @[@0.2, @0.6];
    rightGradientLayer.startPoint = CGPointMake(0, 0);
    rightGradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer addSublayer:rightGradientLayer];
    
    CAGradientLayer *leftGradientLayer = [CAGradientLayer layer];
    leftGradientLayer.frame = CGRectMake(0, 0, self.bgView.center.x, self.bgView.bounds.size.height);
    leftGradientLayer.colors = @[(__bridge id)blueColor.CGColor, (__bridge id)greenColor.CGColor, (__bridge id)yellowColor.CGColor];
    leftGradientLayer.locations = @[@0.2, @0.4, @0.95];
    leftGradientLayer.startPoint = CGPointMake(0, 0);
    leftGradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer addSublayer:leftGradientLayer];
    
    gradientLayer.mask = self.arcLayer;
    [self.bgView.layer addSublayer:gradientLayer];
    
    if (animatedDuration) {
        [self drawLineAnimation:self.arcLayer duration:animatedDuration];
    }
}


/**
 画彩色渐变不完整环形（需在布局完成后调用）
 
 @param leftColors 左侧渐变色Ary
 @param rightColors 右侧渐变色Ary
 @param leftLocations 左侧渐变色LocationAry
 @param rightLocations 右侧渐变色LocationAry
 @param trackArcColor 轨迹颜色
 @param lineWidth 环形宽
 @param percent 绘制百分比
 @param animatedDuration 动画时间
 */
- (void)drawMajorArcWithLeftColors:(NSArray<UIColor *> *)leftColors
                       rightColors:(NSArray<UIColor *> *)rightColors
                leftColorLocations:(NSArray<NSNumber *> *)leftLocations
               rightColorLocations:(NSArray<NSNumber *> *)rightLocations
                     trackArcColor:(UIColor *)trackArcColor
                         LineWidth:(CGFloat)lineWidth
                           percent:(CGFloat)percent
                  animatedDuration:(CFTimeInterval)animatedDuration {
    [self setNeedsLayout];
    [self layoutIfNeeded]; // 立即更新布局
    for (CALayer *layer in [self.bgView.layer.sublayers copy]) {
        [layer removeFromSuperlayer];
    }
    
    if (!leftColors || !leftColors.count || !rightColors || !rightColors.count) {
        return;
    }
    if (!leftLocations || leftLocations.count != leftColors.count || !rightLocations || rightLocations.count != rightColors.count) {
        return;
    }
    trackArcColor = trackArcColor ? trackArcColor : Color_Track_Default;
    
    CGFloat radius = (self.frame.size.width - lineWidth)/2;
    CGFloat trackStartAngle = 3.f/4.f*M_PI;
    CGFloat trackEndAngle = 9.f/4.f*M_PI;
    CGFloat startAngle = trackStartAngle;
    CGFloat endAngle = startAngle + (3.f/4.f * 2*M_PI * percent);
    
    UIBezierPath *trackPath = [UIBezierPath bezierPath];
    [trackPath addArcWithCenter:self.bgView.center radius:radius startAngle:trackStartAngle endAngle:trackEndAngle clockwise:YES];
    self.arcTrackLayer = [CAShapeLayer layer];
    self.arcTrackLayer.frame = self.bgView.bounds;
    self.arcTrackLayer.fillColor = [UIColor clearColor].CGColor;
    self.arcTrackLayer.strokeColor = trackArcColor.CGColor;
    self.arcTrackLayer.lineWidth = lineWidth;
    self.arcTrackLayer.lineCap = kCALineCapRound;
    self.arcTrackLayer.path = trackPath.CGPath;
    [self.bgView.layer addSublayer:self.arcTrackLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:self.bgView.center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    self.arcLayer = [CAShapeLayer layer];
    self.arcLayer.frame = self.bgView.bounds;
    self.arcLayer.fillColor = [UIColor clearColor].CGColor;
    self.arcLayer.strokeColor = [UIColor blackColor].CGColor;
    self.arcLayer.lineWidth = lineWidth;
    self.arcLayer.lineCap = kCALineCapRound;
    self.arcLayer.path = path.CGPath;
    
    NSMutableArray *leftCGColorRefAry = [NSMutableArray array];
    for (UIColor *color in leftColors) {
        [leftCGColorRefAry addObject:(__bridge id)color.CGColor];
    }
    NSMutableArray *rightCGColorRefAry = [NSMutableArray array];
    for (UIColor *color in rightColors) {
        [rightCGColorRefAry addObject:(__bridge id)color.CGColor];
    }
    
    CALayer *gradientLayer = [CALayer layer];
    
    CAGradientLayer *leftGradientLayer = [CAGradientLayer layer];
    leftGradientLayer.frame = CGRectMake(0, 0, self.bgView.center.x, self.bgView.bounds.size.height);
    leftGradientLayer.colors = leftCGColorRefAry;
    leftGradientLayer.locations = leftLocations;
    leftGradientLayer.startPoint = CGPointMake(0, 0);
    leftGradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer addSublayer:leftGradientLayer];
    
    CAGradientLayer *rightGradientLayer = [CAGradientLayer layer];
    rightGradientLayer.frame = CGRectMake(self.bgView.center.x, 0, self.bgView.center.x, self.bgView.bounds.size.height);
    rightGradientLayer.colors = rightCGColorRefAry;
    rightGradientLayer.locations = rightLocations;
    rightGradientLayer.startPoint = CGPointMake(0, 0);
    rightGradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer addSublayer:rightGradientLayer];
    
    gradientLayer.mask = self.arcLayer;
    [self.bgView.layer addSublayer:gradientLayer];
    gradientLayer.shadowOpacity = 0.1;
    gradientLayer.shadowOffset = CGSizeMake(1, -1);
    gradientLayer.shadowRadius = 2;
    
    if (animatedDuration) {
        [self drawLineAnimation:self.arcLayer duration:animatedDuration];
    }
}




#pragma mark -
- (void)drawLineAnimation:(CALayer*)layer duration:(CFTimeInterval)duration {
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration = duration;
//    bas.delegate = self;
    bas.fromValue = [NSNumber numberWithInteger:0];
    bas.toValue = [NSNumber numberWithInteger:1];
    bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:bas forKey:@"DrawToStrokeEnd"];
}




@end
