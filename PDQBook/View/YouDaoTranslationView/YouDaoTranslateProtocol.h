//
//  YouDaoTranslateProtocol.h
//  Translation
//
//  Created by 蒋兵兵 on 16/3/24.
//  Copyright © 2016年 AirPPT. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YouDaoTranslateView;
@protocol YouDaoTranslateViewDelegate <NSObject>

@optional
- (void)youdaoTranslateViewWillDismiss;

/**
 *  点击 插入至译文
 *  @param text  带插入至译文的内容
 */
- (void)youdaoTranslateView:(YouDaoTranslateView *)translateView didTapInsertWithText:(NSString *)text;

/**
 * 点击 拷贝
 * @param text 拷贝的内容
 */
- (void)youdaoTranslateView:(YouDaoTranslateView *)translateView didCopyWithText:(NSString *)text;

@end
