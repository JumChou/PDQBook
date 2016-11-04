//
//  DictionaryDescCell.m
//  PDQBook
//
//  Created by Mr.Chou on 16/9/6.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "DictionaryDescCell.h"
#import "CommonDefine.h"
#import "SRDictionaryDescView.h"
#import "SRDictionaryCell.h"


static const CGFloat DicDescView_Padding = 16.f;

@interface DictionaryDescCell ()

@property (nonatomic, strong) SRDictionaryDescView *dicDescView;

@end

@implementation DictionaryDescCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dicDescView = [[SRDictionaryDescView alloc] initWithSearchResult:nil];
        [self.contentView addSubview:self.dicDescView];
        [self.dicDescView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0,
                                                                         SRTitleView_Flag_Leading,
                                                                         DicDescView_Padding,
                                                                         SRTitleView_Flag_Leading));
        }];
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


#pragma mark - ConfigureCell
- (void)configureWithData:(SearchResult *)dicResult {
    [self.dicDescView setUpViewsWithData:dicResult];
}


#pragma mark - ClassMethod
/**
 通过数据计算完整高
 
 @param searchResult 展示数据
 
 @return 完整高
 */
+ (CGFloat)calculateFullHeightWithData:(SearchResult *)searchResult {
    CGFloat dicDescViewConstraintWidth = (kScreenWidth - 2*SRTitleView_Flag_Leading);
    CGFloat dicDescViewH = [SRDictionaryDescView calculateHeightWithData:searchResult
                                                         constraintWidth:dicDescViewConstraintWidth];
    CGFloat finalH = dicDescViewH + DicDescView_Padding;
    return finalH;
}




@end
