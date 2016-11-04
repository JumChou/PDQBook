//
//  SRDictionaryDescView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/17.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRDictionaryDescView.h"
#import "CommonDefine.h"

#define Color_Title     Color_Blue
#define Color_Desc      Color_Navy

static const CGFloat kTitleBG_H = 34.f;
static const CGFloat kCircleFlag_Leading = 0.f;
static const CGFloat kCircleFlag_H = 6.f;
static const CGFloat kTitleLab_Leading = 8.f;
static const CGFloat kTitleLab_FontSize = 17.f;
static const CGFloat kDescLab_FontSize = 16.f;

@interface SRDictionaryDescView ()

@property (nonatomic, strong) UIView *titleBGView;
@property (nonatomic, strong) UIView *circleFlag;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *descLab;

@end

@implementation SRDictionaryDescView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = Color_TextYellow;
        
        self.titleBGView = [UIView new];
        self.titleBGView.backgroundColor = [UIColor clearColor];
//        self.titleBGView.backgroundColor = Color_Navy;
        [self addSubview:self.titleBGView];
        [self.titleBGView makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(kTitleBG_H);
        }];
        
        self.circleFlag = [UIView new];
        self.circleFlag.backgroundColor = Color_Title;
        [self.titleBGView addSubview:self.circleFlag];
        [self.circleFlag makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleBGView);
            make.leading.equalTo(self.titleBGView).offset(kCircleFlag_Leading);
            make.width.equalTo(kCircleFlag_H);
            make.height.equalTo(kCircleFlag_H);
        }];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.text = @"无数据";
        self.titleLab.backgroundColor = [UIColor clearColor];
//        self.titleLab.backgroundColor = Color_TextLightGray;
        self.titleLab.textColor = Color_Title;
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = [UIFont defaultFontWithSize:kTitleLab_FontSize];
        [self.titleBGView addSubview:self.titleLab];
        [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.titleBGView);
            make.leading.equalTo(self.circleFlag.trailing).offset(kTitleLab_Leading);
            make.trailing.equalTo(self.titleBGView);
        }];
        
        self.descLab = [[UILabel alloc] init];
        self.descLab.text = @"无数据";
        self.descLab.backgroundColor = [UIColor clearColor];
//        self.descLab.backgroundColor = Color_TextGreen;
        self.descLab.textColor = Color_Desc;
        self.descLab.textAlignment = NSTextAlignmentLeft;
        self.descLab.font = [UIFont defaultFontWithSize:kDescLab_FontSize];
        self.descLab.numberOfLines = 0;
//        self.descLab.lineBreakMode = NSLineBreakByWordWrapping;
        [self.descLab sizeToFit];
        [self addSubview:self.descLab];
        [self.descLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleBGView.bottom);
            make.leading.trailing.equalTo(self.titleLab);
            make.bottom.equalTo(self);
        }];
    }
    
    return self;
}

- (id)initWithSearchResult:(SearchResult *)searchResult {
    self = [self init];
    if (self) {
        [self setUpViewsWithData:searchResult];
    }
    return self;
}

- (void)setUpViewsWithData:(SearchResult *)searchResult {
    self.titleLab.text = searchResult.title;
    self.descLab.attributedText = [searchResult.desc handledSearchWordFlag];
}


/**
 通过数据、约束宽计算完整高

 @param searchResult    展示数据
 @param constraintWidth 约束宽

 @return height
 */
+ (CGFloat)calculateHeightWithData:(SearchResult *)searchResult constraintWidth:(CGFloat)constraintWidth {
    CGFloat realConstraintWidth = constraintWidth - (kCircleFlag_Leading + kCircleFlag_H + kTitleLab_Leading);
    CGFloat descLabH = [searchResult.desc sizeWithConstraintSize:CGSizeMake(realConstraintWidth, FLT_MAX)
                                                            font:[UIFont defaultFontWithSize:(kDescLab_FontSize)]].height;
    CGFloat finalHeight = kTitleBG_H + descLabH;
    return finalHeight;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
