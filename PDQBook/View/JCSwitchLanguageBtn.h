//
//  JCSwitchLanguageBtn.h
//  PDQBook
//
//  Created by Mr.Chou on 16/8/23.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SwitchLanguageBtnStatus) {
    SwitchLanguageBtnStatus_CN,
    SwitchLanguageBtnStatus_EN
};

@interface JCSwitchLanguageBtn : UIButton

@property (nonatomic, strong) UIColor *basicColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) SwitchLanguageBtnStatus languageStatus;


+ (JCSwitchLanguageBtn *)buttonWithStatus:(SwitchLanguageBtnStatus)status;

- (void)switchStatus;

@end
