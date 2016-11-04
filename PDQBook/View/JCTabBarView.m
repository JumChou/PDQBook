//
//  JCTabBarView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/26.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "JCTabBarView.h"
#import "CommonDefine.h"

#define Color_Lab_Normal    [UIColor colorWithHexString:@"67819e"]
#define Color_Lab_Selected  Color_Blue
//#define Color_BG            [UIColor whiteColor]
#define Color_BG            Color_LightGray
//#define Color_MarkerBG      [UIColor clearColor]
#define Color_MarkerBG      Color_LightBlue

@interface JCTabBarView ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) DRNRealTimeBlurView *blurView;
@property (nonatomic, strong) UIView *markerView;
@property (nonatomic, strong) UIView *markerBGView;
@property (nonatomic, strong) NSMutableArray *tabBarBtns;
@property (nonatomic, strong) NSMutableArray *tabBarLabs;

@property (nonatomic, assign) NSUInteger selectionCount;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation JCTabBarView

const float Lab_H = 16.f;
const float Lab_FontSize = 12.f;
const float Marker_H = 3.f;

- (id)initWithTitles:(NSArray *)titles btnBasicIMGName:(NSString *)btnBasicIMGName {
    self = [self init];
//    self = [self initWithFrame:CGRectMake(0, kScreenHeight-kTabBarHeight, kScreenWidth, kTabBarHeight)
//                     tintColor:[UIColor whiteColor]
//                       opacity:0.8
//                  cornerRadius:0];
    if (self) {
        self.selectionCount = titles.count;
        self.backgroundColor = Color_BG;
        
        self.lineView = [UIView new];
        self.lineView.backgroundColor = [UIColor lightGrayColor];
        self.lineView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.lineView];
        [self.lineView makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(0.5);
        }];
        
        self.tabBarBtns = [[NSMutableArray alloc] init];
        self.tabBarLabs = [[NSMutableArray alloc] init];
        UIButton *lastBtn;
        for (int i = 0; i < self.selectionCount; i++) {
            UIButton *tabBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tabBarBtn.tag = i;
            [tabBarBtn setBackgroundColor:[UIColor clearColor]];
            NSString *imageName = [NSString stringWithFormat:@"%@%zd", btnBasicIMGName, i];
            NSString *selectedImageName = [imageName stringByAppendingString:@"_"];
            [tabBarBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
            [tabBarBtn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
            [tabBarBtn addTarget:self action:@selector(tabBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:tabBarBtn];
            [tabBarBtn makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.leading.equalTo(self);
                } else {
                    make.leading.equalTo(lastBtn.trailing);
                }
                make.top.bottom.equalTo(self);
                make.width.equalTo(kScreenWidth/self.selectionCount);
            }];
            
            UILabel *tabBarLab = [[UILabel alloc] init];
            tabBarLab.text = [titles objectAtIndex:i];
            tabBarLab.backgroundColor = [UIColor lightGrayColor];
            tabBarLab.backgroundColor = [UIColor clearColor];
            tabBarLab.textColor = Color_Lab_Normal;
            tabBarLab.textAlignment = NSTextAlignmentCenter;
            tabBarLab.font = [UIFont defaultFontWithSize:ScaleBasedOn6(Lab_FontSize)];
            [self addSubview:tabBarLab];
            [tabBarLab makeConstraints:^(MASConstraintMaker *make) {
                make.leading.trailing.equalTo(tabBarBtn);
                make.bottom.equalTo(tabBarBtn).offset(-5);
                make.height.equalTo(Lab_H);
            }];
            
            [self.tabBarBtns addObject:tabBarBtn];
            [self.tabBarLabs addObject:tabBarLab];
            lastBtn = tabBarBtn;
        }
        
        self.markerBGView = [UIView new];
        self.markerBGView.backgroundColor = Color_MarkerBG;
        [self insertSubview:self.markerBGView atIndex:0];
        
        self.markerView = [UIView new];
        self.markerView.backgroundColor = Color_Blue;
        [self addSubview:self.markerView];
        
        [self changeToSelectedIndex:0];
        [self changeMarkerToSelectedIndex:0];
    }
    
    return self;
}


#pragma mark - Method
- (void)changeToSelectedIndex:(NSUInteger)selectedIndex {
    for (int i = 0; i < self.selectionCount; i++) {
        UIButton *tabBarBtn = [self.tabBarBtns objectAtIndex:i];
        UILabel *tabBarLab = [self.tabBarLabs objectAtIndex:i];
        if (i == selectedIndex) {
            tabBarBtn.selected = YES;
            tabBarLab.textColor = Color_Lab_Selected;
        } else {
            tabBarBtn.selected = NO;
            tabBarLab.textColor = Color_Lab_Normal;
        }
    }
    self.selectedIndex = selectedIndex;
}

- (void)changeMarkerToSelectedIndex:(NSUInteger)selectedIndex {
    [self.markerBGView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.leading.equalTo(self).offset(selectedIndex * (kScreenWidth/self.selectionCount));
        make.width.equalTo(kScreenWidth/self.selectionCount);
    }];
    
    [self.markerView remakeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.leading.equalTo(self).offset(selectedIndex * (kScreenWidth/self.selectionCount));
        make.width.equalTo(kScreenWidth/self.selectionCount);
        make.height.equalTo(Marker_H);
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)changeMarkerWithXOffsetRatio:(CGFloat)xOffsetRatio {
    CGFloat xOffSet = kScreenWidth * xOffsetRatio;
    [self.markerBGView updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(xOffSet);
    }];
    [self.markerView updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(xOffSet);
    }];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)tabBarBtnAction:(UIButton *)sender {
    [self changeToSelectedIndex:sender.tag];
    [self changeMarkerToSelectedIndex:sender.tag];
    
    if ([self.delegate respondsToSelector:@selector(tabBarView:didSelectedIndex:)]) {
        [self.delegate tabBarView:self didSelectedIndex:sender.tag];
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
