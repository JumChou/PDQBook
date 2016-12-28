//
//  Singleton.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/10.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Singleton : NSObject

/// 是否请求了癌症列表
@property (nonatomic, assign) BOOL isHTTPRequestedCancers;
/// 是否正在显示搜索页面
@property (nonatomic, assign) BOOL isShowingSearchVC;

+ (Singleton *)shareInstance;

@end
