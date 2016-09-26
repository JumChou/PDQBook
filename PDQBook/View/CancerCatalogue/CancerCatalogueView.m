//
//  CancerCatalogueView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/9/20.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "CancerCatalogueView.h"
#import "CommonDefine.h"

@implementation CancerCatalogueView

#pragma mark - LifeCircle
- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = Color_LightGray;
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.alpha = 0.f;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        [self.tableView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsZero);
        }];
    }
    
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
