//
//  AppClient.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "AppClient.h"
#import "OAuth2Token.h"
#import "KeychainTokenStore.h"
#import "MobileAPI.h"

static void * kIsDeviceTokenContext = &kIsDeviceTokenContext;
static NSString * const kDeviceTokenBindingInfoKey = @"com.devicetoken.bind";

@interface AppClient ()

@property (nonatomic, strong) Client *client;

@end

@implementation AppClient

+ (AppClient *)sharedInstance {
    static AppClient *sharedInstance = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ClientTempAuthenticationStateDidChange:) name:@"ClientTempAuthenticationStateDidChange" object:nil];
        [self addObserver:self forKeyPath:@"deviceToken" options:NSKeyValueObservingOptionNew context:kIsDeviceTokenContext];
        
        _displayVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *) kCFBundleVersionKey];
        
        self.client = [Client sharedClient];
        [self.client setupWithAPIKey:ConfigAPIKey secret:ConfigAPISecret];
        [self initDeviceIfNeeded];
        //[self checkUpdate];
    }
    return self;
}

- (BOOL)isLogin {
//    return self.client.isAuthenticated && (self.client.oauthToken.userID != 0);
    return [Room107UserDefaults isLogin];
}

- (BOOL)isAuthenticated {
    return [Room107UserDefaults isAuthenticated];
}

- (BOOL)hasAvatar {
    return [Room107UserDefaults hasAvatar];
}

- (NSString *)username {
    return [Room107UserDefaults username];
}

- (NSString *)telephone {
    return [Room107UserDefaults telephone];
}

- (NSString *)encryptToken {
    return [Room107UserDefaults encryptToken];
}

- (NSInteger)userID {
    return self.client.oauthToken.userID;
}

- (void)cleanKeychain {
//    [Room107Keychain delete:KEY_AUTHENTICATIONINFO];
}

- (void)changeBaseDomain:(NSString *)domain {
    [[Client sharedClient].HTTPClient changeBaseDomain:domain];
}

- (NSString *)baseDomain {
    return [[Client sharedClient].HTTPClient baseDomain];
}

- (NSString *)UUIDString {
    return [Room107UserDefaults UUIDString];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"deviceToken" context:kIsDeviceTokenContext];
}


#pragma mark -

- (void)automaticallyStoreTokenInKeychainForCurrentApp {
    NSString *name = [[NSBundle mainBundle] objectForInfoDictionaryKey:(__bridge id)kCFBundleIdentifierKey];
    self.client.tokenStore = [[KeychainTokenStore alloc] initWithService:name];
    [self.client restoreTokenIfNeeded];
}

- (void)logout {
    [self unbindDevice:self.client];
    self.client.oauthToken = nil;
}

#pragma mark -

- (void)checkUpdate {
    if ([self.client isAuthenticated]) {
        [self checkUpdateWithClient:self.client];
    } else {
        WEAK_SELF weakSelf = self;
        [self.client authenticateAsClientCredentialsTokenWithCompletion:^(Response *response, NSError *error) {
            STRONG(weakSelf) strongSelf = weakSelf;
            if (error) {
                
            } else {
                [strongSelf checkUpdateWithClient:strongSelf.client];
            }
        }];
    }
}

- (void)checkUpdateWithClient:(Client *)client {
    WEAK_SELF weakSelf = self;
    Request * request = [MobileAPI requestForUpdateWituildVersion:self.buildVersion];
    [client performRequest:request completion:^(Response *response, NSError *error) {
        STRONG(weakSelf) strongSelf = weakSelf;
        if (error) {
            LogError(@"failed to check update, %@", error);
        } else {
            LogDebug(@"response for check update:%@", response.body);
            NSString *updateVersion = response.body[@"version"];
            if ([updateVersion compare:strongSelf.buildVersion options:NSNumericSearch] == NSOrderedDescending) {
                LogDebug(@"发现新版本");
                NSString *updateMajorVersion = [[updateVersion componentsSeparatedByString:@"."] firstObject];
                NSString *localMajorVersion = [[strongSelf.buildVersion componentsSeparatedByString:@"."] firstObject];
                strongSelf.updateVerionInfo = @{
                                                @"version" : updateVersion,
                                                @"url" : response.body[@"url"],
                                                @"require" : @([updateMajorVersion integerValue] > [localMajorVersion integerValue])
                                                };
                [[NSNotificationCenter defaultCenter] postNotificationName:ClientNewVersionDidFindNotification object:strongSelf.updateVerionInfo];
            }
        }
    }];
}

#pragma mark -

- (void)initDeviceIfNeeded {
    BOOL hasInit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"com.107room.mobile.init"] boolValue];
    if (!hasInit) {
        if (self.client.isAuthenticated) {
            Request *request = [MobileAPI requestForMobileInit];
            [[Client sharedClient] performRequest:request completion:^(Response *response, NSError *error) {
                if (error) {
                    LogError(@"failed to init mobile, %@", error);
                } else {
                    [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"com.107room.mobile.init"];
                }
            }];
        } else {
            [self.client authenticateAsClientCredentialsTokenWithCompletion:^(Response *response, NSError *error) {
                if (error) {
                    
                } else {
                    Request *request = [MobileAPI requestForMobileInit];
                    [[Client sharedClient] performRequest:request completion:^(Response *response, NSError *error) {
                        if (error) {
                            LogError(@"failed to init mobile, %@", error);
                        } else {
                            [[NSUserDefaults standardUserDefaults] setValue:@(YES) forKey:@"com.107room.mobile.init"];
                        }
                    }];
                }
            }];
        }
    }
}

#pragma mark - Bind & Unbind Device token

- (void)updateDeviceTokenBindIfNeeded {
    if (self.isLogin) {
        [self bindDevice:self.client];
    }
}

- (void)bindDevice:(Client *)client {
    if ([self.deviceToken length] == 0) {
        return;
    }
    NSDictionary *bindingInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenBindingInfoKey];
    if ([self.deviceToken isEqualToString:bindingInfo[@"deviceToken"]] && ([self userID] == [bindingInfo[@"userID"] integerValue]) && [self.client.oauthToken.accessToken isEqualToString:bindingInfo[@"accessToken"]]) {
        LogDebug(@"设备已绑定 userID = %@, devicetoken = %@", bindingInfo[@"userID"], bindingInfo[@"deviceToken"]);
    } else {
        /*
         if (bindingInfo && [self userID] != [bindingInfo[@"userID"] integerValue]) {
         LogDebug(@"正在解除设备绑定..., userID = %@, deviceToken = %@", bindingInfo[@"userID"], bindingInfo[@"deviceToken"]);
         }
         */
        LogDebug(@"正在绑定设备..., userID = %ld, devicetoken = %@, ", [self userID], self.deviceToken);
        WEAK_SELF weakSelf = self;
        Request *request = [MobileAPI requestForMobileBindWithToken:self.deviceToken version:self.buildVersion];
        [client performRequest:request completion:^(Response *response, NSError *error) {
            STRONG(weakSelf) strongSelf = weakSelf;
            if (error) {
                LogError(@"设备绑定失败！ %@", error);
            } else {
                LogDebug(@"成功绑定设备！");
                [[NSUserDefaults standardUserDefaults] setObject:@{@"userID":@([strongSelf userID]), @"deviceToken" : strongSelf.deviceToken, @"accessToken" : client.oauthToken.accessToken} forKey:kDeviceTokenBindingInfoKey];
            }
        }];
    }
}

- (void)unbindDevice:(Client *)client {
    NSDictionary *bindingInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenBindingInfoKey];
    if (bindingInfo != nil) {
        LogDebug(@"正在解除设备绑定..., userID = %@, deviceToken = %@", bindingInfo[@"userID"], bindingInfo[@"deviceToken"]);
        Request *request = [MobileAPI requestForMobileUnBind];
        [client performRequest:request completion:^(Response *response, NSError *error) {
            if (error) {
                LogError(@"解除设备绑定失败！ %@", error);
            } else {
                LogDebug(@"成功解除设备绑定！");
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kDeviceTokenBindingInfoKey];
        }];
    }
}

#pragma mark -

- (void)ClientTempAuthenticationStateDidChange:(NSNotification *)notification {
    if (self.client.isAuthenticated) {
        if ([self userID] != 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ClientAuthenticationStateDidChangeNotification object:self.client];
            [self updateDeviceTokenBindIfNeeded];
        }
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:ClientAuthenticationStateDidChangeNotification object:self.client];
        [[NSFileManager defaultManager] removeItemAtPath:[AppConfig requestEtagsCachePath] error:nil];
        [[Client sharedClient].HTTPClient resetRequestETags];
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kIsDeviceTokenContext) {
        [self updateDeviceTokenBindIfNeeded];
    }
}

@end
