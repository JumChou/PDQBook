//
//  MPSearchPartView.h
//  PDQBook
//
//  MainVC搜索部分页面
//  Created by Mr.Chou on 16/7/14.
//  Since v1.0.0
//  Copyright (c) 2016年 weihaisi. All rights reserved.
//

#import "MPSearchPartView.h"

static NSString *const kSearchPlaceholder = @"癌症专业词典、癌症药典查询";
static const CGFloat SearchIMGView_Leading = 20.0f;
static const CGFloat SearchIMGView_W = 20.0f;
static const CGFloat SearchLab_Leading = 10.0f;
static const CGFloat SearchLab_Trailing = 20.0f;
static const CGFloat SearchLab_FontSize = 16.0f;

typedef void (^TapHandleBlock)(void);

@interface MPSearchPartView ()

@property (nonatomic, strong) UIButton *bgBtn;
@property (nonatomic, strong) UIImageView *searchIMGView;
@property (nonatomic, strong) UILabel *searchLab;

@property (nonatomic, copy) TapHandleBlock tapHandler;

@end

@implementation MPSearchPartView

/**
 *  @author zhoujunhao, 2016-07-14 09:39:00
 *  @since  v1.0.0
 *
 *  初始化MPSearchPartView
 *
 *  @param tapHandler 点击的处理block
 *
 */
- (id)initWithTapHandler:(void(^)())tapHandler {
    self = [self init];
    if (self) {
        self.tapHandler = tapHandler;
        [self setUpViews];
    }
    
    return self;
}

- (void)setUpViews {
//    self.backgroundColor = [UIColor whiteColor];
//    self.layer.cornerRadius = ScaleBasedOn6(CornerRadius);
    self.userInteractionEnabled = YES;
    
    self.bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgBtn setBackgroundColor:[UIColor clearColor]];
    [self.bgBtn setBackgroundImage:[UIImage imageNamed:@"MainVC_SearchBG"] forState:UIControlStateNormal];
    [self.bgBtn addTarget:self action:@selector(bgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.bgBtn];
    [self.bgBtn makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsZero);
    }];
    
    self.searchIMGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainVC_Search"]];
    self.searchIMGView.userInteractionEnabled = NO;
    [self.bgBtn addSubview:self.searchIMGView];
    [self.searchIMGView makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgBtn);
        make.leading.equalTo(self.bgBtn).offset(ScaleBasedOn6(SearchIMGView_Leading));
        make.width.equalTo(ScaleBasedOn6(SearchIMGView_W));
        make.height.equalTo(self.searchIMGView.width);
    }];
    
    self.searchLab = [[UILabel alloc] init];
    self.searchLab.userInteractionEnabled = NO;
    self.searchLab.text = kSearchPlaceholder;
    self.searchLab.backgroundColor = [UIColor clearColor];
    self.searchLab.textColor = Color_TextNavy;
    self.searchLab.font = [UIFont defaultFontWithSize:ScaleBasedOn6(SearchLab_FontSize)];
    self.searchLab.textAlignment = NSTextAlignmentCenter;
    [self.bgBtn addSubview:self.searchLab];
    [self.searchLab makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgBtn);
        make.leading.equalTo(self.searchIMGView.trailing).offset(ScaleBasedOn6(SearchLab_Leading));
        make.trailing.equalTo(self.bgBtn).offset(-ScaleBasedOn6(SearchLab_Trailing));
        make.height.equalTo(SearchIMGView_W);
    }];
}

#pragma mark - Method
- (void)bgBtnAction:(UIButton *)sender {
    DebugLog(@"");
    self.tapHandler();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
