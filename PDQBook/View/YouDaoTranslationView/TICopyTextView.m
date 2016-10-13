//
//  TICopyTextView.m
//  TestYouDaoView
//
//  Created by Mr.Jiang on 15/12/11.
//  Copyright © 2015年 JasonRyan. All rights reserved.
//

#import "TICopyTextView.h"

@implementation TICopyTextView

- (id)init {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

/* 选中文字后是否能够呼出菜单 */
- (BOOL)canBecameFirstResponder {
    return YES;
}

/* 选中文字后的菜单响应的选项 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    #warning YoudaoViewMenu修改
//    if (action == @selector(copyAction:) ||
//        action == @selector(insertAction:)) {
//        return YES;
//    }
    if (action == @selector(copyAction:)) {
        return YES;
    }
    return NO;
}

- (void)copyAction:(id)sender {
    if ([self.tiDelegate respondsToSelector:@selector(textView:didCopyWithText:)]) {
        NSString *selectText = [self.attributedText.string substringWithRange:self.selectedRange];
        [self.tiDelegate textView:self didCopyWithText:selectText];
        self.selectedRange = NSMakeRange(0, 0);
    }
}

- (void)insertAction:(id)sender {
    if ([self.tiDelegate respondsToSelector:@selector(textView:didTapInsertWithText:)]) {
        NSString *selectText = [self.attributedText.string substringWithRange:self.selectedRange];
        [self.tiDelegate textView:self didTapInsertWithText:selectText];
        self.selectedRange = NSMakeRange(0, 0);
    }
}

@end
