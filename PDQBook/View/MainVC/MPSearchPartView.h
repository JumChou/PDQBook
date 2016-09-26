//
//  MPSearchPartView.h
//  PDQBook
//
//  MainVC搜索部分页面
//  Created by Mr.Chou on 16/7/14.
//  Since v1.0.0
//  Copyright (c) 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonDefine.h"

@interface MPSearchPartView : UIView

/**
 *  @author zhoujunhao, 2016-07-14 09:39:00
 *  @since  v1.0.0
 *
 *  初始化MPSearchPartView
 *
 *  @param tapHandler 点击的处理block
 *
 */
- (id)initWithTapHandler:(void(^)())tapHandler;



@end
