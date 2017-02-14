//
//  MPCirclePartView.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/12/15.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "MPCirclePartView.h"

@interface MPCirclePartView ()

@property (nonatomic, strong) UIImageView *coreView;
@property (nonatomic, strong) UIButton *centerBtn;

@property (nonatomic, strong) NSMutableArray<UIButton *> *fanshapedBtns;
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *pathAry;

@end

@implementation MPCirclePartView

- (id)initWithTarget:(id)btnTarget action:(SEL)btnAction {
    self = [self init];
    if (self) {
        self.btnTarget = btnTarget;
        self.btnAction = btnAction;
        self.fanshapedBtns = [NSMutableArray array];
        self.pathAry = [NSMutableArray array];
    }
    
    return self;
}

- (void)setUpViews {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.coreView = [[UIImageView alloc] initWithImage:nil];
    self.coreView.backgroundColor = Color_Clear;
    [self addSubview:self.coreView];
    [self.coreView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    
    CGFloat btnAngle = 2*M_PI / 7.f;
    CGFloat startAngle = M_PI/2;
    CGFloat lineWidth = ScaleBasedOn6(90.f);
    
    for (int i = 0; i < 7; i++) {
        UIButton *cancerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        cancerBtn.backgroundColor = [UIColor randomColor];
        switch (i) {
            case 0:
                cancerBtn.tag = 2;
                break;
            case 1:
                cancerBtn.tag = 6;
                break;
            case 2:
                cancerBtn.tag = 4;
                break;
            case 3:
                cancerBtn.tag = 7;
                break;
            case 4:
                cancerBtn.tag = 5;
                break;
            case 5:
                cancerBtn.tag = 3;
                break;
            case 6:
                cancerBtn.tag = 1;
                break;
            default:
                break;
        }
        
        [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Btn_AllCancer"] forState:UIControlStateNormal];
        [cancerBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"MainVC_Btn_%zd", i]] forState:UIControlStateHighlighted];
        [cancerBtn addTarget:self.btnTarget action:self.btnAction forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:cancerBtn belowSubview:self.coreView];
        [cancerBtn makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        CGFloat radius = (CGRectGetWidth(cancerBtn.frame) - lineWidth) / 2.f;
        startAngle += i ? btnAngle : 0;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:cancerBtn.center radius:radius startAngle:startAngle endAngle:(startAngle + btnAngle) clockwise:YES];
        CAShapeLayer *arcLayer = [CAShapeLayer layer];
        arcLayer.frame = cancerBtn.bounds;
        arcLayer.fillColor = [UIColor clearColor].CGColor;
        arcLayer.strokeColor = [UIColor blackColor].CGColor;
        arcLayer.lineWidth = lineWidth;
        arcLayer.lineCap = kCALineCapButt;
        arcLayer.path = path.CGPath;
        cancerBtn.layer.mask = arcLayer;
        
        CGMutablePathRef hitPath = CGPathCreateMutable();
        CGPathMoveToPoint(hitPath, NULL, cancerBtn.center.x, cancerBtn.center.y);
        CGPathAddArc(hitPath, NULL, cancerBtn.center.x, cancerBtn.center.y, CGRectGetWidth(cancerBtn.frame)/2.f, startAngle, (startAngle + btnAngle), 0);
        CGPathCloseSubpath(hitPath);
        
        [self.fanshapedBtns addObject:cancerBtn];
        [self.pathAry addObject:[UIBezierPath bezierPathWithCGPath:hitPath]];
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.userInteractionEnabled) {
        return nil;
    }
    NSEnumerator *enumertor = [self.subviews reverseObjectEnumerator];
    UIView *view;
    while (view = [enumertor nextObject]) {
//        CGPoint hitPoint = [self convertPoint:point toView:_centerView];
        if ([view isKindOfClass:[UIButton class]] && [self.fanshapedBtns containsObject:(UIButton *)view]) {
            UIButton *fanshapedBtn = (UIButton *)view;
            NSUInteger btnIndex = [self.fanshapedBtns indexOfObject:fanshapedBtn];
            UIBezierPath *path = [self.pathAry objectAtIndex:btnIndex];
            
            if (CGPathContainsPoint(path.CGPath, nil, point, nil)) {
                DebugLog(@"%@", fanshapedBtn);
                return fanshapedBtn;
            }
        }
    }
    
//    return [super hitTest:point withEvent:event];
    return nil;
}


@end
