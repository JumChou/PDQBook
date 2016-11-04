//
//  SearchResultsView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/8/15.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SearchResultsView.h"
#import "CommonDefine.h"

//#define Color_BG        [UIColor colorWithHexString:@"F2F2F2"]
#define Color_BG        Color_LightGray

static const CGFloat NoneResultIMG_centerYOffset = 100;
static const CGFloat NoneResultIMG_W = 169.f/2;
static const CGFloat NoneResultIMG_H = 165.f/2;
static const CGFloat NoneResultLab_Top = 10.f;
static const CGFloat NoneResultLab_H = 50.f;
static const CGFloat NoneResultLab_FontSize = 17.f;

@interface SearchResultsView ()

@property (nonatomic, strong) UIImageView *noneResultIMGView;
@property (nonatomic, strong) UILabel *noneResultLab;

@end

@implementation SearchResultsView

#pragma mark - LifeCircle
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = Color_BG;
        
        self.noneResultIMGView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Search_ResultNone"]];
        [self addSubview:self.noneResultIMGView];
        [self.noneResultIMGView makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-(ScaleBasedOn6(NoneResultIMG_centerYOffset)));
            make.centerX.equalTo(self);
            make.width.equalTo(ScaleBasedOn6(NoneResultIMG_W));
            make.height.equalTo(ScaleBasedOn6(NoneResultIMG_H));
        }];
        
        self.noneResultLab = [[UILabel alloc] init];
        self.noneResultLab.text = @"没有找到哦，试试搜点其他的吧";
        self.noneResultLab.backgroundColor = [UIColor clearColor];
        self.noneResultLab.textColor = Color_TextLightGray;
        self.noneResultLab.textAlignment = NSTextAlignmentCenter;
        self.noneResultLab.font = [UIFont defaultFontWithSize:ScaleBasedOn6(NoneResultLab_FontSize)];
        [self addSubview:self.noneResultLab];
        [self.noneResultLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.noneResultIMGView.bottom).offset(ScaleBasedOn6(NoneResultLab_Top));
            make.leading.trailing.equalTo(self);
            make.height.equalTo(ScaleBasedOn6(NoneResultLab_H));
        }];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.alpha = 0.f;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.tableFooterView = [UIView new];
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    
    return self;
}


- (void)reloadViews {
//    NSInteger dataCount = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:0];
    NSInteger dataCount = [self.tableView.dataSource numberOfSectionsInTableView:self.tableView];
    self.noneResultIMGView.alpha = dataCount ? 0.f : 1.f;
    self.noneResultLab.alpha = dataCount ? 0.f : 1.f;
    self.tableView.alpha = dataCount ? 1.f : 0.f;
    [self.tableView reloadData];
    if (dataCount) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
        [self.tableView setScrollsToTop:YES];
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
