//
//  MainViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/11.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "CancerViewController.h"
#import "MPSearchPartView.h"
#import <POP/POP.h>
#import "Cancers.h"
#import "RQShineLabel.h"
#import "AboutPDQBlurView.h"
#import <QBPopupMenu/QBPlasticPopupMenu.h>

//static const CGFloat MoreBtn_Trailing = 40.0f;
//static const CGFloat MoreBtn_W = 40.0f;
//static const CGFloat MoreBtn_H = 20.0f;

static const CGFloat kInfoLab_Top = 50.0f;
static const CGFloat kInfoLab_H = 50.0f;
static const CGFloat kInfoLab_FontSize_L = 18.0f;
static const CGFloat kInfoLab_FontSize_S = 14.0f;

static const CGFloat kCancerBtn_Top = 26.0f;
static const CGFloat kCancerBtn_Padding = 22.0f;
static const CGFloat kCancerBtn_W = 65.0f;

static const CGFloat kSearchPartVew_Top = 30.0f;
static const CGFloat kSearchPartVew_Leading = 36.0f;
static const CGFloat kSearchPartVew_H = 48.0f;

static const CGFloat kAboutBtn_Bottom = 20.0f;
static const CGFloat kAboutBtn_W = 100.0f;
static const CGFloat kAboutBtn_H = 20.0f;

static const CGFloat kAboutIcon_Padding = 1.0f;
//static const CGFloat kAboutBtn_W = 60.0f;
//static const CGFloat kAboutBtn_H = 30.0f;

static const CGFloat kAboutLab_FontSize = 14.0f;


@interface MainViewController () <AboutPDQBlurViewDelegate>

/// 背景
@property (nonatomic, strong) UIImageView *bgIMGView;
/// 介绍信息文本
@property (nonatomic, strong) RQShineLabel *infoLab;
/// 搜索框
@property (nonatomic, strong) MPSearchPartView *searchPartView;
/// 线
@property (nonatomic, strong) UIImageView *lineIMGView;
/// CancerBtns
@property (nonatomic, strong) NSMutableArray *cancerBtns;
/// 更多btn
@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIButton *aboutBtn;
@property (nonatomic, strong) UIImageView *aboutIconView;
@property (nonatomic, strong) UILabel *aboutLab;

@property (nonatomic, strong) Cancers *cancers;

@property (nonatomic, strong) CALayer *animationLayer;
@property (nonatomic, strong) CAShapeLayer *pathLayer;
@property (nonatomic, strong) QBPopupMenu *popupMenu;

@end

@implementation MainViewController

#pragma mark - LifeCircle
/// 是否已进入界面
static BOOL isEntered = NO;
/// 是否动画ing
static BOOL isAnimating = NO;

- (id)init {
    self = [super init];
    if (self) {
        self.cancerBtns = [NSMutableArray array];
        self.cancers = [[Cancers alloc] init];
        
        [self setUpMenuController];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    self.animationLayer = [[CALayer alloc] init];
    self.animationLayer.frame = CGRectMake(0, 20, kScreenWidth, 100);
    [self.view.layer addSublayer:self.animationLayer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self showAnimations]; // 展示动画
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self fadeOutAnimations];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)initViews {
    UIImage *bgIMG;
    if (iPhone4) {
        bgIMG = [UIImage imageNamed:@"MainVC_BG_iPhone4"];
    } else {
        bgIMG = [UIImage imageNamed:@"MainVC_BG"];
    }
    self.bgIMGView = [[UIImageView alloc] initWithImage:bgIMG];
    self.bgIMGView.userInteractionEnabled = YES;
    [self.view addSubview:self.bgIMGView];
    [self.bgIMGView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    [self initInfoLab];
    [self initCancerBtns];
    [self initAboutPDQViews];
    
    __weak typeof(self) weakSelf = self;
    self.searchPartView = [[MPSearchPartView alloc] initWithTapHandler:^{
        [weakSelf showSearchVC];
    }];
    [self.bgIMGView addSubview:self.searchPartView];
    [self.searchPartView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(3*(kCancerBtn_Top + kCancerBtn_W) + kSearchPartVew_Top));
        make.leading.equalTo(self.bgIMGView).offset(ScaleBasedOn6(kSearchPartVew_Leading));
        make.trailing.equalTo(self.bgIMGView).offset(-ScaleBasedOn6(kSearchPartVew_Leading));
        make.height.equalTo(ScaleBasedOn6(kSearchPartVew_H));
    }];
    
//    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.moreBtn setImage:[UIImage imageNamed:@"MainVC_More"] forState:UIControlStateNormal];
//    [self.moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.bgIMGView addSubview:self.moreBtn];
//    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.infoLab.top);
//        make.trailing.equalTo(self.bgIMGView).offset(-ScaleBasedOn6(MoreBtn_Trailing));
//        make.width.equalTo(ScaleBasedOn6(MoreBtn_W));
//        make.height.equalTo(ScaleBasedOn6(MoreBtn_H));
//    }];
}

/**
 初始化文本信息Label
 */
- (void)initInfoLab {
    self.infoLab = [[RQShineLabel alloc] init];
    self.infoLab.shineDuration = 1.f;
    self.infoLab.fadeoutDuration = 0.f;
    self.infoLab.backgroundColor = Color_Clear;
//    self.infoLab.textColor = Color_TextNavy;
    self.infoLab.textAlignment = NSTextAlignmentCenter;
    self.infoLab.numberOfLines = 0;
    [self.bgIMGView addSubview:self.infoLab];
    [self.infoLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgIMGView);
        make.top.equalTo(self.bgIMGView).offset(ScaleBasedOn6(kInfoLab_Top));
        make.height.equalTo(ScaleBasedOn6(kInfoLab_H));
        make.width.equalTo(self.bgIMGView);
    }];
//    NSString *text1 = @"中文版PDQ\n";
//    NSString *text2 = @"国家癌症中心 National Cancer Center";
//    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", text1, text2]];
//    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, text1.length)];
//    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0f] range:NSMakeRange(text1.length, text2.length)];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
//    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"PDQ 最权威的癌症信息库" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:ScaleBasedOn6(kInfoLab_FontSize_L)], NSForegroundColorAttributeName:Color_Navy}]];
//    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n国家癌症中心 - National Cancer Center" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:ScaleBasedOn6(kInfoLab_FontSize_S)], NSForegroundColorAttributeName:Color_Navy}]];
//    self.infoLab.attributedText = attributedStr;
    
    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"PDQ 最权威的癌症信息库" attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kInfoLab_FontSize_L)], NSForegroundColorAttributeName:Color_Navy}]];
    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n国家癌症中心 - National Cancer Center" attributes:@{NSFontAttributeName:[UIFont defaultFontWithSize:ScaleBasedOn6(kInfoLab_FontSize_S)], NSForegroundColorAttributeName:Color_Navy}]];
    self.infoLab.attributedText = attributedStr;
}

/**
 初始化癌症按钮们
 */
- (void)initCancerBtns {
    for (UIButton *btn in self.cancerBtns) {
        [btn removeFromSuperview];
    }
    [self.cancerBtns removeAllObjects];
    
    for (int i = 1; i <= 7; i++) {
        UIButton *cancerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancerBtn addTarget:self action:@selector(cancerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        cancerBtn.alpha = 0;
        cancerBtn.tag = i;
        [self.bgIMGView addSubview:cancerBtn];
        [self.cancerBtns addObject:cancerBtn];
        // 初始布局与最终布局不同，为动画铺垫
        if (i == 1) { // 中轴顶
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_shidaoai"] forState:UIControlStateNormal];
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_shidaoai_h"] forState:UIControlStateHighlighted];
            [cancerBtn makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(kCancerBtn_Top -kCancerBtn_W));
                make.centerX.equalTo(self.bgIMGView);
                make.width.equalTo(ScaleBasedOn6(kCancerBtn_W));
                make.height.equalTo(ScaleBasedOn6(kCancerBtn_W));
            }];
        }
        if (i == 2) { // 中心按钮动画无位移
            cancerBtn.tag = 7;
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_naoai"] forState:UIControlStateNormal];
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_naoai_h"] forState:UIControlStateHighlighted];
            [cancerBtn makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(2*kCancerBtn_Top + kCancerBtn_W));
                make.centerX.equalTo(self.bgIMGView);
                make.width.equalTo(ScaleBasedOn6(kCancerBtn_W));
                make.height.equalTo(ScaleBasedOn6(kCancerBtn_W));
            }];
        }
        if (i == 3) { // 中轴底
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_zhichangai"] forState:UIControlStateNormal];
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_zhichangai_h"] forState:UIControlStateHighlighted];
            [cancerBtn makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(3*kCancerBtn_Top + 2*kCancerBtn_W +kCancerBtn_W));
                make.centerX.equalTo(self.bgIMGView);
                make.width.equalTo(ScaleBasedOn6(kCancerBtn_W));
                make.height.equalTo(ScaleBasedOn6(kCancerBtn_W));
            }];
        }
        if (i == 4) { // 左上
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_weiai"] forState:UIControlStateNormal];
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_weiai_h"] forState:UIControlStateHighlighted];
            [cancerBtn makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(kCancerBtn_Top + kCancerBtn_W + kCancerBtn_Top/2 -kCancerBtn_W));
                make.trailing.equalTo(self.bgIMGView.centerX).offset(-ScaleBasedOn6(kCancerBtn_Padding + kCancerBtn_W/2 +kCancerBtn_W));
                make.width.equalTo(ScaleBasedOn6(kCancerBtn_W));
                make.height.equalTo(ScaleBasedOn6(kCancerBtn_W));
            }];
        }
        if (i == 5) { // 左下
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_feiai"] forState:UIControlStateNormal];
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_feiai_h"] forState:UIControlStateHighlighted];
            [cancerBtn makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(2*kCancerBtn_Top + 2*kCancerBtn_W + kCancerBtn_Top/2 +kCancerBtn_W));
                make.trailing.equalTo(self.bgIMGView.centerX).offset(-ScaleBasedOn6(kCancerBtn_Padding + kCancerBtn_W/2 +kCancerBtn_W));
                make.width.equalTo(ScaleBasedOn6(kCancerBtn_W));
                make.height.equalTo(ScaleBasedOn6(kCancerBtn_W));
            }];
        }
        if (i == 6) { // 右上
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_ruxianai"] forState:UIControlStateNormal];
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_ruxianai_h"] forState:UIControlStateHighlighted];
            [cancerBtn makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(kCancerBtn_Top + kCancerBtn_W + kCancerBtn_Top/2 -kCancerBtn_W));
                make.leading.equalTo(self.bgIMGView.centerX).offset(ScaleBasedOn6(kCancerBtn_Padding + kCancerBtn_W/2 +kCancerBtn_W));
                make.width.equalTo(ScaleBasedOn6(kCancerBtn_W));
                make.height.equalTo(ScaleBasedOn6(kCancerBtn_W));
            }];
        }
        if (i == 7) { // 右下
            cancerBtn.tag = 2;
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_ganai"] forState:UIControlStateNormal];
            [cancerBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_Cancer_ganai_h"] forState:UIControlStateHighlighted];
            [cancerBtn makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(2*kCancerBtn_Top + 2*kCancerBtn_W + kCancerBtn_Top/2 +kCancerBtn_W));
                make.leading.equalTo(self.bgIMGView.centerX).offset(ScaleBasedOn6(kCancerBtn_Padding + kCancerBtn_W/2 +kCancerBtn_W));
                make.width.equalTo(ScaleBasedOn6(kCancerBtn_W));
                make.height.equalTo(ScaleBasedOn6(kCancerBtn_W));
            }];
        }
        
    }
}

/**
 初始化关于PDQ
 */
- (void)initAboutPDQViews {
    self.aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.aboutBtn addTarget:self action:@selector(aboutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.bgIMGView addSubview:self.aboutBtn];
    [self.aboutBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgIMGView).offset(-ScaleBasedOn6(kAboutBtn_Bottom));
        make.centerX.equalTo(self.bgIMGView);
        make.width.equalTo(ScaleBasedOn6(kAboutBtn_W));
        make.height.equalTo(ScaleBasedOn6(kAboutBtn_H));
    }];
    
    self.aboutIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainVC_AboutPDQ_icon"]];
    [self.aboutBtn addSubview:self.aboutIconView];
    [self.aboutIconView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aboutBtn).offset(ScaleBasedOn6(kAboutIcon_Padding));
        make.leading.equalTo(self.aboutBtn).offset(ScaleBasedOn6(kAboutIcon_Padding));
        make.bottom.equalTo(self.aboutBtn).offset(-ScaleBasedOn6(kAboutIcon_Padding));
        make.width.equalTo(self.aboutIconView.height);
    }];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"关于PDQ >"];
//    [attrStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, attrStr.length)];
    self.aboutLab = [[UILabel alloc] init];
    self.aboutLab.attributedText = attrStr;
    self.aboutLab.textColor = Color_Navy;
//    self.aboutLab.textColor = Color_TextNavy;
    self.aboutLab.textAlignment = NSTextAlignmentCenter;
    self.aboutLab.font = [UIFont defaultFontWithSize:ScaleBasedOn6(kAboutLab_FontSize)];
    self.aboutLab.userInteractionEnabled = NO;
    [self.aboutBtn addSubview:self.aboutLab];
    [self.aboutLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.aboutBtn);
        make.leading.equalTo(self.aboutIconView.trailing);
        make.trailing.equalTo(self.aboutBtn);
    }];
    
}


#pragma mark - StatusBar
/// 回调设置StatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - EventAction
- (void)webViewBtnAction {
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)cancerBtnAction:(UIButton *)sender {
    if (![Singleton shareInstance].isHTTPRequestedCancers) {
        __block BOOL isSuccess = NO;
        UCZProgressView *progressView = [[UCZProgressView alloc] initLoadingStyleWithIsUseArcAnim:NO];
        progressView.animationDidStopBlock = ^{
            if (isSuccess) {
                [self cancerBtnAction:sender];
            }
        };
        [self.view addSubview:progressView];
        [progressView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
        }];
        
        [self.cancers HTTPRequestCancersWithSuccess:^{
            [NSThread sleepForTimeInterval:0.5];
            progressView.progress = 1;
            [Singleton shareInstance].isHTTPRequestedCancers = YES;
            isSuccess = YES;
            
        } failure:^{
            progressView.progress = 1;
            
        }];
        
        return;
    }
    
    NSInteger cancerId = sender.tag;
    Cancer *cancer = [Cancer cancerWithId:cancerId];
    CancerViewController *cancerVC = [[CancerViewController alloc] initWithCancer:cancer];
    [self.navigationController pushViewController:cancerVC animated:YES];
}


- (void)moreBtnAction {
    DebugLog(@"");
//    [self testAFNetWorking];
    [self testDrawTextAnimation];
    [self startAnimation];
}

- (void)aboutBtnAction {
    DebugLog(@"");    
//    CGRect menuFrame = CGRectMake(0, 0, kScreenWidth, kStatusBarHeight);
//    [self.popupMenu showInView:self.view targetRect:menuFrame animated:YES];
    
    AboutPDQBlurView *aboutView = [AboutPDQBlurView aboutPDQBlurView];
    aboutView.delegate = self;
    [self.bgIMGView addSubview:aboutView];
}


#pragma mark - Animations
/**
 展示动画
 */
- (void)showAnimations {
//    DebugLog(@"!!!StartShow!!!");
//    if (isAnimating) {
//        return;
//    }
    isAnimating = YES;
    
    if (!isEntered) {
        [self.infoLab performSelector:@selector(shine) withObject:nil afterDelay:0.6f];
        [self performSelector:@selector(showCancerBtnsAnimations) withObject:nil afterDelay:1.f];
        
    } else {
        [self.infoLab shine];
//        [self showCancerBtnsAnimations];
    }
    
    isEntered = YES;
}

- (void)fadeOutAnimations {
//    if (isAnimating) {
//        return;
//    }
//    DebugLog(@"!!!StartFadeout!!!");
    [self.infoLab fadeOut];
//    [self initCancerBtns];
//    DebugLog(@"!!!EndFadeout!!!");
}


/**
 展示按钮们动画
 */
- (void)showCancerBtnsAnimations {
    if (!self.cancerBtns || !self.cancerBtns.count || self.cancerBtns.count < 7) {
        return;
    }
    
    for (int i = 1; i <= 7; i++) {
        UIButton *cancerBtn = [self.cancerBtns objectAtIndex:(i - 1)];
        CFTimeInterval delay = (0.1 * (i + 1));
        delay = 0;
        CGFloat toX = 0.f;
        CGFloat toY = 0.f;
        if (i == 1) { // 中轴顶
            toY = CGRectGetMidY(cancerBtn.frame) + ScaleBasedOn6(kCancerBtn_W);
        } else if (i == 2) { // 中心
            
        } else if (i == 3) { // 中轴底
            toY = CGRectGetMidY(cancerBtn.frame) - ScaleBasedOn6(kCancerBtn_W);
        } else if (i == 4) { // 左上
            toY = CGRectGetMidY(cancerBtn.frame) + ScaleBasedOn6(kCancerBtn_W);
            toX = CGRectGetMidX(cancerBtn.frame) + ScaleBasedOn6(kCancerBtn_W);
        } else if (i == 5) { // 左下
            toY = CGRectGetMidY(cancerBtn.frame) - ScaleBasedOn6(kCancerBtn_W);
            toX = CGRectGetMidX(cancerBtn.frame) + ScaleBasedOn6(kCancerBtn_W);
        } else if (i == 6) { // 右上
            toY = CGRectGetMidY(cancerBtn.frame) + ScaleBasedOn6(kCancerBtn_W);
            toX = CGRectGetMidX(cancerBtn.frame) - ScaleBasedOn6(kCancerBtn_W);
        } else if (i == 7) { // 右下
            toY = CGRectGetMidY(cancerBtn.frame) - ScaleBasedOn6(kCancerBtn_W);
            toX = CGRectGetMidX(cancerBtn.frame) - ScaleBasedOn6(kCancerBtn_W);
        }
        
        if (toY != 0) {
            [cancerBtn setSpringAnimationWithKey:@"springAnimationY"
                                    propertyName:kPOPLayerPositionY
                                       fromValue:FLT_MAX
                                         toValue:toY
                                           delay:delay
                                     springSpeed:3.f
                                springBounciness:3.f
                                dynamicsFriction:15.f
                                 completionBlock:^(POPAnimation *anim, BOOL finished) {
                                     
                                 }];
        }
        if (toX != 0) {
            [cancerBtn setSpringAnimationWithKey:@"springAnimationX"
                                    propertyName:kPOPLayerPositionX
                                       fromValue:FLT_MAX
                                         toValue:toX
                                           delay:delay
                                     springSpeed:3.f
                                springBounciness:3.f
                                dynamicsFriction:15.f
                                 completionBlock:^(POPAnimation *anim, BOOL finished) {
                                     
                                 }];
        }
        
        [cancerBtn setSpringAnimationDefaultWithKey:@"springAnimationAlpha"
                                       propertyName:kPOPLayerOpacity
                                          fromValue:0
                                            toValue:1.f
                                              delay:delay
                                    completionBlock:^(POPAnimation *anim, BOOL finished) {
                                        if (i == 7) { // 动画结束执行
                                            [self updateCancerBtnsConstraints]; // 更新cancerBtns们的约束
                                            isAnimating = NO;
//                                            DebugLog(@"!!!EndShow!!!");
                                        }
                                    }];
    }
    
}

- (void)updateCancerBtnsConstraints {
    for (int i = 1; i <= self.cancerBtns.count; i++) {
        UIButton *cancerBtn = [self.cancerBtns objectAtIndex:(i - 1)];

        if (i == 1) { // 中轴顶
            [cancerBtn updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(kCancerBtn_Top));
            }];
        } else if (i == 2) { // 中心
            
        } else if (i == 3) { // 中轴底
            [cancerBtn updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(3*kCancerBtn_Top + 2*kCancerBtn_W));
            }];
        } else if (i == 4) { // 左上
            [cancerBtn updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(kCancerBtn_Top + kCancerBtn_W + kCancerBtn_Top/2));
                make.trailing.equalTo(self.bgIMGView.centerX).offset(-ScaleBasedOn6(kCancerBtn_Padding + kCancerBtn_W/2));
            }];
        } else if (i == 5) { // 左下
            [cancerBtn updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(2*kCancerBtn_Top + 2*kCancerBtn_W + kCancerBtn_Top/2));
                make.trailing.equalTo(self.bgIMGView.centerX).offset(-ScaleBasedOn6(kCancerBtn_Padding + kCancerBtn_W/2));
            }];
        } else if (i == 6) { // 右上
            [cancerBtn updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(kCancerBtn_Top + kCancerBtn_W + kCancerBtn_Top/2));
                make.leading.equalTo(self.bgIMGView.centerX).offset(ScaleBasedOn6(kCancerBtn_Padding + kCancerBtn_W/2));
            }];
        } else if (i == 7) { // 右下
            [cancerBtn updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.infoLab.bottom).offset(ScaleBasedOn6(2*kCancerBtn_Top + 2*kCancerBtn_W + kCancerBtn_Top/2));
                make.leading.equalTo(self.bgIMGView.centerX).offset(ScaleBasedOn6(kCancerBtn_Padding + kCancerBtn_W/2));
            }];
        }
    }
    [self.bgIMGView setNeedsLayout];
    [self.bgIMGView layoutIfNeeded];
}


#pragma mark - AboutPDQBlurViewDelegate
- (void)aboutPDQBlurView:(AboutPDQBlurView *)aboutView didTappedCloseBtn:(id)sender {
//    [aboutView removeFromSuperview];
//    [self showAnimations];
}




#pragma mark - TestDemo
- (void)testAFNetWorking {
    UCZProgressView *progressView = [[UCZProgressView alloc] initLoadingStyleWithIsUseArcAnim:NO];
    progressView.animationDidStopBlock = ^{
        //[self cancerBtnAction:nil];
    };
    [self.view addSubview:progressView];
    [progressView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    NSDictionary *params = @{@"c":@"", @"x":@"", @"userId":@"", @"token":@""};
    [[JCHTTPSessionManager sharedManager] requestWithMethod:HTTP_GET URLString:URL_GetCancerList parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        progressView.progress = 1;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        progressView.progress = 1;
    }];
}


- (void)testDrawTextAnimation {
    CGMutablePathRef letters = CGPathCreateMutable();   //创建path
    
    CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica-Bold"), 16.0f, NULL);       //设置字体
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)font, kCTFontAttributeName, nil];
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"" attributes:attrs];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"权威的癌症资料文献" attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);   //创建line
    CFArrayRef runArray = CTLineGetGlyphRuns(line);     //根据line获得一个数组
    
    // 获得每一个 run
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // 获得 run 的字体
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // 获得 run 的每一个形象字
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // 获得形象字
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            //获得形象字信息
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // 获得形象字外线的path
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    //根据构造出的 path 构造 bezier 对象
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    //根据 bezier 创建 shapeLayer对象
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
//    pathLayer.strokeColor = [[UIColor blackColor] CGColor];
//    pathLayer.fillColor = nil;
    pathLayer.strokeColor = Color_Blue.CGColor;
    pathLayer.fillColor = Color_LightBlue.CGColor;
    pathLayer.lineWidth = 0.5f;
    pathLayer.lineJoin = kCALineJoinBevel;
    
    [self.animationLayer addSublayer:pathLayer];
    
    self.pathLayer = pathLayer;
}


- (void)startAnimation {
    [self.pathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 5.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
}


- (void)setUpMenuController {
    QBPopupMenuItem *itemCopy = [QBPopupMenuItem itemWithTitle:@"复制" target:self action:@selector(menuItemTestAction:)];
    QBPopupMenuItem *itemTranslate = [QBPopupMenuItem itemWithTitle:@"翻译" target:self action:@selector(menuItemTestAction:)];
    QBPopupMenuItem *itemSearch = [QBPopupMenuItem itemWithTitle:@"搜索" target:self action:@selector(menuItemTestAction:)];
    //    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithImage:[UIImage imageNamed:@"image"] target:self action:@selector(action:)];
    self.popupMenu = [[QBPopupMenu alloc] initWithItems:@[itemCopy, itemTranslate, itemSearch]];
}

- (void)menuItemTestAction:(UIMenuController *)sender {
    DebugLog(@"%@", sender);
}


@end
