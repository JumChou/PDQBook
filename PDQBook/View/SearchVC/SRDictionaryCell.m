//
//  SRDictionaryCell.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/17.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRDictionaryCell.h"
#import "CommonDefine.h"
#import <VBFPopFlatButton/VBFPopFlatButton.h>
#import "SearchResult.h"
#import "SRDictionaryDescView.h"

static const CGFloat ExpandBGBtn_H = 30.f;
static const CGFloat ExpandBtn_H = 24.f;

static const CGFloat DicDescView_Padding = 16.f;
static const CGFloat DicDescView_BottomHold = DicDescView_Padding;

@interface SRDictionaryCell ()

@property (nonatomic, strong) UIView *dicContentView;
@property (nonatomic, strong) NSMutableArray *dicDescViewAry;

@property (nonatomic, strong) UIButton *expandBGBtn;
@property (nonatomic, strong) VBFPopFlatButton *expandBtn;

@property (nonatomic, strong) UIView *switchMarkerView;

@end

@implementation SRDictionaryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - InitViews
- (void)initViews {
    [super initViews];
    [self initExpandViews];
    [self initDicContentViews];
    
    self.switchMarkerView = [UIView new];
    self.switchMarkerView.backgroundColor = [UIColor clearColor];
    [self.BGView addSubview:self.switchMarkerView];
    [self.switchMarkerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.bottom.equalTo(self.BGView);
        make.width.equalTo(10.f);
    }];
}

- (void)initExpandViews {
    self.expandBGBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.expandBGBtn setBackgroundColor:[UIColor clearColor]];
    [self.expandBGBtn addTarget:self action:@selector(expandBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.BGView addSubview:self.expandBGBtn];
    [self.expandBGBtn makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.BGView);
        make.height.equalTo(ExpandBGBtn_H);
    }];
    
    self.expandBtn = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)
                                                  buttonType:buttonDownBasicType
                                                 buttonStyle:buttonPlainStyle
                                       animateToInitialState:NO];
    self.expandBtn.lineThickness = 2;
    self.expandBtn.lineRadius = 2;
    self.expandBtn.tintColor = Color_Line;
    [self.expandBtn addTarget:self action:@selector(expandBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.titleBGView addSubview:self.expandBtn];
    [self.expandBGBtn addSubview:self.expandBtn];
    [self.expandBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.titleBGView);
//        make.trailing.equalTo(self.titleBGView).offset(-24);
        make.center.equalTo(self.expandBGBtn);
        make.width.equalTo(ExpandBtn_H);
        make.height.equalTo(ExpandBtn_H);
    }];
}

- (void)initDicContentViews {
    self.dicContentView = [UIView new];
    self.dicContentView.backgroundColor = [UIColor clearColor];
//    self.dicContentView.backgroundColor = Color_LightBlue;
    self.dicContentView.clipsToBounds = YES;
    [self.BGView addSubview:self.dicContentView];
    [self.dicContentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.bottom);
        make.leading.trailing.equalTo(self.BGView);
        make.bottom.equalTo(self.expandBGBtn.top);
    }];
    
    self.dicDescViewAry = [NSMutableArray array];
    SRDictionaryDescView *lastView;
    for (int i = 0; i < 3; i++) {
        SRDictionaryDescView *dicDescView = [[SRDictionaryDescView alloc] initWithSearchResult:nil];
        dicDescView.alpha = 0;
        [self.dicContentView addSubview:dicDescView];
        [dicDescView makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.bottom).offset(DicDescView_Padding);
            } else {
                make.top.equalTo(self.dicContentView);
            }
            make.leading.equalTo(self.dicContentView).offset(SRTitleView_Flag_Leading);
            make.trailing.equalTo(self.dicContentView).offset(-SRTitleView_Flag_Leading);
//            make.height.equalTo(0);
        }];
        
        [self.dicDescViewAry addObject:dicDescView];
        lastView = dicDescView;
    }
}


#pragma mark - PrivateMethod
- (void)expandBtnAction:(UIButton *)sender {
    /*
    if (self.expandBtn.currentButtonType == buttonDownBasicType) {
        self.expandBtn.currentButtonType = buttonUpBasicType;
    } else if (self.expandBtn.currentButtonType == buttonUpBasicType) {
        self.expandBtn.currentButtonType = buttonDownBasicType;
    }
     */
    if ([self.delegate respondsToSelector:@selector(expandBtnActionInCell:)]) {
        [self.delegate expandBtnActionInCell:self];
    }
}


#pragma mark - Mehtod
- (void)setUpViewsWithData:(NSArray *)data expandedState:(SRCellExpandedState)expandedState {
    self.expandedState = expandedState;
    if (expandedState == ExpandedState_None) { // 不可展开
        [self.expandBGBtn updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(0);
        }];
        self.expandBtn.alpha = 0;
        
    } else { // 可展开
        [self.expandBGBtn updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(ExpandBGBtn_H);
        }];
        self.expandBtn.alpha = 1;
        
        if (expandedState == ExpandedState_Yes) { // 展开
            self.expandBtn.currentButtonType = buttonUpBasicType;
        } else if (expandedState == ExpandedState_NO) { // 收起
            self.expandBtn.currentButtonType = buttonDownBasicType;
        }
    }
    
    SearchResult *searchResult = data[0];
    [self.titleView configureWithTitle:searchResult.type];
    self.language = searchResult.language;
//    if (self.language == SRLanguage_CN) {
//        self.switchMarkerView.backgroundColor = SRDictionaryCell_Color_SwitchEN;
//    } else {
//        self.switchMarkerView.backgroundColor = SRDictionaryCell_Color_SwitchCN;
//    }
    /* 【v1】
    for (UIView *view in self.dicContentView.subviews) { // 清除所有dicDescView
        [view removeFromSuperview];
    }
     */
    
    for (int i = 0; i < self.dicDescViewAry.count; i++) {
        SRDictionaryDescView *dicDescView = [self.dicDescViewAry objectAtIndex:i];
        if (i < data.count) {
            SearchResult *result = [data objectAtIndex:i];
            [dicDescView setUpViewsWithData:result];
            CGFloat dicDescViewH = [SRDictionaryDescView calculateHeightWithData:result constraintWidth:(kScreenWidth - 2*SRTitleView_Flag_Leading)];
            [dicDescView updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(dicDescViewH);
            }];
            dicDescView.alpha = 1;
        } else {
            dicDescView.alpha = 0;
        }
    }
    /* 【v1】
    SRDictionaryDescView *lastView;
    for (int i = 0; i < data.count; i++) {
        if (i > 1) { // 【v2修改】限制结果数量
            break;
        }
        SearchResult *result = [data objectAtIndex:i];
        SRDictionaryDescView *dicDescView = [[SRDictionaryDescView alloc] initWithSearchResult:result];
        CGFloat dicDescViewH = [SRDictionaryDescView calculateHeightWithData:result constraintWidth:(kScreenWidth - 2*SRBasicCell_TitleFlag_Leading)];
        [self.dicContentView addSubview:dicDescView];
        [dicDescView makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.bottom).offset(DicDescView_Padding);
            } else {
                make.top.equalTo(self.dicContentView);
            }
            make.leading.equalTo(self.dicContentView).offset(SRBasicCell_TitleFlag_Leading);
            make.trailing.equalTo(self.dicContentView).offset(-SRBasicCell_TitleFlag_Leading);
            make.height.equalTo(dicDescViewH);
        }];
        
        lastView = dicDescView;
    }
     */
}


#pragma mark - ClassMethod
/**
 通过数据计算内容高度（不包含底部展开btn）

 @param data 展示数据

 @return 内容高度
 */
+ (CGFloat)calculateContentHeightWithData:(NSArray *)data {
    CGFloat dicContentHeight = 0;
    for (SearchResult *searchResult in data) {
        dicContentHeight += [SRDictionaryDescView calculateHeightWithData:searchResult constraintWidth:(kScreenWidth - 2*SRTitleView_Flag_Leading)];
    }
    dicContentHeight += DicDescView_Padding * (data.count - 1);
    
    CGFloat finalHeight = SRTitleView_H + dicContentHeight + DicDescView_BottomHold + SRBasicCell_BG_Bottom;
    return finalHeight;
}

/**
 根据内容高、展开情况计算完整高
 
 @param contentHeight 内容高
 @param expandedState 可否展开情况
 
 @return 完整高
 */
+ (CGFloat)calculateFullHeightWithContentHeight:(CGFloat)contentHeight
                                  expandedState:(SRCellExpandedState)expandedState {
    if (expandedState != ExpandedState_None) {
        contentHeight += ExpandBGBtn_H;
    }
    
    return contentHeight;
}

/**
 通过数据、展开情况计算完整高
 
 @param data          展示数据
 @param expandedState 可否展开情况
 
 @return 完整高
 */
+ (CGFloat)calculateFullHeightWithData:(NSArray *)data
                         expandedState:(SRCellExpandedState)expandedState {
    CGFloat contentHeight = [self calculateContentHeightWithData:data];
    
    if (expandedState != ExpandedState_None) {
        contentHeight += ExpandBGBtn_H;
    }
    
    CGFloat finalHeight = SRTitleView_H + contentHeight;
    return finalHeight;
}


@end
