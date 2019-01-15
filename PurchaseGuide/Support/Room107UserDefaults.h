//
//  Room107UserDefaults.h
//  room107
//
//  Created by ningxia on 15/7/23.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSA.h"

typedef NS_ENUM(NSUInteger, AuthenticateStep) {
    AuthenticateStepOneEmail = 1 << 0,
    AuthenticateStepTwoEmail = 1 << 1,
    AuthenticateStepOneCredentials = 1 << 2,
    AuthenticateStepTwoCredentials = 1 << 3,
};

//用户登录态
static NSString * const KEY_BASEURL = @"com.107room.app.baseURL";
static NSString * const KEY_AUTHENTICATIONINFO = @"com.107room.app.authentication";
static NSString * const KEY_USERNAME = @"com.107room.app.username";
static NSString * const KEY_TELEPHONE = @"com.107room.app.telephone";
static NSString * const KEY_TOKEN = @"com.107room.app.token";
static NSString * const KEY_ENCRYPTTOKEN = @"com.107room.app.encrypttoken";
static NSString * const KEY_EXPIRES = @"com.107room.app.expires";
static NSInteger periodOfExpires = 7 * 24 * 60 * 60;
static NSString * const KEY_UUIDString = @"com.107room.app.uuid";

static NSString *SubscribeCurrentSearchTipsKey = @"SubscribeCurrentSearchTipsKey"; //订阅当前搜索提示
static NSString *SubscribeTimestampKey = @"SubscribeTimestampKey"; //上一次获取订阅房源时的时间戳，毫秒数
static NSString *SubscribeNewHomesCountKey = @"SubscribeNewHomesCountKey"; //上一次获取的新房推送数目

static NSString *AuthenticateEmailKey = @"AuthenticateEmailKey"; //邮箱认证时填写的Email
static NSString *AuthenticateTypeKey = @"AuthenticateTypeKey"; //认证类型
static NSString *AuthenticateEmailStepKey = @"AuthenticateEmailStepKey"; //邮箱认证步骤
static NSString *AuthenticateCredentialsStepKey = @"AuthenticateCredentialsStepKey"; //证件认证步骤
static NSString *IDCardImageURLKey = @"IDCardImageURLKey"; //证件认证时上传的身份证URL
static NSString *WorkCardImageURLKey = @"WorkCardImageURLKey"; //证件认证时上传的工作证件URL

@interface Room107UserDefaults : NSObject

+ (void)saveUserDefaultsWithKey:(NSString *)key andValue:(id)value;
+ (id)getValueFromUserDefaultsWithKey:(NSString *)key;
+ (void)clearUserDefaults;
+ (NSString *)getPublicKeyString;
+ (BOOL)isLogin;
+ (BOOL)isAuthenticated;
+ (BOOL)hasAvatar;
+ (NSString *)encryptToken;
+ (NSString *)username;
+ (NSString *)telephone;
+ (NSString *)UUIDString;
+ (void)saveSubscribeTimestamp:(id)timestamp; //保存当前用户的订阅时间戳
+ (id)subscribeTimestamp; //获取当前用户的订阅时间戳
+ (void)saveSubscribeNewHomesCount:(id)count; //保存当前用户的新房推送数目
+ (id)subscribeNewHomesCount; //获取当前用户的新房推送数目

@end
