//
//  SRPaperCell.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRPaperCell.h"
#import "CommonDefine.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>

static const CGFloat kDescLab_Top = 10.f;
static const CGFloat kDescLab_FontSize = 15.f;
static const CGFloat kMoreBtn_W = 11.f;

@interface SRPaperCell ()

@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) VBFPopFlatButton *moreBtn;

@end

@implementation SRPaperCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initViews];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initViews {
    [super initViews];
    
    self.descLab = [[UILabel alloc] init];
    self.descLab.text = @"";
    self.descLab.backgroundColor = [UIColor clearColor];
//    self.descLab.backgroundColor = Color_TextGreen;
    self.descLab.textColor = Color_Navy;
    self.descLab.textAlignment = NSTextAlignmentLeft;
    self.descLab.font = [UIFont systemFontOfSize:kDescLab_FontSize];
    self.descLab.numberOfLines = 0;
    [self.descLab sizeToFit];
    [self addSubview:self.descLab];
    [self.descLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom).offset(kDescLab_Top);
        make.leading.equalTo(self.BGView).offset(SRTitleView_Flag_Leading);
        make.trailing.equalTo(self.BGView).offset(-SRTitleView_Flag_Leading);
        make.bottom.equalTo(self.BGView).offset(-kDescLab_Top);
    }];
    
    self.moreBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, kMoreBtn_W, kMoreBtn_W)
                                                  buttonType:buttonForwardType
                                                 buttonStyle:buttonRoundedStyle
                                       animateToInitialState:NO];
//    self.moreBtn.lineThickness = 2;
//    self.moreBtn.lineRadius = 2;
//    self.moreBtn.tintColor = Color_Line;
//    self.moreBtn.backgroundColor = Color_Navy;
//    self.moreBtn.roundBackgroundColor = Color_Navy;
    self.moreBtn.tintColor = [UIColor whiteColor];
    self.moreBtn.roundBackgroundColor = Color_Line;
//    [self.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:self.moreBtn];
    [self.moreBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleView);
        make.trailing.equalTo(self.titleView).offset(-24);
        make.width.equalTo(kMoreBtn_W);
        make.height.equalTo(kMoreBtn_W);
    }];
}


#pragma mark - Mehtod
- (void)setUpViewsWithData:(SearchResult *)searchResult {
    [self.titleView configureWithTitle:searchResult.title];
    
    NSMutableArray *wordsRanges = [NSMutableArray array];
    NSString *descriptionStr = [searchResult.desc processAndGetSpecificWordsRanges:wordsRanges];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:descriptionStr];
    for (NSValue *rangeValue in wordsRanges) {
        NSRange wordsRange = [rangeValue rangeValue];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:Color_Blue range:wordsRange];
//        [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:kDescLab_FontSize] range:wordsRange];
    }
    self.descLab.attributedText = attributedStr;
//    self.descLab.text = searchResult.desc;
}


#pragma mark - ClassMethod
/**
 通过数据计算完整高
 
 @param searchResult 展示数据
 
 @return 完整高
 */
+ (CGFloat)calculateFullHeightWithData:(SearchResult *)searchResult {
    CGFloat constraintWidth = kScreenWidth - 2*SRTitleView_Flag_Leading;
    CGFloat descLabH = [searchResult.desc sizeWithConstraintSize:CGSizeMake(constraintWidth, FLT_MAX)
                                                            font:[UIFont systemFontOfSize:(kDescLab_FontSize)]].height;
    CGFloat finalH = SRTitleView_H + descLabH + 3*kDescLab_Top;
    return finalH;
}



@end
