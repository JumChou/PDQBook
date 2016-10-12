//
//  TICopyTextView.h
//  TestYouDaoView
//
//  Created by Mr.Jiang on 15/12/11.
//  Copyright © 2015年 JasonRyan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TICopyTextView;
@protocol TICopyTextViewDelegate <NSObject>
/**
 *  点击拷贝
 *
 *  @param textView 当前textView
 *  @param text     拷贝的内容
 */
- (void)textView:(TICopyTextView *)textView didCopyWithText:(NSString *)text;

/**
 *  点击 插入至译文
 *
 *  @param textView 当前textView
 *  @param text     插入至译文的内容
 */
- (void)textView:(TICopyTextView *)textView didTapInsertWithText:(NSString *)text;

@end


@interface TICopyTextView : UITextView <UITextViewDelegate>

@property (nonatomic, weak) id <TICopyTextViewDelegate> tiDelegate;

@end
