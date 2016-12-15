//
//  CEResultViewController.m
//  PDQBook
//
//  Created by Mr.Chou on 2016/11/11.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CEResultViewController.h"
#import "JCAnimatedArcView.h"
#import "JCColorfulCircleView.h"
#import "CancerViewController.h"
#import "CEPointSelectWebViewController.h"

#define kVeryLowLevelDesc   @"极低致癌风险"
#define kLowLevelDesc       @"较低致癌风险"
#define kNormalLevelDesc    @"较高致癌风险"
#define kHighLevelDesc      @"高致癌风险"
#define kVeryHighLevelDesc  @"极高致癌风险"

// 蓝色68d4ff 绿色b1eec0 黄色fff467 橘黄ffc438 红色ff0000
#define ArcColor_Blue       [UIColor colorWithHexString:@"68d4ff"]
#define ArcColor_Green      [UIColor colorWithHexString:@"b1eec0"]
#define ArcColor_Yellow     [UIColor colorWithHexString:@"ffeb67"]
#define ArcColor_Orange     [UIColor colorWithHexString:@"ffc438"]
#define ArcColor_Red        [UIColor colorWithHexString:@"ff0000"]

#define Color_BG            [UIColor colorWithHexString:@"f9fafc"]
#define Color_MedicalInfo   [UIColor colorWithHexString:@"90DCDD"]
#define Color_MedicalBook   [UIColor colorWithHexString:@"72BFF5"]

static const CGFloat kTitleLabel_Top = 54.0f;
static const CGFloat kTitleLabel_H = 50.0f;
static const CGFloat kTitleLabel_FontSize_L = 23.0f;
static const CGFloat kTitleLabel_FontSize_S = 15.0f;

static const CGFloat kBackBtn_Top = 32.0f;
static const CGFloat kBackBtn_Training = 23.0f;
static const CGFloat kBackBtn_W = 21.0f;
static const CGFloat kBackBtn_H = 20.0f;

static const CGFloat kArcPartBG_Top = 26.0f;
static const CGFloat kArcPartBG_W = 266.0f;
static const CGFloat kArc_Line_W = 24.0f;
static const CGFloat kColorfulCircle_W = 130.0f;           // 渐变色圆宽
static const CGFloat kColorfulCircle_WidthMultiple = 8.5f; // 渐变色圆的渐变layer宽度比
static const CGFloat kResultLabel_H = 40.f;
static const CGFloat kResultLabel_FontSize_L = 16.f;
static const CGFloat kResultLabel_FontSize_S = 14.f;

static const CGFloat kMarkerPartBG_Top = 22.0f;
static const CGFloat kMarkerPartBG_Leading = 26.0f;
static const CGFloat kMarkerPartBG_H = 44.0f;
static const CGFloat kMarkerIMG_Leading = 100.0f;
static const CGFloat kMarkerIMG_W = 13.0f;
static const CGFloat kMarkerIMG_H = 13.5f;
static const CGFloat kMarkerLabel_Leading = 6.0f;
static const CGFloat kMarkerLabel_H = 26.0f;
static const CGFloat kMarkerLabel_W = 90.0f;
static const CGFloat kMarkerLabel_FontSize = 14.0f;

static const CGFloat kDescInfoLabel_Top = 26.f;
static const CGFloat kDescInfoLabel_W = 300.f;
static const CGFloat kDescInfoLabel_H = 50.f;
static const CGFloat kDescInfoLabel_FontSize = 16.f;

static const CGFloat kMoreBtn_Top = 15.f;
static const CGFloat kMoreBtn_W = 280.f;
static const CGFloat kMoreBtn_H = 22.f;
static const CGFloat kMoreBtn_FontSize = 15.f;

static const CGFloat kMedicalBtn_Bottom = 24.f;
static const CGFloat kMedicalBtn_Offset = 16.f;
static const CGFloat kMedicalBtn_W = 126.f;
static const CGFloat kMedicalBtn_H = 40.f;
static const CGFloat kMedicalBtn_FontSize = 16.f;


typedef NS_ENUM(NSInteger, CEResultLevel) {
    CEResultLevel_VeryLow,
    CEResultLevel_Low,
    CEResultLevel_Normal,
    CEResultLevel_High,
    CEResultLevel_VeryHigh
};

@interface CEResultViewController ()

@property (nonatomic, strong) UIImageView *BGView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *arcPartBGView;
@property (nonatomic, strong) JCAnimatedArcView *arcView;
@property (nonatomic, strong) UIImageView *circleInArcView;
@property (nonatomic, strong) JCColorfulCircleView *colorfulCircleView;
@property (nonatomic, strong) UIImageView *arcShadowView; // deprecated
@property (nonatomic, strong) UIImageView *colorfulCircleShadowView; // deprecated
@property (nonatomic, strong) UILabel *resultLabel;

@property (nonatomic, strong) UIView *markerPartBGView;

@property (nonatomic, strong) UILabel *descInfoLabel;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *medicalInfoBtn;
@property (nonatomic, strong) UIButton *medicalBookBtn;

@property (nonatomic, strong) UIButton *testBtn;
@property (nonatomic, assign) CEResultLevel testLevel;

@end

@implementation CEResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.BGView.backgroundColor = Color_Clear;
    self.BGView.backgroundColor = Color_BG;
    self.BGView.userInteractionEnabled = YES;
    [self.view addSubview:self.BGView];
    [self.BGView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsZero);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = Color_Clear;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.userInteractionEnabled = YES;
    [self.BGView addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BGView);
        make.top.equalTo(self.BGView).offset(ScaleBasedOn6(kTitleLabel_Top));
        make.height.equalTo(ScaleBasedOn6(kTitleLabel_H));
        make.width.equalTo(self.BGView);
    }];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"癌症风险指数" attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kTitleLabel_FontSize_L)], NSForegroundColorAttributeName:Color_Navy}]];
    [attributedStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n美国哈佛研究院" attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kTitleLabel_FontSize_S)], NSForegroundColorAttributeName:Color_TextLightGray}]];
    self.titleLabel.attributedText = attributedStr;
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backBtn.backgroundColor = Color_Clear;
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"CEResultVC_Btn_Back"] forState:UIControlStateNormal];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [self.backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.BGView addSubview:self.backBtn];
    [self.backBtn makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.BGView).offset(ScaleBasedOn6(kBackBtn_Top));
        make.trailing.equalTo(self.BGView).offset(-ScaleBasedOn6(kBackBtn_Training));
        make.width.equalTo(kBackBtn_W);
        make.height.equalTo(kBackBtn_H);
    }];
    
    [self initArcPartViews];
    [self initMarkerPartViews];
    
    self.descInfoLabel = [[UILabel alloc] init];
    self.descInfoLabel.backgroundColor = Color_Clear;
    self.descInfoLabel.textColor = Color_TextLightGray;
    self.descInfoLabel.textAlignment = NSTextAlignmentCenter;
    self.descInfoLabel.font = [UIFont defaultFontWithSize:ScaleBasedOn6(kDescInfoLabel_FontSize)];
    self.descInfoLabel.numberOfLines = 0;
    [self.BGView addSubview:self.descInfoLabel];
    [self.descInfoLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.markerPartBGView);
        make.top.equalTo(self.markerPartBGView.bottom).offset(ScaleBasedOn6(kDescInfoLabel_Top));
        make.width.equalTo(ScaleBasedOn6(kDescInfoLabel_W));
        make.height.equalTo(ScaleBasedOn6(kDescInfoLabel_H));
    }];
    [self.descInfoLabel sizeToFit];
    
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.backgroundColor = Color_Clear;
    self.moreBtn.titleLabel.numberOfLines = 0;
    self.moreBtn.titleLabel.font = [UIFont boldDefaultFontWithSize:ScaleBasedOn6(kMoreBtn_FontSize)];
    [self.moreBtn setTitleColor:Color_Navy forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"更多癌症筛查、预防和治疗信息 >>" forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(moreBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.BGView addSubview:self.moreBtn];
    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BGView);
        make.top.equalTo(self.descInfoLabel.bottom).offset(ScaleBasedOn6(kMoreBtn_Top));
        make.width.equalTo(ScaleBasedOn6(kMoreBtn_W));
        make.height.equalTo(ScaleBasedOn6(kMoreBtn_H));
    }];
    
    self.medicalInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.medicalInfoBtn.backgroundColor = Color_MedicalInfo;
    self.medicalInfoBtn.backgroundColor = Color_MedicalBook;
    self.medicalInfoBtn.layer.cornerRadius = 4;
    self.medicalInfoBtn.titleLabel.font = [UIFont boldDefaultFontWithSize:ScaleBasedOn6(kMedicalBtn_FontSize)];
    [self.medicalInfoBtn setTitle:@"了解体检筛查" forState:UIControlStateNormal];
    [self.medicalInfoBtn addTarget:self action:@selector(medicalInfoBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.BGView addSubview:self.medicalInfoBtn];
    [self.medicalInfoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.BGView).offset(-ScaleBasedOn6(kMedicalBtn_Bottom));
        make.trailing.equalTo(self.BGView.centerX).offset(-ScaleBasedOn6(kMedicalBtn_Offset));
        make.width.equalTo(ScaleBasedOn6(kMedicalBtn_W));
        make.height.equalTo(ScaleBasedOn6(kMedicalBtn_H));
    }];
    
    self.medicalBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.medicalBookBtn.backgroundColor = Color_MedicalBook;
    self.medicalBookBtn.backgroundColor = Color_MedicalInfo;
    self.medicalBookBtn.layer.cornerRadius = 4;
    self.medicalBookBtn.titleLabel.font = [UIFont boldDefaultFontWithSize:ScaleBasedOn6(kMedicalBtn_FontSize)];
    [self.medicalBookBtn setTitle:@"预约体检筛查" forState:UIControlStateNormal];
    [self.medicalBookBtn addTarget:self action:@selector(medicalBookBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.BGView addSubview:self.medicalBookBtn];
    [self.medicalBookBtn makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.BGView).offset(-ScaleBasedOn6(kMedicalBtn_Bottom));
        make.leading.equalTo(self.BGView.centerX).offset(ScaleBasedOn6(kMedicalBtn_Offset));
        make.width.equalTo(ScaleBasedOn6(kMedicalBtn_W));
        make.height.equalTo(ScaleBasedOn6(kMedicalBtn_H));
    }];
    
    
    self.testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.testBtn.backgroundColor = Color_Clear;
    [self.testBtn addTarget:self action:@selector(testRandom) forControlEvents:UIControlEventTouchUpInside];
    [self.titleLabel addSubview:self.testBtn];
    [self.testBtn makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleLabel).insets(UIEdgeInsetsZero);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self testRandom];
//    CEResultLevel randomLevel = [self randomResultLevel];
//    [self animateArcPartViewsWithResultLevel:randomLevel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DebugLog(@"");
}


#pragma mark - InitViews
/**
 初始化环形部分View
 */
- (void)initArcPartViews {
    self.arcPartBGView = [[UIView alloc] init];
    self.arcPartBGView.backgroundColor = Color_Clear;
    [self.BGView addSubview:self.arcPartBGView];
    [self.arcPartBGView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.BGView);
        make.top.equalTo(self.titleLabel.bottom).offset(ScaleBasedOn6(kArcPartBG_Top));
        make.width.equalTo(ScaleBasedOn6(kArcPartBG_W));
        make.height.equalTo(ScaleBasedOn6(kArcPartBG_W));
    }];
    
    self.arcView = [[JCAnimatedArcView alloc] init];
    [self.arcPartBGView addSubview:self.arcView];
    [self.arcView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.arcPartBGView).insets(UIEdgeInsetsZero);
    }];
    
    CGFloat circleInArc_radius = ScaleBasedOn6((kArcPartBG_W - 2*kArc_Line_W)) / 2;
    self.circleInArcView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    self.circleInArcView.userInteractionEnabled = YES;
    self.circleInArcView.backgroundColor = Color_White;
    self.circleInArcView.layer.cornerRadius = circleInArc_radius;
    self.circleInArcView.layer.shadowOffset = CGSizeMake(2, -1);
    self.circleInArcView.layer.shadowOpacity = 0.1f;
    self.circleInArcView.layer.shadowRadius = 4;
    [self.arcPartBGView addSubview:self.circleInArcView];
    [self.circleInArcView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.arcPartBGView);
        make.width.equalTo(2*circleInArc_radius);
        make.height.equalTo(2*circleInArc_radius);
    }];
    
    self.colorfulCircleView = [[JCColorfulCircleView alloc] init];
    [self.circleInArcView addSubview:self.colorfulCircleView];
    [self.colorfulCircleView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.circleInArcView);
        make.width.equalTo(ScaleBasedOn6(kColorfulCircle_W));
        make.height.equalTo(ScaleBasedOn6(kColorfulCircle_W));
    }];
    
    self.resultLabel = [[UILabel alloc] init];
    self.resultLabel.backgroundColor = Color_Clear;
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    [self.arcPartBGView addSubview:self.resultLabel];
    [self.resultLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.colorfulCircleView);
        make.width.equalTo(self.colorfulCircleView);
        make.height.equalTo(ScaleBasedOn6(kResultLabel_H));
    }];
    
    self.colorfulCircleShadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CEResultVC_Circle_Shadow"]];
    [self.arcPartBGView addSubview:self.colorfulCircleShadowView];
    [self.colorfulCircleShadowView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.colorfulCircleView).insets(UIEdgeInsetsZero);
    }];
    
}


- (void)initMarkerPartViews {
    self.markerPartBGView = [[UIView alloc] init];
    self.markerPartBGView.backgroundColor = Color_Clear;
    [self.BGView addSubview:self.markerPartBGView];
    [self.markerPartBGView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.arcPartBGView.bottom).offset(ScaleBasedOn6(kMarkerPartBG_Top));
        make.leading.equalTo(self.BGView).offset(ScaleBasedOn6(kMarkerPartBG_Leading));
        make.trailing.equalTo(self.BGView).offset(-ScaleBasedOn6(kMarkerPartBG_Leading));
        make.height.equalTo(ScaleBasedOn6(kMarkerPartBG_H));
    }];
    
    UIImageView *lastMarkerView = nil;
    for (int i = 0; i < 5; i++) {
        UIImageView *markerIMGView = [[UIImageView alloc] init];
        [self.markerPartBGView addSubview:markerIMGView];
        
        UILabel *markerLabel = [[UILabel alloc] init];
        markerLabel.backgroundColor = Color_Clear;
        markerLabel.textColor = Color_TextLightGray;
        markerLabel.textAlignment = NSTextAlignmentLeft;
        markerLabel.font = [UIFont boldDefaultFontWithSize:ScaleBasedOn6(kMarkerLabel_FontSize)];
        [self.markerPartBGView addSubview:markerLabel];
        [markerLabel makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(markerIMGView);
            make.leading.equalTo(markerIMGView.trailing).offset(ScaleBasedOn6(kMarkerLabel_Leading));
            make.width.equalTo(ScaleBasedOn6(kMarkerLabel_W));
            make.height.equalTo(ScaleBasedOn6(kMarkerLabel_H));
        }];
        
        if (i == 0) {
            markerLabel.text = kVeryLowLevelDesc;
            markerIMGView.image = [UIImage imageNamed:@"CEResultVC_Marker_Blue"];
            [markerIMGView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.markerPartBGView);
                make.leading.equalTo(self.markerPartBGView);
                make.width.equalTo(ScaleBasedOn6(kMarkerIMG_W));
                make.height.equalTo(ScaleBasedOn6(kMarkerIMG_H));
            }];
            
        } else if (i == 1) {
            markerLabel.text = kLowLevelDesc;
            markerIMGView.image = [UIImage imageNamed:@"CEResultVC_Marker_Green"];
            [markerIMGView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.markerPartBGView);
                make.leading.equalTo(lastMarkerView.trailing).offset(ScaleBasedOn6(kMarkerIMG_Leading));
                make.width.equalTo(ScaleBasedOn6(kMarkerIMG_W));
                make.height.equalTo(ScaleBasedOn6(kMarkerIMG_H));
            }];
            
        } else if (i == 2) {
            markerLabel.text = kNormalLevelDesc;
            markerIMGView.image = [UIImage imageNamed:@"CEResultVC_Marker_Yellow"];
            [markerIMGView makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.markerPartBGView);
                make.leading.equalTo(lastMarkerView.trailing).offset(ScaleBasedOn6(kMarkerIMG_Leading));
                make.width.equalTo(ScaleBasedOn6(kMarkerIMG_W));
                make.height.equalTo(ScaleBasedOn6(kMarkerIMG_H));
            }];
            
        } else if (i == 3) {
            markerLabel.text = kHighLevelDesc;
            markerIMGView.image = [UIImage imageNamed:@"CEResultVC_Marker_Orange"];
            [markerIMGView makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.markerPartBGView);
                make.leading.equalTo(self.markerPartBGView);
                make.width.equalTo(ScaleBasedOn6(kMarkerIMG_W));
                make.height.equalTo(ScaleBasedOn6(kMarkerIMG_H));
            }];
            
        } else if (i == 4) {
            markerLabel.text = kVeryHighLevelDesc;
            markerIMGView.image = [UIImage imageNamed:@"CEResultVC_Marker_Red"];
            [markerIMGView makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.markerPartBGView);
                make.leading.equalTo(lastMarkerView.trailing).offset(ScaleBasedOn6(kMarkerIMG_Leading));
                make.width.equalTo(ScaleBasedOn6(kMarkerIMG_W));
                make.height.equalTo(ScaleBasedOn6(kMarkerIMG_H));
            }];
            
        }
        
        lastMarkerView = markerIMGView;
    }
    
}



#pragma mark - StatusBar
/// 回调设置StatusBarStyle
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark - EventAction
- (void)backBtnAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)moreBtnAction {
    Cancer *cancer = [Cancer cancerWithId:5];
    CancerViewController *cancerVC = [[CancerViewController alloc] initWithCancer:cancer];
    [self.navigationController pushViewController:cancerVC animated:YES];
}

- (void)medicalBookBtnAction {
    CEPointSelectWebViewController *pointSelectWebVC = [[CEPointSelectWebViewController alloc] init];
    [self.navigationController pushViewController:pointSelectWebVC animated:YES];
}


#pragma mark - Animation
- (void)animateArcPartViewsWithResultLevel:(CEResultLevel)resultLevel {
    self.resultLabel.layer.opacity = 0;
    CGFloat arcPercent = [self getPercentForArcWithLevel:resultLevel];
    CGFloat circlePercent = [self getPercentForColorfulCircleWithLevel:resultLevel];
    CGFloat duration = 1.5f;
    if (resultLevel == CEResultLevel_VeryLow) {
        duration = 1.f;
    } else if (resultLevel == CEResultLevel_VeryHigh) {
        duration = 2.f;
    }
    
    [self.arcView drawMajorArcWithLeftColors:@[ArcColor_Yellow, ArcColor_Green, ArcColor_Blue]
                                 rightColors:@[ArcColor_Yellow, ArcColor_Orange, ArcColor_Red]
                          leftColorLocations:@[@0.12f, @0.3f, @0.70f]
                         rightColorLocations:@[@0.09f, @0.25f, @0.68f]
                               trackArcColor:nil
                                   LineWidth:ScaleBasedOn6(kArc_Line_W)
                                     percent:arcPercent
                            animatedDuration:duration];
    
    NSArray *circleColors = @[ArcColor_Blue, ArcColor_Green, ArcColor_Yellow, ArcColor_Orange, ArcColor_Red];
    [self.colorfulCircleView drawCircleWithColors:circleColors
                                   colorLocations:[self getColorfulCircleLocations]
                               colorWidthMultiple:kColorfulCircle_WidthMultiple
                                          percent:circlePercent
                                 animatedDuration:duration];
    
    [self animateResultLabelWithLevel:resultLevel delay:duration];
}

- (void)animateResultLabelWithLevel:(CEResultLevel)resultLevel delay:(NSTimeInterval)delay {
    [self.resultLabel.layer removeAllAnimations];
    self.resultLabel.attributedText = [self getResultAttrStringWithLevel:resultLevel];
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    scaleAnimation.values = values;
    scaleAnimation.duration = 0.35f;
    scaleAnimation.beginTime = CACurrentMediaTime() + delay;
    scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    scaleAnimation.removedOnCompletion = NO;
    scaleAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @0.f;
    opacityAnimation.toValue = @1.f;
    opacityAnimation.duration = 0.1f;
    opacityAnimation.beginTime = CACurrentMediaTime() + delay;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    opacityAnimation.removedOnCompletion = NO;
    opacityAnimation.fillMode = kCAFillModeForwards;
    
    [self.resultLabel.layer addAnimation:opacityAnimation forKey:@"OpacityAnimation"];
    [self.resultLabel.layer addAnimation:scaleAnimation forKey:@"ScaleAnimation"];
}


#pragma mark - PrivateMethod
/**
 获得随机结果等级

 @return CEResultLevel
 */
- (CEResultLevel)randomResultLevel {
    CGFloat testRandomNum = (arc4random() % 100);
    CEResultLevel randomLevel = CEResultLevel_VeryLow;
    
    if (testRandomNum <= 20) {
        randomLevel = CEResultLevel_VeryLow;
    } else if (20 < testRandomNum && testRandomNum <= 40) {
        randomLevel = CEResultLevel_Low;
    } else if (40 < testRandomNum && testRandomNum <= 60) {
        randomLevel = CEResultLevel_Normal;
    } else if (60 < testRandomNum && testRandomNum <= 80) {
        randomLevel = CEResultLevel_High;
    } else if (60 < testRandomNum && testRandomNum <= 100) {
        randomLevel = CEResultLevel_VeryHigh;
    }
    
    return randomLevel;
}

- (NSMutableAttributedString *)getResultAttrStringWithLevel:(CEResultLevel)resultLevel {
    NSMutableAttributedString *resultStr = [[NSMutableAttributedString alloc] init];
    
    switch (resultLevel) {
        case CEResultLevel_VeryLow:
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:kVeryLowLevelDesc attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_L)], NSForegroundColorAttributeName:Color_White}]];
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n继续保持健康" attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_S)], NSForegroundColorAttributeName:Color_White}]];
            break;
            
        case CEResultLevel_Low:
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:kLowLevelDesc attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_L)], NSForegroundColorAttributeName:Color_White}]];
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n建议改善生活方式" attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_S)], NSForegroundColorAttributeName:Color_White}]];
            break;
            
        case CEResultLevel_Normal:
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:kNormalLevelDesc attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_L)], NSForegroundColorAttributeName:Color_White}]];
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n建议预约体检筛查" attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_S)], NSForegroundColorAttributeName:Color_White}]];
            break;
            
        case CEResultLevel_High:
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:kHighLevelDesc attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_L)], NSForegroundColorAttributeName:Color_White}]];
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n建议定期体检筛查" attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_S)], NSForegroundColorAttributeName:Color_White}]];
            break;
            
        case CEResultLevel_VeryHigh:
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:kVeryHighLevelDesc attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_L)], NSForegroundColorAttributeName:Color_White}]];
            [resultStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n建议立即体检筛查" attributes:@{NSFontAttributeName:[UIFont boldDefaultFontWithSize:ScaleBasedOn6(kResultLabel_FontSize_S)], NSForegroundColorAttributeName:Color_White}]];
            break;
            
        default:
            break;
    }
    
    return resultStr;
}

#pragma mark ArcCalculate
- (CGFloat)getPercentForArcWithLevel:(CEResultLevel)resultLevel {
    CGFloat percent = 0.f;
    
    switch (resultLevel) {
        case CEResultLevel_VeryLow:
            percent = 0.14f;
            break;
            
        case CEResultLevel_Low:
            percent = 0.29f;
            break;
            
        case CEResultLevel_Normal:
            percent = 0.55f;
            break;
            
        case CEResultLevel_High:
            percent = 0.75f;
            break;
            
        case CEResultLevel_VeryHigh:
            percent = 1.f;
            break;
            
        default:
            break;
    }
    
    return percent;
}

#pragma mark CircleCalculate
- (NSArray *)getColorfulCircleLocations {
    CGFloat basicNum = 1.f/kColorfulCircle_WidthMultiple;
    CGFloat blueLocation = 0.5f * basicNum;
    CGFloat greenLocation = 2.f * basicNum;
    CGFloat yellowLocation = 4.f * basicNum;
    CGFloat orangeLocation = 6.f * basicNum;
    CGFloat redLocation = 7.75f * basicNum;
    
    return @[[NSNumber numberWithFloat:blueLocation], [NSNumber numberWithFloat:greenLocation], [NSNumber numberWithFloat:yellowLocation], [NSNumber numberWithFloat:orangeLocation], [NSNumber numberWithFloat:redLocation]];
}

- (CGFloat)getPercentForColorfulCircleWithLevel:(CEResultLevel)resultLevel {
    CGFloat percent = 0.f;
    
    switch (resultLevel) {
        case CEResultLevel_VeryLow:
            percent = 0.1f;
            break;
            
        case CEResultLevel_Low:
            percent = 1.5f / kColorfulCircle_WidthMultiple;
            break;
        
        case CEResultLevel_Normal:
            percent = 4.0f / kColorfulCircle_WidthMultiple;
            break;
            
        case CEResultLevel_High:
            percent = 6.0f / kColorfulCircle_WidthMultiple;
            break;
            
        case CEResultLevel_VeryHigh:
            percent = 7.f / kColorfulCircle_WidthMultiple;
            break;
            
        default:
            break;
    }
    
    return percent;
}


#pragma mark -
- (void)testRandom {
    CEResultLevel randomLevel = [self randomResultLevel];
    [self animateArcPartViewsWithResultLevel:randomLevel];
    self.descInfoLabel.text = @"肺癌是发病率和死亡率增长最快，对人群健康和生命威胁最大的恶性肿瘤之一。";
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
