//
//  JCColorfulCircleView.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/11/16.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "JCColorfulCircleView.h"

@interface JCColorfulCircleView ()

@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *maskView;

@end

@implementation JCColorfulCircleView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
        
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


- (void)drawCircleWithColors:(NSArray<UIColor *> *)colors
              colorLocations:(NSArray<NSNumber *> *)locations
          colorWidthMultiple:(CGFloat)widthMultiple
                     percent:(CGFloat)percent
            animatedDuration:(CFTimeInterval)animatedDuration {
    [self setNeedsLayout];
    [self layoutIfNeeded]; // 立即更新布局
    for (CALayer *layer in [self.bgView.layer.sublayers copy]) {
        [layer removeFromSuperlayer];
    }
    if (self.maskView) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }
    
    if (!colors || !colors.count) {
        return;
    }
    if (!locations || locations.count != colors.count) {
        return;
    }
    
    NSMutableArray *CGColorRefAry = [NSMutableArray array];
    for (UIColor *color in colors) {
        [CGColorRefAry addObject:(__bridge id)color.CGColor];
    }
    CGFloat colorfulLayer_W = widthMultiple*CGRectGetWidth(self.bgView.bounds);
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, colorfulLayer_W, CGRectGetHeight(self.bgView.bounds));
    gradientLayer.colors = CGColorRefAry;
    gradientLayer.locations = locations;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
//    gradientLayer.mask = circleMaskLayer;
    [self.bgView.layer addSublayer:gradientLayer];
    
    
    self.maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.maskView.backgroundColor = Color_White;
    [self addSubview:self.maskView];
    [self.maskView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    
    // 创建一个全屏大的path
    UIBezierPath *BGPath = [UIBezierPath bezierPathWithRect:self.bgView.bounds];
    CGFloat radius = CGRectGetWidth(self.bgView.bounds) / 2;
    // 创建一个圆形path
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:self.bgView.center radius:radius startAngle:0 endAngle:2*M_PI clockwise:NO];
    [BGPath appendPath:circlePath];
    
    CAShapeLayer *circleMaskLayer = [CAShapeLayer layer];
    circleMaskLayer.path = BGPath.CGPath;
    circleMaskLayer.frame = self.bgView.bounds;
    self.maskView.layer.mask = circleMaskLayer;
    
    if (animatedDuration) {
        [self drawAnimation:gradientLayer toPercent:percent withDuration:animatedDuration];
    }
}


#pragma mark -
- (void)drawAnimation:(CALayer*)layer toPercent:(CGFloat)percent withDuration:(CFTimeInterval)duration {
    CGFloat offsetX = percent * (CGRectGetWidth(layer.frame) - CGRectGetWidth(self.bgView.bounds));
    CABasicAnimation *bas = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    bas.duration = duration;
//    bas.delegate = self;
    bas.toValue = [NSNumber numberWithFloat:-offsetX];
    bas.fillMode = kCAFillModeForwards;
    bas.removedOnCompletion = NO;
    bas.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:bas forKey:@"MoveX"];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
