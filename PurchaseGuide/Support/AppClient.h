//
//  AppClient.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * @class AppClient
 *
 * @brief
 *
 * 1. 设备初始化
 * 2. 账号绑定
 * 3. 升级检查
 */
@interface AppClient : NSObject

+ (AppClient *)sharedInstance;

@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic, assign, readonly) BOOL isLogin;
@property (nonatomic, assign, readonly) NSInteger userID;

@property (nonatomic, strong, readonly) NSString *displayVersion;
@property (nonatomic, strong, readonly) NSString *buildVersion;
@property (nonatomic, strong) NSDictionary *updateVerionInfo;

- (void)automaticallyStoreTokenInKeychainForCurrentApp;

- (void)logout;

- (void)checkUpdate;

- (BOOL)isLogin;

- (BOOL)isAuthenticated;

//当前用户已上传头像
- (BOOL)hasAvatar;

- (NSString *)username;

- (NSString *)telephone;

- (NSString *)encryptToken;

- (void)cleanKeychain;

- (void)changeBaseDomain:(NSString *)domain;

- (NSString *)baseDomain;

- (NSString *)UUIDString;

@end