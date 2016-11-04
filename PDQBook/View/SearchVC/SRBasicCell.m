//
//  SRBasicCell.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRBasicCell.h"
#import "CommonDefine.h"

@interface SRBasicCell ()



@end

@implementation SRBasicCell

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
    [self initBG];
    [self initTitleView];
    
}

- (void)initBG {
    self.BGView = [UIView new];
    self.BGView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.BGView];
    [self.BGView makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-SRBasicCell_BG_Bottom);
    }];
    
    UIView *topLine = [SRBasicCell getALine];
    [self.BGView addSubview:topLine];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.BGView);
        make.height.equalTo(SRBasicCell_ALine_H);
    }];
    
    UIView *bottomLine = [SRBasicCell getALine];
    [self.BGView addSubview:bottomLine];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self.BGView);
        make.height.equalTo(SRBasicCell_ALine_H);
    }];
}

- (void)initTitleView {
    self.titleView = [[SRTitleView alloc] init];
    [self.BGView addSubview:self.titleView];
    [self.titleView makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.BGView);
        make.height.equalTo(SRTitleView_H);
    }];
}


#pragma mark - PrivateMethod
+ (UIView *)getALine {
    UIView *line = [UIView new];
    line.backgroundColor = Color_Line;
    return line;
}


#pragma mark - ClassMethod
/**
 限制高度
 
 @return CGFloat
 */
+ (CGFloat)limitHeight {
    // System Font
//    return 190.f + SRBasicCell_BG_Bottom;
    // HYQiHei
    return 180.f + SRBasicCell_BG_Bottom;
}





@end
