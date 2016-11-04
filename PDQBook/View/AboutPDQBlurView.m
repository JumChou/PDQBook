//
//  AboutPDQBlurView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/9/12.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "AboutPDQBlurView.h"
#import "CommonDefine.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>

static const CGFloat kAnimation_Padding = 100.f;
static const CGFloat kAnimation_Duration = 0.3f;
static const CGFloat kAnimation_BasicDelay = 0.1f;

static const CGFloat kCloseBtn_Padding = 24.f;
static const CGFloat kCloseBtn_W = 24.f;

static const CGFloat kPDQIcon_Top = 80.f;
static const CGFloat kPDQIcon_W = (132.f/2);
static const CGFloat kPDQIcon_H = (141.f/2);

static const CGFloat kPDQTitle_H = 22.f;
static const CGFloat kPDQTitle_FontSize = 20.f;

static const CGFloat kPDQDesc_Top = 36.f;
static const CGFloat kPDQDesc_Leading = 30.f;
static const CGFloat kPDQDesc_FontSize = 15.f;

static const CGFloat kPDQCopyright_Bottom = 20.f;
static const CGFloat kPDQCopyright_H = 16.f;
static const CGFloat kPDQCopyright_FontSize = 12.f;

static NSString *const kPDQTitle = @"关于PDQ";
static NSString *const kPDQDesc = @"       PDQ癌症综合信息库自1977年由美国国家癌症研究所（NCI）创建，内容涵盖了癌症筛查、预防、诊断、治疗、支持与姑息治疗、补充和替代疗法、遗传学和药物等方面。该信息库定期对全世界癌症研究结果进行汇总，及时更新相关内容，为癌症预防、诊断和治疗提供最新信息。";
static NSString *const kPDQCopyright = @"Copyright © 2016 PDQ. All rights reserved.";


@interface AboutPDQBlurView ()

@property (nonatomic, strong) UIImageView *PDQIconView;
@property (nonatomic, strong) UILabel *PDQTitleLab;
@property (nonatomic, strong) UILabel *PDQDescLab;
@property (nonatomic, strong) UILabel *PDQCopyrightLab;
@property (nonatomic, strong) VBFPopFlatButton *closeBtn;

@end

@implementation AboutPDQBlurView

+ (AboutPDQBlurView *)aboutPDQBlurView {
    AboutPDQBlurView *aboutView = [[AboutPDQBlurView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                                tintColor:nil
                                                                  opacity:0.1
                                                             cornerRadius:0];
    return aboutView;
}

+ (AboutPDQBlurView *)aboutPDQBlurViewWithIsAutoAnimation:(BOOL)isAutoAnimation {
    AboutPDQBlurView *aboutView = [[AboutPDQBlurView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)
                                                                tintColor:nil
                                                                  opacity:0.1
                                                             cornerRadius:0];
    aboutView.isAutoAnimation = isAutoAnimation;
    return aboutView;
}

- (id)initWithFrame:(CGRect)frame
          tintColor:(UIColor *)tintColor
            opacity:(CGFloat)opacity
       cornerRadius:(CGFloat)cornerRadius {
    self = [super initWithFrame:frame tintColor:tintColor opacity:opacity cornerRadius:cornerRadius];
    if (self) {
        self.isAutoAnimation = YES;
        [self initViews];
    }
    
    return self;
}

- (void)didMoveToWindow {
    if (self.window != nil && self.isAutoAnimation) {
        [self showAnimationsWithCompletion:nil];
    }
}

- (void)initViews {
    self.alpha = 0;
    
    [self initCloseBtn];
    
    self.PDQIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"AboutPDQ_icon"]];
    [self addSubview:self.PDQIconView];
    [self.PDQIconView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(ScaleBasedOn6(kPDQIcon_Top) +kAnimation_Padding);
        make.centerX.equalTo(self);
        make.width.equalTo(ScaleBasedOn6(kPDQIcon_W));
        make.height.equalTo(ScaleBasedOn6(kPDQIcon_H));
    }];
    
    self.PDQTitleLab = [UILabel label];
//    self.PDQTitleLab.backgroundColor = Color_Blue;
    self.PDQTitleLab.text = kPDQTitle;
    self.PDQTitleLab.textColor = Color_Navy;
    self.PDQTitleLab.textAlignment = NSTextAlignmentCenter;
    self.PDQTitleLab.font = [UIFont boldDefaultFontWithSize:ScaleBasedOn6(kPDQTitle_FontSize)];
    [self addSubview:self.PDQTitleLab];
    [self.PDQTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PDQIconView.bottom);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(ScaleBasedOn6(kPDQTitle_H));
    }];
    
    self.PDQDescLab = [UILabel label];
    self.PDQDescLab.text = kPDQDesc;
    self.PDQDescLab.textColor = Color_Navy;
    self.PDQDescLab.textAlignment = NSTextAlignmentLeft;
    self.PDQDescLab.font = [UIFont defaultFontWithSize:ScaleBasedOn6(kPDQDesc_FontSize)];
    self.PDQDescLab.numberOfLines = 0;
    [self.PDQDescLab sizeToFit];
    [self addSubview:self.PDQDescLab];
    [self.PDQDescLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.PDQTitleLab.bottom).offset(ScaleBasedOn6(kPDQDesc_Top));
        make.leading.equalTo(self).offset(ScaleBasedOn6(kPDQDesc_Leading));
        make.trailing.equalTo(self).offset(-ScaleBasedOn6(kPDQDesc_Leading));
    }];
    
    self.PDQCopyrightLab = [UILabel label];
    self.PDQCopyrightLab.text = kPDQCopyright;
    self.PDQCopyrightLab.textColor = Color_Navy;
    self.PDQCopyrightLab.textAlignment = NSTextAlignmentCenter;
    self.PDQCopyrightLab.font = [UIFont defaultFontWithSize:ScaleBasedOn6(kPDQCopyright_FontSize)];
    [self addSubview:self.PDQCopyrightLab];
    [self.PDQCopyrightLab makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-ScaleBasedOn6(kPDQCopyright_Bottom) +kAnimation_Padding);
        make.leading.trailing.equalTo(self);
        make.height.equalTo(ScaleBasedOn6(kPDQCopyright_H));
    }];
    
    self.PDQIconView.alpha = 0;
    self.PDQTitleLab.alpha = 0;
    self.PDQDescLab.alpha = 0;
    self.PDQCopyrightLab.alpha = 0;
}

- (void)initCloseBtn {
    self.closeBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, kCloseBtn_W, kCloseBtn_W)
                                                 buttonType:buttonCloseType
                                                buttonStyle:buttonPlainStyle
                                      animateToInitialState:YES];
    self.closeBtn.lineThickness = 2;
    self.closeBtn.lineRadius = 2;
    self.closeBtn.tintColor = Color_Navy;
    [self.closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    [self.closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(kStatusBarHeight + kCloseBtn_Padding);
        make.trailing.equalTo(self).offset(-kCloseBtn_Padding);
        make.width.equalTo(kCloseBtn_W);
        make.height.equalTo(kCloseBtn_W);
    }];
}


#pragma mark - EventAction
- (void)closeBtnAction:(id)sender {
//    if (self.closeBtn.currentButtonType == buttonCloseType) {
//        self.closeBtn.currentButtonType = buttonDownBasicType;
//    }
    
    if (self.isAutoAnimation) {
        [self fadeoutAnimationsWithCompletion:NULL];
    }
    
    if ([self.delegate respondsToSelector:@selector(aboutPDQBlurView:didTappedCloseBtn:)]) {
        [self.delegate aboutPDQBlurView:self didTappedCloseBtn:self.closeBtn];
    }
}


#pragma mark - Animation
- (void)showAnimationsWithCompletion:(void (^)())completion {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.4f animations:^{
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimation_Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect PDQIconFrame = self.PDQIconView.frame;
            PDQIconFrame.origin.y -= kAnimation_Padding;
            self.PDQIconView.frame = PDQIconFrame;
            self.PDQIconView.alpha = 1;
            
        } completion:nil];
        
        [UIView animateWithDuration:kAnimation_Duration delay:kAnimation_BasicDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect PDQTitleFrame = self.PDQTitleLab.frame;
            PDQTitleFrame.origin.y -= kAnimation_Padding;
            self.PDQTitleLab.frame = PDQTitleFrame;
            self.PDQTitleLab.alpha = 1;
            
        } completion:nil];
        
        [UIView animateWithDuration:kAnimation_Duration delay:2*kAnimation_BasicDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect PDQDescFrame = self.PDQDescLab.frame;
            PDQDescFrame.origin.y -= kAnimation_Padding;
            self.PDQDescLab.frame = PDQDescFrame;
            self.PDQDescLab.alpha = 1;
            
        } completion:nil];
        
        [UIView animateWithDuration:kAnimation_Duration delay:3*kAnimation_BasicDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
            CGRect PDQCopyrightFrame = self.PDQCopyrightLab.frame;
            PDQCopyrightFrame.origin.y -= kAnimation_Padding;
            self.PDQCopyrightLab.frame = PDQCopyrightFrame;
            self.PDQCopyrightLab.alpha = 1;
            
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
        }];
        
    }];
}


- (void)fadeoutAnimationsWithCompletion:(void (^)())completion {
    [UIView animateWithDuration:0.3f animations:^{
        self.closeBtn.alpha = 0;
    }];
    
    [UIView animateWithDuration:kAnimation_Duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect PDQCopyrightFrame = self.PDQCopyrightLab.frame;
        PDQCopyrightFrame.origin.y += kAnimation_Padding;
        self.PDQCopyrightLab.frame = PDQCopyrightFrame;
        self.PDQCopyrightLab.alpha = 0;
        
    } completion:nil];
    
    [UIView animateWithDuration:kAnimation_Duration delay:kAnimation_BasicDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect PDQDescFrame = self.PDQDescLab.frame;
        PDQDescFrame.origin.y += kAnimation_Padding;
        self.PDQDescLab.frame = PDQDescFrame;
        self.PDQDescLab.alpha = 0;
        
    } completion:nil];
    
    [UIView animateWithDuration:kAnimation_Duration delay:2*kAnimation_BasicDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect PDQTitleFrame = self.PDQTitleLab.frame;
        PDQTitleFrame.origin.y += kAnimation_Padding;
        self.PDQTitleLab.frame = PDQTitleFrame;
        self.PDQTitleLab.alpha = 0;
        
    } completion:nil];
    
    [UIView animateWithDuration:kAnimation_Duration delay:3*kAnimation_BasicDelay options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect PDQIconFrame = self.PDQIconView.frame;
        PDQIconFrame.origin.y += kAnimation_Padding;
        self.PDQIconView.frame = PDQIconFrame;
        self.PDQIconView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3f delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            if (completion) {
                completion();
            }
            [self removeFromSuperview];
        }];
    }];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
