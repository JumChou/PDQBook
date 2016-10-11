//
//  CommonDefine.h
//  PDQBook
//
//  Created by Mr.Chou on 16/7/8.
//  Copyright © 2016年 weihaisi. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#pragma mark - DebugLog
//------------------------------------DebugLog---------------------------------------------
#define __DEBUG_LOG_ENABLED__ 1

#if __DEBUG_LOG_ENABLED__
#define DebugLog(s, ...)    NSLog(@"*LOG* %s(%d): %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define DebugMethod()       NSLog(@"%s", __func__)
#else
#define DebugLog(s, ...)
#define DebugMethod()
#endif



#pragma mark - 系统
//------------------------------------系统---------------------------------------------
#define iOS_VERSION_FLOAT   [[[UIDevice currentDevice] systemVersion] floatValue]       // 获取系统版本
#define CURRENT_LANGUAGE    ([[NSLocale preferredLanguages] objectAtIndex:0])           // 获取当前语言
// 判断系统版本
#define iOS6_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)? (YES):(NO))
#define iOS7_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))
#define iOS8_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)? (YES):(NO))
#define iOS9_OR_LATER (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)? (YES):(NO))
// 判断设备
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Simulator TARGET_IPHONE_SIMULATOR



#pragma mark - 常规控件、计算
//-----------------------------------常规控件---------------------------------------------
#define kScreenHeight        ([UIScreen mainScreen].bounds.size.height)
#define kScreenWidth         ([UIScreen mainScreen].bounds.size.width)
#define kScreenRect          CGRectMake(0, 0, kScreenWidth, kScreenHeight)
#define kStatusBarHeight     ([[UIApplication sharedApplication] statusBarFrame].size.height)  // 状态栏高
#define kBasicViewHeight     (self.view.bounds.size.height)
#define kNavBarHeight        (44.0f)
#define kNavBarShadowHeight  (6.0f)
#define kNavBarButtonHeight  (30.0f)
#define kNavBarButtonWidth   (30.0f)
#define kTabBarHeight        (49.0f)
#define kDefaultCellHeight   (44.0f)      // 默认cell高度
#define kSearchBarHeight     (44.0f)      // 搜索栏高度

#define kScreenScaleTo6         (kScreenWidth/375.0f)       // 当前屏幕对应iPhone6比例
#define ScaleBasedOn6(float)    ((float)*kScreenScaleTo6)   // 根据iPhone6为基准计算出当前尺寸
#define RADIANS_TO_DEGREES(x)   ((x)/M_PI*180.0)            // 弧度转角度
#define DEGREES_TO_RADIANS(x)   ((x)/180.0*M_PI)            // 角度转弧度


#pragma mark - userDefaults配置信息
//-----------------------------------userDefaults配置信息---------------------------------------------
#define UD_IsAppHaveLaunched            @"IsAppHaveLaunched"    // 应用是否运行过
#define UD_IsHadAccessedPhoto           @"IsHadAccessedPhoto"   // 应用是否访问过相册
#define UD_IsWelcomeHaveShowed          @"IsWelcomeHaveShowed"  // Welcome页是否自动展示过
#define UD_LoginAccessToken             @"LoginAccessToken"     // 第三方登录accessToken
#define UD_LoginUserID                  @"LoginUserID"          // 第三方登录后获得的userID
#define UD_LoginUnionID                 @"LoginUnionID"         // 第三方登录UnionId（微信）
#define UD_DBVersion                    @"DBVersion"            // 数据库版本

#define UD_IsCreateCachesPath   @"IsCreateCachesPath"   // 是否创建了缓存文件夹
#define UD_IsUse3G              @"IsUse3G"              // 是否使用3G网络配置


#pragma mark - NSNotification通知类型
//-----------------------------------NSNotification通知类型---------------------------------------------
#define Notifi_RefreshAssetsData                @"RefreshAssetsData"        // 照片库数据刷新通知
#define Notifi_Logout                           @"Logout"                   // 登出通知
#define Notifi_ReLogin                          @"ReLogin"                  // 重新登录通知
#define Notifi_SelectedLove                     @"SelectedLove"             // 点赞通知
#define Notifi_UserInfoEdited                   @"UserInfoEdited"           // 用户信息编辑通知
#define Notifi_WorkFilesError                   @"WorkFilesError"           // 作品文件出错
#define Notifi_DidEnterBackground               @"DidEnterBackground"
#define Notifi_WillEnterForeground              @"WillEnterForeground"
#define Notifi_TabBarDidSelectIndex             @"TabBarDidSelectIndex"
#define Notifi_UpdateSubmittedFeedback          @"UpdateSubmittedFeedback"


#pragma mark - 通用其他
//-----------------------------------其他---------------------------------------------
#define SAFE_RELEASE(x) [x release];x=nil           // 安全释放
#define WeakSelf(s) __weak typeof(self) s = self    // weak self

#define Image(imageName)    [UIImage imageWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:nil]]] // 取包中图片
#define DocumentsPath       [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] // Documents文件夹路径
#define DBFilePath          [DocumentsPath stringByAppendingPathComponent:@"Data.sqlite"] // 数据库文件路径
#define MaskGuidPlistPath   [DocumentsPath stringByAppendingPathComponent:@"MaskGuid.plist"]  // 遮罩plist文件路径

#define kDBVersion      @"1.0.0"    // 数据库版本
#define RequestTimeOut  20          // 网络请求超时时间

//方正黑体简体字体定义
#define FontFZHT(sizef) [UIFont fontWithName:@"FZHTJW--GB1-0" size:sizef]


//-----------------------------------公用定义---------------------------------------------
#define RGB(r,g,b)              [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:1.0f]
#define RGBA(r,g,b,a)           [UIColor colorWithRed:(r / 255.0f) green:(g / 255.0f) blue:(b / 255.0f) alpha:(a)]

#define Color_White             [UIColor whiteColor]
#define Color_Clear             [UIColor clearColor]
#define Color_NavigationBG      [UIColor colorWithHexString:@"67819d"]
#define Color_Navy              [UIColor colorWithHexString:@"4F515F"]
//#define Color_Navy              [UIColor colorWithHexString:@"494E52"]
#define Color_TextNavy          [UIColor colorWithHexString:@"67819e"]
#define Color_Blue              [UIColor colorWithHexString:@"65C4FA"]
#define Color_LightBlue         [UIColor colorWithHexString:@"DEF3FA"]
#define Color_LightGray         [UIColor colorWithHexString:@"f9f9f9"]
#define Color_TextLightGray     [UIColor colorWithHexString:@"b2b2b2"]
#define Color_Line              [UIColor colorWithHexString:@"E2E2E2"]


#define Color_TextYellow        [UIColor colorWithHexString:@"f9c349"]     // 文字黄
#define Color_TextGreen         [UIColor colorWithHexString:@"88d016"]     // 文字绿
#define Color_TextBlue          [UIColor colorWithHexString:@"2fa8ff"]     // 文字蓝
#define Color_GrayBig           [UIColor colorWithHexString:@"6f6f6f"]     // 大号字体灰
#define Color_GrayLittle        [UIColor colorWithHexString:@"8c8d8f"]     // 小号字体灰
#define Color_EmptyPageText     [UIColor colorWithHexString:@"94b3c8"]     // 空白页文字颜色



//-----------------------------------PCH坑---------------------------------------------
#pragma mark - SysAPI
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

#pragma mark - OpenSource
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import <Masonry/Masonry.h>
#import <FMDB/FMDB.h>
#import <JSONKit-NoWarning/JSONKit.h>
#import <MJRefresh/MJRefresh.h>
//#import <AFNetworking/AFNetworking.h>
//#import "Flurry.h"


#pragma mark - Common
//#import "CommonDefine.h"
#import "JCHTTPRequest.h"
#import "DBManager.h"
#import "Singleton.h"
#import "NSObject+Custom.h"
#import "NSString+Custom.h"
#import "UIColor+Custom.h"
#import "NSDate+Custom.h"
#import "UIImage+Custom.h"
#import "UIView+Custom.h"
#import "UIAlertController+Window.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import "UCZProgressView+Initialize.h"
//#import "UIImageView+WebCache.h"




#pragma mark - 第三方平台信息
//-----------------------------------第三方平台信息---------------------------------------------
#define Youdao_APIKEY               @"9514342"
#define Youdao_KEYFROM              @"PDQBook"

#define Flurry_APPKey               @"HKKHQC3WTRHW66QQFJ3M"
#define UMeng_AppID                 @"565d087ce0f55aa1f7002cdd"

#define Share_ShareSDK_AppID        @"720a7dbc95ec"
#define Share_ShareSDK_AppSecret    @"d4b93c276a0a1b3693b72a59aa98edf5"

#define WeiXin_AppID                @"wxfc9a8fa86f2e67f9"
#define WeiXin_AppSecret            @"d4624c36b6795d1d99dcf0547af5443d"

#define SinaWeibo_AppID             @"343743196"
#define SinaWeibo_AppSecret         @"ac5fc288cd3a5065bfa5bbfc3b11a19c"

#define LoginType_Wecat                 @"weixin"
#define LoginType_SinaWeibo             @"weibo"



#pragma mark - 接口请求url
//-----------------------------------接口请求url--------------------------------------------
// 正式服
#define URL_Host                    @"http://ps.wehealth.mobi/API/NCC"
// 测试服
#define URL_TestHost                @""
// 获得完整URL
#define Get_Full_URL(PartURL)       [NSString stringWithFormat:@"%@%@", URL_Host, PartURL]

// 癌症列表接口 c=null&x=null&userId=null&token=null
#define URL_GetCancerList           Get_Full_URL(@"/GetCancerList")
// 搜索接口 c=null&x=null&userId=null&token=null&keyword=%E8%82%9D%E7%99%8C
#define URL_Search                  Get_Full_URL(@"/Search")

// 有道翻译
#define URL_YouDaoTranslation       @"http://fanyi.youdao.com/openapi.do?keyfrom=yichong&key=1180506413&type=data&doctype=json&version=1.1"
#define Get_YoudaoTranslationURL(text)          [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=%@&key=%@&type=data&doctype=json&version=1.1&q=%@", Youdao_KEYFROM, Youdao_APIKEY, text]

// 获得癌症页面WebURL
#define Get_CancerWebURL(CancerId, Section)     [NSString stringWithFormat:@"http://pt.wehealth.mobi/ncc/index.html#/summarylist/%@/%@", CancerId, Section]
// 获得文章页面WebURL
#define Get_PaperWebURL(CDR_id)                 [NSString stringWithFormat:@"http://pt.wehealth.mobi/ncc/index.html#/page2/%@", CDR_id]
// 获得文章段落页面WebURL
#define Get_PaperParaWebURL(CDR_id, Para_id)    [NSString stringWithFormat:@"http://pt.wehealth.mobi/ncc/index.html#/page2/%@/%@", CDR_id, Para_id]




#endif /* CommonDefine_h */
