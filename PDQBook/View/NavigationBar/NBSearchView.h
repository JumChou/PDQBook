//
//  NBSearchView.h
//  PDQBook
//
//  Created by Mr.Chou on 16/7/18.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NBSearchView : UIView

@property (nonatomic, strong) UITextField *searchText;

- (id)initWithCloseHandler:(void(^)())closeHandler
           inputingHandler:(void(^)(NSString *inputingText))inputingHandler
             searchHandler:(void(^)(NSString *searchText))searchHandler;

@end
