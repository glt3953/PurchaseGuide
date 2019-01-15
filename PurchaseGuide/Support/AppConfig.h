//
//  AppConfig.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppConfig : NSObject

+ (NSString *)requestEtagsCachePath;

@end

extern NSString * const ConfigAPIKey;     //接口OAuth Key
extern NSString * const ConfigAPISecret;  //接口OAuth Secret

extern NSString * const UMengKey;

extern NSString * const ItemViewTemplatePath;
extern NSString * const ItemEditTemplatePath;
extern NSString * const NotificationTemplatePath;

extern NSString * const AuthenticationPath;

/*
 ----------------------------------------------------------------
 -   正式环境为@""、公司内部环境为@""、dev上环境为@""      -
 ----------------------------------------------------------------
 */
#define ConfigVersionDomain @""


#define ConfigHostCookieServer @"dev_server="  // 正式环境:dev_server=production
#define ConfigHostCookieDev @"dev_host="  // 用cookie切换调试服务器，开发环境:dev_host=dev05

#define ConfigAPIVersion @"v1"    // 接口版本号

#define ConfigBaseDomain @"http://107room.com"  // 基础域：http://107room.com，线上101域：http://101.200.204.65，15域：http://192.168.88.15:8081

#define BugtagsAppKey @"c255eaaef79122d4ef83e6b81d33126d"    // BugtagsAppKey
#define BuglyAppID @"900023102"    // BuglyAppID

#define WechatAppID @"wxd702c268718890bf"    // WechatAppID

#define BaiduMapKey @"NcsbSEvs2KvKXyruqDwLot5G"     // BaiduMapKey

#define TencentOAuthAppID @"1104899036"    // TencentOAuthAppID, Dev:222222（使用该AppID会导致从QQ返回时跳转至其他应用）, Product:1104899036

#define UMENG_APPKEY @"56552316e0f55a4564001f62"   //友盟appKey

static NSString * const kAuthenticationPath = @"http://oauth.alpha.107room.com/token";

// 平台基础域  @"alpha.107room.com"
#define ConfigServerDomain [NSString stringWithFormat:@"%@%@", ConfigVersionDomain, ConfigBaseDomain]
// IM 连接域 @"socket.alpha.107room.com"
#define ConfigBaseIMConnection [NSString stringWithFormat:@"socket.%@",ConfigServerDomain]
// Cookie域
#define ConfigCookieDomain [NSString stringWithFormat:@".%@", ConfigServerDomain]

// 打包版本号
#define ConfigBuildCode [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *) kCFBundleVersionKey]

// 用户可见版本号
#define ConfigVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define ConfigIntroductoryVersion @"IntroductoryVersion3"

#define KitUserAgent [NSString stringWithFormat:@"Room107 App / %@", ConfigVersion]

#if TARGET_OS_IPHONE
#define TImage  UIImage
#else
#define TImage  NSImage
#endif
