//
//  YouDaoTranslateView.m
//  Translation
//
//  Created by Mr.Jiang on 15/12/3.
//  Copyright © 2015年 AirPPT. All rights reserved.
//

#import "YouDaoTranslateView.h"
#import "YouDaoTranslationUtils.h"
#import "AnimationDotLabel.h"
#import "TICopyTextView.h"


#define kYDTV_BackgroundColor                       [[UIColor colorWithHexString:@"4b4c4c"] colorWithAlphaComponent:0.9]
// ContentView
#define kYDTV_ContentView_MarginLeft                (20.0f * kScreenScaleTo6)
#define kYDTV_ContentView_W                         (kScreenWidth - kYDTV_ContentView_MarginLeft * 2)
#define KYDTV_ContentView_CornerRadius              (3.0f)
#define kYDTV_TranslateResult_ShowAnimationDuration (0.8f)
// LoadingView
#define kYDTV_LoadingLab_AnimationShowDuration      (0.5f)
#define kYDTV_LoadingLab_H                          (30.f * kScreenScaleTo6)
#define kYDTV_LoadingLab_W                          (90.0f * kScreenScaleTo6)
// 原文
#define kYDTV_QueryTextView_MarginTop                  (10.0f * kScreenScaleTo6)
#define kYDTV_QueryTextView_MarginLeft                 (5.0f * kScreenScaleTo6)
// 基础释义
#define kYDTV_BasicTransView_MarginLeft             (10.0f * kScreenScaleTo6)
#define kYDTV_BasicTransView_MarginTop              (5.0f * kScreenScaleTo6)
#define kYDTV_BasicTransView_TitleLab_MarginLeft    (16.0f * kScreenScaleTo6)
#define kYDTV_BasicTransView_TitleLab_W             (180.0f * kScreenScaleTo6)
#define kYDTV_BasicTransView_TitleLab_H             (20.0f * kScreenScaleTo6)
#define kYDTV_BasicTransView_TitleLab_Font          [UIFont defaultFontWithSize:18.0f]
#define kYDTV_BasicTransView_TitleIcon_W            (10.5f * kScreenScaleTo6)
#define kYDTV_BasicTransView_TitleIcon_H            (10.0f * kScreenScaleTo6)
#define kYDTV_BasicTransView_DetailTextView_MarginTop    (0.0f * kScreenScaleTo6)
// 网络释义
#define kYDTV_WebTransView_MarginLeft               (5.0f * kScreenScaleTo6)
#define kYDTV_WebTransView_MarginTop                (5.0f * kScreenScaleTo6)
#define kYDTV_WebTransView_TitleLab_MarginLeft      (16.0f * kScreenScaleTo6)
#define kYDTV_WebTransView_TitleLab_W               (180.0f * kScreenScaleTo6)
#define kYDTV_WebTransView_TitleLab_H               (20.0f * kScreenScaleTo6)
#define kYDTV_WebTransView_TitleLab_Font            [UIFont defaultFontWithSize:18.0f]
#define kYDTV_WebTransView_TitleIcon_W              (10.5f * kScreenScaleTo6)
#define kYDTV_WebTransView_TitleIcon_H              (10.0f * kScreenScaleTo6)
#define kYDTV_WebTransView_DetailLab_MarginTop      (0.0f * kScreenScaleTo6)
// 无翻译
#define kYDTV_NotFoundLab_Font                      [UIFont defaultFontWithSize:16.0f]



@interface YouDaoTranslateView() <TICopyTextViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundView;

/// 正在查询...
@property (nonatomic, strong) AnimationDotLabel *loadingLabel;
/// 查询的内容
@property (nonatomic, strong) TICopyTextView *queryTextView;
/// 有道词典-基本词典翻译
@property (nonatomic, strong) UIView *basicTransView;
/// 有道词典-网络释义
@property (nonatomic, strong) UIView *webTransView;
@end

@implementation YouDaoTranslateView
{
    UIView *contentView;
}

- (void)showInView:(UIView *)parentView {
    WeakSelf(ws);
    for (UIView *view in parentView.subviews) {
        if ([view isKindOfClass:[self class]]) {
            [view.layer removeAllAnimations];
            [view removeFromSuperview];
        }
    }
    [parentView addSubview:self];
    self.center = parentView.center;
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.superview).offset(UIEdgeInsetsZero);
    }];
    [self createInitView];
}

- (void)createInitView {
    WeakSelf(ws);
    
    UIView *tapForDismissView = [UIView new];
    [self addSubview:tapForDismissView];
    [tapForDismissView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws).offset(UIEdgeInsetsZero);
    }];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [tapForDismissView addGestureRecognizer:tapGR];
    
    contentView = [UIView new];
    contentView.backgroundColor = kYDTV_BackgroundColor;
    contentView.layer.cornerRadius = KYDTV_ContentView_CornerRadius;
    contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    contentView.layer.shadowOpacity = 0.5f;
    contentView.layer.shadowOffset = CGSizeMake(1.0f, -1.0f);
    [self addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.width.equalTo(kYDTV_ContentView_W);
        make.height.equalTo(kYDTV_LoadingLab_H);
    }];
    
    self.loadingLabel = [AnimationDotLabel new];
    _loadingLabel.text = @"正在查询";
    _loadingLabel.textColor = kYDTU_TextColor_Title;
    _loadingLabel.animated = YES;
    [contentView addSubview:_loadingLabel];
    _loadingLabel.frame = CGRectMake((kYDTV_ContentView_W - kYDTV_LoadingLab_W)/2, 0, kYDTV_LoadingLab_W, kYDTV_LoadingLab_H);
    _loadingLabel.textAlignment = NSTextAlignmentLeft;
    contentView.alpha = 0.0f;
    [UIView animateWithDuration:kYDTV_LoadingLab_AnimationShowDuration animations:^{
        contentView.alpha = 1.0f;
    }];
}


- (void)setupWithTranslation:(TranslationResult *)translation {
    WeakSelf(ws);
    [self hideLoadingLabel];
    if (translation.translateContent == nil) {
        [self showNotFoundTranslationWithDict:translation];
        return;
    }
    NSDictionary *translateContent = [translation.translateContent objectFromJSONString];
    UIView *lastView = nil;
    // 原文部分
    NSAttributedString *queryString = [YouDaoTranslationUtils parseDict:translateContent youdaoDataNodeType:YouDaoDataNodeTypeQuery];
    self.queryTextView = [TICopyTextView new];
    _queryTextView.userInteractionEnabled = YES;
    [contentView addSubview:_queryTextView];
    _queryTextView.textAlignment = NSTextAlignmentLeft;
    _queryTextView.attributedText = queryString;
    _queryTextView.backgroundColor = [UIColor clearColor];
    _queryTextView.editable = NO;
    _queryTextView.tiDelegate = self;
    _queryTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    CGSize queryLabSize = [YouDaoTranslationUtils sizeOfText:queryString.string constraintSize:CGSizeMake(kYDTV_ContentView_W, NSIntegerMax) attributes:@{NSFontAttributeName : _queryTextView.font}];
    [_queryTextView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(kYDTV_QueryTextView_MarginTop);
        make.centerX.equalTo(contentView);
        make.width.equalTo(kYDTV_ContentView_W - kYDTV_QueryTextView_MarginLeft * 2);
        make.height.equalTo(queryLabSize.height);
    }];
    //  基本释义
    self.basicTransView = [UIView new];
    [contentView addSubview:_basicTransView];
    [_basicTransView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_queryTextView.bottom).offset(kYDTV_BasicTransView_MarginTop);
        make.centerX.width.equalTo(contentView);
        make.height.equalTo(0);
    }];
    
    UILabel *basicTransTitleLab = [UILabel new];
    [_basicTransView addSubview:basicTransTitleLab];
    basicTransTitleLab.textColor = [UIColor whiteColor];
    basicTransTitleLab.text = @"基本释义";
    basicTransTitleLab.font = kYDTV_BasicTransView_TitleLab_Font;
    basicTransTitleLab.textAlignment = NSTextAlignmentLeft;
    [basicTransTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_basicTransView);
        make.leading.equalTo(_basicTransView).offset(kYDTV_BasicTransView_TitleLab_MarginLeft);
        make.width.equalTo(kYDTV_BasicTransView_TitleLab_W);
        make.height.equalTo(kYDTV_BasicTransView_TitleLab_H);
    }];
    
    UIImageView *basicTransIcon = [UIImageView new];
    [_basicTransView addSubview:basicTransIcon];
    basicTransIcon.image = [UIImage imageNamed:@"YouDaoTransView_BasicIcon"];
    [basicTransIcon makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_basicTransView);
        make.centerY.equalTo(basicTransTitleLab);
        make.width.equalTo(kYDTV_BasicTransView_TitleIcon_W);
        make.height.equalTo(kYDTV_BasicTransView_TitleIcon_H);
    }];
    
    NSAttributedString *basicTransString = [YouDaoTranslationUtils parseDict:translateContent youdaoDataNodeType:YouDaoDataNodeTypeBasicTrans];
    TICopyTextView *basicTransTextView = [TICopyTextView new];
    [_basicTransView addSubview:basicTransTextView];
    basicTransTextView.textAlignment = NSTextAlignmentLeft;
    basicTransTextView.attributedText = basicTransString;
    basicTransTextView.backgroundColor = [UIColor clearColor];
    basicTransTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    basicTransTextView.editable = NO;
    basicTransTextView.tiDelegate = self;
    CGSize basicTransSize = [YouDaoTranslationUtils sizeOfText:basicTransString.string constraintSize:CGSizeMake(kYDTV_ContentView_W - kYDTV_BasicTransView_MarginLeft * 2, NSIntegerMax) attributes:@{NSFontAttributeName : basicTransTextView.font}];
    [basicTransTextView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(basicTransTitleLab.bottom).offset(kYDTV_BasicTransView_DetailTextView_MarginTop);
        make.leading.equalTo(_basicTransView);
        make.width.equalTo(kYDTV_ContentView_W - kYDTV_WebTransView_MarginLeft * 2);
        make.height.equalTo(basicTransSize.height);
    }];
    [_basicTransView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_queryTextView.bottom).offset(kYDTV_BasicTransView_MarginTop);
        make.centerX.equalTo(contentView);
        make.width.equalTo(kYDTV_ContentView_W - kYDTV_QueryTextView_MarginLeft * 2);
        make.bottom.equalTo(basicTransTextView);
    }];
    lastView = _basicTransView;
    
    //网络释义
    NSAttributedString *webTransStr = [YouDaoTranslationUtils parseDict:translateContent youdaoDataNodeType:YouDaoDataNodeTypeWebTrans];
    if (webTransStr) {
        self.webTransView = [UIView new];
        [contentView addSubview:_webTransView];
        UILabel *webTransTitleLab = [UILabel new];
        [_webTransView addSubview:webTransTitleLab];
        webTransTitleLab.textColor = [UIColor whiteColor];
        webTransTitleLab.text = @"网络释义";
        webTransTitleLab.font = kYDTV_WebTransView_TitleLab_Font;
        webTransTitleLab.textAlignment = NSTextAlignmentLeft;
        [webTransTitleLab makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_webTransView);
            make.leading.equalTo(_webTransView).offset(kYDTV_WebTransView_TitleLab_MarginLeft);
            make.width.equalTo(kYDTV_WebTransView_TitleLab_W);
            make.height.equalTo(kYDTV_WebTransView_TitleLab_H);
        }];
        
        UIImageView *webTransIcon = [UIImageView new];
        [_webTransView addSubview:webTransIcon];
        webTransIcon.image = [UIImage imageNamed:@"YouDaoTransView_BasicIcon"];
        [webTransIcon makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(_webTransView);
            make.centerY.equalTo(webTransTitleLab);
            make.width.equalTo(kYDTV_WebTransView_TitleIcon_W);
            make.height.equalTo(kYDTV_WebTransView_TitleIcon_H);
        }];
        TICopyTextView *webTransTextView = [TICopyTextView new];
        [_webTransView addSubview:webTransTextView];
        webTransTextView.textAlignment = NSTextAlignmentLeft;
        webTransTextView.attributedText = webTransStr;
        webTransTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        webTransTextView.backgroundColor = [UIColor clearColor];
        webTransTextView.tiDelegate = self;
        webTransTextView.editable = NO;
        CGSize webTransSize = [YouDaoTranslationUtils sizeOfText:webTransStr.string constraintSize:CGSizeMake(kYDTV_ContentView_W - kYDTV_WebTransView_MarginLeft * 2, NSIntegerMax) attributes:@{NSFontAttributeName : webTransTextView.font}];
        [webTransTextView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(webTransTitleLab.bottom).offset(kYDTV_WebTransView_DetailLab_MarginTop);
            make.leading.equalTo(_webTransView);
            make.width.equalTo(kYDTV_ContentView_W - kYDTV_WebTransView_MarginLeft * 2);
            make.height.equalTo(webTransSize.height);
        }];
        [_webTransView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_basicTransView.bottom).offset(kYDTV_WebTransView_MarginTop);
            make.centerX.equalTo(contentView);
            make.width.equalTo(kYDTV_ContentView_W - kYDTV_WebTransView_MarginLeft * 2);
            make.bottom.equalTo(webTransTextView.bottom);
        }];
        lastView = _webTransView;
    }
    
    [contentView remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.width.equalTo(kYDTV_ContentView_W);
        make.top.equalTo(_queryTextView).offset(-kYDTV_QueryTextView_MarginTop);
        make.bottom.equalTo(lastView).offset(kYDTV_QueryTextView_MarginTop/2);
    }];
    [self addAnimationForView:contentView];
    
    #warning YoudaoViewMenu修改
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyAction:)];
//    UIMenuItem *insertItem = [[UIMenuItem alloc] initWithTitle:@"插入至译文" action:@selector(insertAction:)];
//    [UIMenuController sharedMenuController].menuItems = @[copyItem,insertItem];
    [UIMenuController sharedMenuController].menuItems = @[copyItem];
}

- (void)showNotFoundTranslationWithDict:(TranslationResult *)translation {
    WeakSelf(ws);
    [self hideLoadingLabel];
    if (contentView) {
        [contentView removeFromSuperview];
    }
    UILabel *notFoundLabel = [UILabel new];
    [ws addSubview:notFoundLabel];
    notFoundLabel.backgroundColor = [UIColor clearColor];
    notFoundLabel.numberOfLines = NSIntegerMax;
    notFoundLabel.backgroundColor = kYDTV_BackgroundColor;
    notFoundLabel.layer.cornerRadius = KYDTV_ContentView_CornerRadius;
    notFoundLabel.clipsToBounds = YES;
    notFoundLabel.textAlignment = NSTextAlignmentCenter;
    notFoundLabel.font = kYDTV_NotFoundLab_Font;
    NSMutableAttributedString *notFoundStr = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString *str1 = [[NSAttributedString alloc] initWithString:@"很遗憾，没有找到“" attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_Detail}];
    NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:translation.content attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_KeyWord}];
    NSAttributedString *str3 = [[NSAttributedString alloc] initWithString:@"”的释义" attributes:@{NSForegroundColorAttributeName : kYDTU_TextColor_Detail}];
    [notFoundStr appendAttributedString:str1];
    [notFoundStr appendAttributedString:str2];
    [notFoundStr appendAttributedString:str3];
    CGSize notFoundSize = [YouDaoTranslationUtils sizeOfText:notFoundStr.string constraintSize:CGSizeMake(kYDTV_ContentView_W, NSIntegerMax) attributes:@{NSFontAttributeName : notFoundLabel.font}];
    notFoundLabel.attributedText = notFoundStr;
    [notFoundLabel makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(ws);
        make.width.equalTo(kYDTV_ContentView_W);
        make.height.equalTo(notFoundSize.height);
    }];
    [self addAnimationForView:notFoundLabel];
}

- (void)dismiss {
    [self hideLoadingLabel];
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    if ([self.delegate respondsToSelector:@selector(youdaoTranslateViewWillDismiss)]) {
        [self.delegate youdaoTranslateViewWillDismiss];
    }
}

- (void)addAnimationForView:(UIView *)destView {
    destView.alpha = 0.0f;
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / - 1000.0f;
    destView.layer.transform = CATransform3DMakeRotation(120 * M_PI / 180.0f, 1, 0, 0);
    [UIView animateWithDuration:kYDTV_TranslateResult_ShowAnimationDuration animations:^{
        destView.alpha = 1.0f;
        destView.layer.transform = CATransform3DIdentity;
    }];
}

- (void)hideLoadingLabel {
    if (_loadingLabel) {
        [_loadingLabel invalidate];
        [_loadingLabel removeFromSuperview];
    }
}


#pragma Event
// 用于消除警告，无实际功能
- (void)copyAction:(id)sender {
    ;
}

- (void)insertAction:(id)sender {
    ;
}

#pragma mark - TICopyTextViewDelegate
- (void)textView:(TICopyTextView *)textView didCopyWithText:(NSString *)text {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
    if ([self.delegate respondsToSelector:@selector(youdaoTranslateView:didCopyWithText:)]) {
        [self.delegate youdaoTranslateView:self didCopyWithText:text];
    }
}

- (void)textView:(TICopyTextView *)textView didTapInsertWithText:(NSString *)text {
    if ([self.delegate respondsToSelector:@selector(youdaoTranslateView:didTapInsertWithText:)]) {
        [self.delegate youdaoTranslateView:self didTapInsertWithText:text];
    }
}

@end

