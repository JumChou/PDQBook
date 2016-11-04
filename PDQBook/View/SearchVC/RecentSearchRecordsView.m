//
//  RecentSearchRecordsView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/14.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "RecentSearchRecordsView.h"
#import "CommonDefine.h"

static const CGFloat RecentNullIMG_Top = 80.f;
static const CGFloat RecentNullIMG_Top_iPhone4 = 15.f;
static const CGFloat RecentNullIMG_W = 254.f/2;
static const CGFloat RecentNullIMG_H = 234.f/2;
static const CGFloat RecentNullLab_Top = 10.f;
static const CGFloat RecentNullLab_H = 50.f;
static const CGFloat RecentNullLab_FontSize = 18.f;

@interface RecentSearchRecordsView ()

@property (nonatomic, strong) UIImageView *recentNullImgView;
@property (nonatomic, strong) UILabel *recentNullLab;


@end

@implementation RecentSearchRecordsView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = Color_LightGray;
        
        self.recentNullImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search_RecentNull"]];
        [self addSubview:self.recentNullImgView];
        [self.recentNullImgView makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(iPhone4 ? RecentNullIMG_Top_iPhone4 : ScaleBasedOn6(RecentNullIMG_Top));
            make.width.equalTo(ScaleBasedOn6(RecentNullIMG_W));
            make.height.equalTo(ScaleBasedOn6(RecentNullIMG_H));
        }];
        
        self.recentNullLab = [[UILabel alloc] init];
        self.recentNullLab.text = @"试着搜索点什么吧^0^";
        self.recentNullLab.backgroundColor = [UIColor clearColor];
        self.recentNullLab.textColor = Color_TextLightGray;
        self.recentNullLab.textAlignment = NSTextAlignmentCenter;
        self.recentNullLab.font = [UIFont defaultFontWithSize:ScaleBasedOn6(RecentNullLab_FontSize)];
        [self addSubview:self.recentNullLab];
        [self.recentNullLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.recentNullImgView.bottom).offset(ScaleBasedOn6(RecentNullLab_Top));
            make.leading.trailing.equalTo(self);
            make.height.equalTo(ScaleBasedOn6(RecentNullLab_H));
        }];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.alpha = 0.f;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.tableFooterView = [UIView new];
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            //make.edges.equalTo(self).insets(UIEdgeInsetsMake((kStatusBarHeight+kNavBarHeight), 0, 0, 0));
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    
    return self;
}


- (void)reloadViews {
    NSInteger dataCount = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:0];
    self.recentNullImgView.alpha = dataCount ? 0.f : 1.f;
    self.recentNullLab.alpha = dataCount ? 0.f : 1.f;
    self.tableView.alpha = dataCount ? 1.f : 0.f;
    [self.tableView reloadData];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
