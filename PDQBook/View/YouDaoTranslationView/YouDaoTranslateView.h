//
//  YouDaoTranslateView.h
//  Translation
//
//  Created by Mr.Jiang on 15/12/3.
//  Copyright © 2015年 AirPPT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranslationResult.h"
#import "YouDaoTranslateProtocol.h"

@protocol YouDaoTranslateViewDelegate;

@interface YouDaoTranslateView : UIView

@property (nonatomic, weak) id <YouDaoTranslateViewDelegate> delegate;

- (void)showInView:(UIView *)parentView;

- (void)dismiss;

/**
 * 由于翻译是异步进行的，此方法是服务器返回翻译结果后，调用
 *
 * 注意： 如果未找到翻译，需构造DictTranslation，并将DictTranslation.content设置为要翻译的内容，
        那么本界面将根据DictTranslation.content，做出未找到翻译的提示
 */
- (void)setupWithTranslation:(TranslationResult *)translation;


@end


