//
//  SRTitleView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/9/7.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRTitleView.h"
#import "CommonDefine.h"
#import "SRBasicCell.h"

@interface SRTitleView ()

@property (nonatomic, strong) UIImageView *titleBGView;
@property (nonatomic, strong) UIView *titleFlagView;
@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation SRTitleView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = Color_Clear;
        
        self.titleBGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        self.titleBGView.userInteractionEnabled = YES;
        self.titleBGView.backgroundColor = Color_Clear;
        [self addSubview:self.titleBGView];
        [self.titleBGView makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.height.equalTo(SRTitleView_H);
        }];
        
        self.titleFlagView = [UIView new];
        self.titleFlagView.backgroundColor = SRTitleView_Color_Title;
        self.titleFlagView.layer.cornerRadius = 1.7;
        [self.titleBGView addSubview:self.titleFlagView];
        [self.titleFlagView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.titleBGView);
            make.leading.equalTo(self.titleBGView).offset(SRTitleView_Flag_Leading);
            make.width.equalTo(SRTitleView_Flag_W);
            make.height.equalTo(SRTitleView_Flag_H);
        }];
        
        self.titleLab = [[UILabel alloc] init];
        self.titleLab.backgroundColor = Color_Clear;
        self.titleLab.textColor = SRTitleView_Color_Title;
        self.titleLab.textAlignment = NSTextAlignmentLeft;
        self.titleLab.font = [UIFont systemFontOfSize:SRTitleView_TitleLab_FontSize];
        [self.titleBGView addSubview:self.titleLab];
        [self.titleLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.titleBGView);
            make.leading.equalTo(self.titleFlagView.trailing).offset(SRTitleView_TitleLab_Leading);
            make.trailing.equalTo(self.titleBGView);
        }];
        
        UIView *titleBottomLine = [SRBasicCell getALine];
        [self.titleBGView addSubview:titleBottomLine];
        [titleBottomLine makeConstraints:^(MASConstraintMaker *make) {
            //        make.leading.trailing.bottom.equalTo(self.titleBGView);
            make.bottom.equalTo(self.titleBGView);
            make.leading.equalTo(self.titleBGView).offset(SRTitleView_BottomLine_Leading);
            make.trailing.equalTo(self.titleBGView).offset(-SRTitleView_BottomLine_Leading);
            make.height.equalTo(SRBasicCell_ALine_H);
        }];
    }
    
    return self;
}


- (void)configureWithTitle:(NSString *)title {
    self.titleLab.text = title;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
