//
//  SRDictionaryContentView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/9/2.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "SRDictionaryContentView.h"
#import "CommonDefine.h"
#import "SRBasicCell.h"
#import "DictionaryDescCell.h"

static const CGFloat BottomSpace_H = 16.f;

@interface SRDictionaryContentView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SRTitleView *titleView;

@end

@implementation SRDictionaryContentView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = Color_White;
        
        self.titleView = [[SRTitleView alloc] init];
        [self addSubview:self.titleView];
        [self.titleView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.leading.trailing.equalTo(self);
            make.height.equalTo(SRTitleView_H);
        }];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.backgroundColor = Color_Clear;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleView.bottom);
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self).offset(-0);
        }];
        
        UIView *topLine = [SRBasicCell getALine];
        [self addSubview:topLine];
        [topLine makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top);
            make.width.equalTo(self.width);
            make.height.equalTo(SRBasicCell_ALine_H);
        }];
        
        UIView *bottomLine = [SRBasicCell getALine];
        [self addSubview:bottomLine];
        [bottomLine makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bottom);
            make.width.equalTo(self.width);
            make.height.equalTo(SRBasicCell_ALine_H);
        }];
    }
    
    return self;
}


#pragma mark - Method
- (void)configureWithData:(NSArray<SearchResult *> *)dicSearchResultAry {
    self.dicSearchResultAry = dicSearchResultAry;
    if (self.dicSearchResultAry && self.dicSearchResultAry.count) {
        [self.titleView configureWithTitle:dicSearchResultAry[0].type];
        [self.tableView reloadData];
    }
}

- (void)remakeMaskLayer {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerBottomRight
                                                         cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return SRBasicCell_TitleBG_H;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    return [self getHeaderView];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [DictionaryDescCell calculateFullHeightWithData:self.dicSearchResultAry[indexPath.row]];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dicSearchResultAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellIdentifier = @"DicDescCell";
    
    DictionaryDescCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[DictionaryDescCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    [cell configureWithData:self.dicSearchResultAry[indexPath.row]];
    return cell;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
