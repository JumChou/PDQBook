//
//  NBSearchView.m
//  PDQBook
//
//  Created by Mr.Chou on 16/7/18.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import "NBSearchView.h"
#import "CommonDefine.h"

typedef void (^InputingBlock)(NSString *inputingText);
typedef void (^CloseBlock)(void);
typedef void (^SearchBlock)(NSString *searchText);

@interface NBSearchView () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchBGView;
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIButton *clearTextBtn;
@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, copy) InputingBlock inputingHandler;
@property (nonatomic, copy) CloseBlock closeHandler;
@property (nonatomic, copy) SearchBlock searchHandler;

@end

@implementation NBSearchView

const float SearchIcon_Leading = 20.f;
const float SearchIcon_W = 16.f;
const float CloseBtn_Trailing = 15.f;
const float CloseBtn_W = 40.f;
const float SearchLine_Top = 5.f;
const float SearchLine_Trailing = 18.f;
const float SearchLine_H = 0.6f;
const float SearchText_Leading = 8.f;
const float SearchText_Trailing = 2.f;
const float SearchText_H = 20.f;
const float SearchText_FontSize = 17.f;
const float SearchBG_Top = 7.f;
const float SearchBG_Bottom = 6.f;
const float SearchBG_Leading = 7.f;
const float SearchBG_Trailing = 16.f;
const float SearchBG_CornerRadius = 5.f;
const float ClearTextBtn_Trailing = SearchText_Trailing;
const float ClearTextBtn_H = 15.f;


- (id)initWithCloseHandler:(void(^)())closeHandler
           inputingHandler:(void(^)(NSString *inputingText))inputingHandler
             searchHandler:(void(^)(NSString *searchText))searchHandler {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setUpViews];
        [self.searchText becomeFirstResponder];
        self.closeHandler = closeHandler;
        self.inputingHandler = inputingHandler;
        self.searchHandler = searchHandler;
    }
    
    return self;
}


- (void)setUpViews {
    // navigationBar定高，不使用ScaleBasedOn6()
    self.searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchVC_SearchIcon"]];
    self.searchIcon.backgroundColor = [UIColor clearColor];
    [self addSubview:self.searchIcon];
    [self.searchIcon makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self).offset(SearchIcon_Leading);
        make.width.equalTo(SearchIcon_W);
        make.height.equalTo(SearchIcon_W);
    }];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeBtn setTitleColor:Color_Blue forState:UIControlStateHighlighted];
    self.closeBtn.titleLabel.font = [UIFont defaultFontWithSize:SearchText_FontSize];
    [self.closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.closeBtn];
    [self.closeBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.trailing.equalTo(self).offset(-CloseBtn_Trailing);
        make.width.equalTo(CloseBtn_W);
        make.height.equalTo(CloseBtn_W);
    }];
    
    self.lineView = [UIView new];
    self.lineView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineView];
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchIcon.bottom).offset(SearchLine_Top);
        make.leading.equalTo(self.searchIcon);
        make.trailing.equalTo(self.closeBtn.leading).offset(-SearchLine_Trailing);
        make.height.equalTo(SearchLine_H);
    }];
    
    self.searchBGView = [UIView new];
    self.searchBGView.backgroundColor = [UIColor whiteColor];
    self.searchBGView.layer.cornerRadius = SearchBG_CornerRadius;
    [self insertSubview:self.searchBGView atIndex:0];
    [self.searchBGView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.searchIcon).offset(-SearchBG_Leading);
        make.trailing.equalTo(self.closeBtn.leading).offset(-SearchBG_Trailing);
        make.top.equalTo(self.searchIcon).offset(-SearchBG_Top);
        make.bottom.equalTo(self.searchIcon).offset(SearchBG_Bottom);
    }];
    
//    self.clearTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.clearTextBtn setBackgroundImage:[UIImage imageNamed:@"Search_ClearTextBtn"] forState:UIControlStateNormal];
////    [self.clearTextBtn setBackgroundColor:[UIColor lightGrayColor]];
//    [self.clearTextBtn addTarget:self action:@selector(clearTextBtnAction) forControlEvents:UIControlEventTouchUpInside];
//    [self.searchBGView addSubview:self.clearTextBtn];
//    [self.clearTextBtn makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.searchBGView);
//        make.trailing.equalTo(self.searchBGView).offset(-ClearTextBtn_Trailing);
//        make.width.equalTo(ClearTextBtn_H);
//        make.height.equalTo(ClearTextBtn_H);
//    }];
    
    self.searchText = [[UITextField alloc] init];
    self.searchText.placeholder = @"请输入搜索内容";
    self.searchText.backgroundColor = [UIColor clearColor];
    self.searchText.textColor = [UIColor whiteColor];
    self.searchText.font = [UIFont defaultFontWithSize:SearchText_FontSize];
    self.searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchText.returnKeyType = UIReturnKeySearch;
    self.searchText.enablesReturnKeyAutomatically = YES;
    self.searchText.delegate = self;
    [self addSubview:self.searchText];
    [self.searchText makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.leading.equalTo(self.searchIcon.trailing).offset(SearchText_Leading);
//        make.trailing.equalTo(self.clearTextBtn.leading).offset(-SearchText_Trailing);
        make.trailing.equalTo(self.lineView).offset(-SearchText_Trailing);
        make.height.equalTo(SearchText_H);
    }];
    
    [self changeUIStyleWithIsInputing:YES];
}


- (void)changeUIStyleWithIsInputing:(BOOL)isInputing {
    if (isInputing) {
        self.searchBGView.alpha = 1;
        self.searchIcon.image = [UIImage imageNamed:@"Navi_SearchIcon_Black"];
        self.searchText.textColor = Color_Navy;
        self.lineView.alpha = 0;
        
    } else {
        self.searchBGView.alpha = 0;
        self.searchIcon.image = [UIImage imageNamed:@"Navi_SearchIcon_White"];
        self.searchText.textColor = [UIColor whiteColor];
        self.lineView.alpha = 1;
    }
}



#pragma mark - Method
- (void)closeBtnAction {
    DebugLog(@"");
    [self.searchText resignFirstResponder];
    self.closeHandler();
}


- (void)clearTextBtnAction {
    self.searchText.text = @"";
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [self changeUIStyleWithIsInputing:YES];
    self.inputingHandler(textField.text);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
//    [self changeUIStyleWithIsInputing:NO];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchText resignFirstResponder];
    self.searchHandler(textField.text);
    return NO;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
