//
//  MPCirclePartView.h
//  PDQBook
//
//  Created by Mr.Chou on 2016/12/15.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPCirclePartView : UIView

@property (nonatomic, assign) SEL btnAction;
@property (nonatomic, weak) id btnTarget;


- (id)initWithTarget:(id)btnTarget action:(SEL)btnAction;

- (void)setUpViews;


@end
