//
//  Client.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "Client.h"
#import "AuthenticationAPI.h"
#import "NSMutableURLRequest+Headers.h"
#import "TokenStore.h"
#import "NSObject+KVO.h"

static void * kIsAuthenticatedContext = &kIsAuthenticatedContext;
static NSUInteger const kTokenExpirationLimit = 10 * 60; // 10 minutes
static NSString * const kClientDeviceIDKey = @"deviceId";
static NSString * const kClientPlatformKey = @"platform";
static NSString * const kClientUsernameKey = @"username";
static NSString * const kClientTokenKey = @"token";
static NSString * const kClientChannelKey = @"channel";
static NSString * const kClientVersionKey = @"version";
static NSString * const kClientSystemKey = @"system";
static NSString * const kClientDeviceKey = @"device";

typedef NS_ENUM(NSUInteger, ClientAuthRequestPolicy) {
    ClientAuthRequestPolicyCancelPrevious = 0,
    ClientAuthRequestPolicyIgnore,
};

@interface Client ()

@property (nonatomic, copy, readwrite) NSString *apiKey;
@property (nonatomic, copy, readwrite) NSString *apiSecret;
@property (nonatomic, weak, readwrite) NSURLSessionTask *authenticationOperation;
@property (nonatomic, strong, readwrite) Request *savedAuthenticationRequest;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *pendingOperations;

@end

@implementation Client

@synthesize pendingOperations = _pendingOperations;

+ (instancetype)sharedClient {
    static Client *sharedClient;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedClient = [self new];
    });
    
    return sharedClient;
}

- (id)init {
    HTTPClient *httpClient = [HTTPClient new];
    Client *client = [self initWithHTTPClient:httpClient];
    return client;
}

- (instancetype)initWithHTTPClient:(HTTPClient *)client {
    @synchronized(self) {
        self = [super init];
        if (!self) return nil;
        
        _HTTPClient = client;
        
        [self updateAuthorizationHeader:self.isAuthenticated];
        //暂时取消Cookie设置
//        [self.HTTPClient setCookieValue:@"dev" forName:@"dev_host"];
        [self addObserver:self forKeyPath:NSStringFromSelector(@selector(isAuthenticated)) options:NSKeyValueObservingOptionNew context:kIsAuthenticatedContext];
        
        return self;
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(isAuthenticated)) context:kIsAuthenticatedContext];
}

#pragma mark - Properties

- (BOOL)isAuthenticated {
    return self.oauthToken != nil;
}

- (void)setOauthToken:(OAuth2Token *)oauthToken {
    if (oauthToken == _oauthToken) return;
    
    NSString *isAuthenticatedKey = NSStringFromSelector(@selector(isAuthenticated));
    [self willChangeValueForKey:isAuthenticatedKey];
    
    _oauthToken = oauthToken;
    
    [self didChangeValueForKey:isAuthenticatedKey];
}

- (NSMutableOrderedSet *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[NSMutableOrderedSet alloc] init];
    }
    
    return _pendingOperations;
}

#pragma mark - Configuration

- (void)setupWithAPIKey:(NSString *)key secret:(NSString *)secret {
    self.apiKey = key;
    self.apiSecret = secret;
    
    [self updateAuthorizationHeader:self.isAuthenticated];
}

#pragma mark - Authentication

- (NSURLSessionTask *)authenticateAsClientCredentialsTokenWithCompletion:(RequestCompletionBlock)completion {
    Request * request = [AuthenticationAPI requestToClientCredentialsToken];
    return [self authenticateWithRequest:request requestPolicy:ClientAuthRequestPolicyCancelPrevious completion:completion];
}

- (NSURLSessionTask *)authenticateAsUserWithEmail:(NSString *)email password:(NSString *)password completion:(RequestCompletionBlock)completion {
    NSParameterAssert(email);
    NSParameterAssert(password);
    
    Request *request = [AuthenticationAPI requestForAuthenticationWithEmail:email password:password];
    return [self authenticateWithRequest:request requestPolicy:ClientAuthRequestPolicyCancelPrevious completion:completion];
}

- (NSURLSessionTask *)authenticateAsAppWithID:(NSUInteger)appID token:(NSString *)appToken completion:(RequestCompletionBlock)completion {
    NSParameterAssert(appID);
    NSParameterAssert(appToken);
    
    Request *request = [AuthenticationAPI requestForAuthenticationWithAppID:appID token:appToken];
    return [self authenticateWithRequest:request requestPolicy:ClientAuthRequestPolicyCancelPrevious completion:completion];
}

- (void)authenticateAutomaticallyAsAppWithID:(NSUInteger)appID token:(NSString *)appToken {
    NSParameterAssert(appID);
    NSParameterAssert(appToken);
    
    self.savedAuthenticationRequest = [AuthenticationAPI requestForAuthenticationWithAppID:appID token:appToken];
}

- (NSURLSessionTask *)authenticateWithRequest:(Request *)request requestPolicy:(ClientAuthRequestPolicy)requestPolicy completion:(RequestCompletionBlock)completion {
    if (requestPolicy == ClientAuthRequestPolicyIgnore) {
        if (self.authenticationOperation) {
            // Ignore this new authentation request, let the old one finish
            return nil;
        }
    } else if (requestPolicy == ClientAuthRequestPolicyCancelPrevious) {
        // Cancel any pending authentication task
        [self.authenticationOperation cancel];
    }
    
    WEAK_SELF weakSelf = self;
    
    // Always use basic authentication for authentication requests
    request.URLRequestConfigurationBlock = ^NSURLRequest *(NSURLRequest *urlRequest) {
        STRONG(weakSelf) strongSelf = weakSelf;
        
        NSMutableURLRequest *mutURLRequest = [urlRequest mutableCopy];
        [mutURLRequest setAuthorizationHeaderWithUsername:strongSelf.apiKey password:strongSelf.apiSecret];
        
        return [mutURLRequest copy];
    };
    
    self.authenticationOperation = [self performOperationkWithRequest:request completion:^(Response *response, NSError *error) {
        STRONG(weakSelf) strongSelf = weakSelf;
        
        OAuth2Token *token = nil;
        if (!error) {
            token = [[OAuth2Token alloc] initWithDictionary:response.body];
        }
        
        if (response.statusCode > 0) {
            strongSelf.oauthToken = token;
        }
        
        if (completion) {
            completion(response, error);
        }
        
        strongSelf.authenticationOperation = nil;
    }];
    
    return self.authenticationOperation;
}

- (NSURLSessionTask *)authenticateWithSavedRequest:(Request *)request {
    return [self authenticateWithRequest:request requestPolicy:ClientAuthRequestPolicyIgnore completion:^(Response *response, NSError *error) {
        if (!error) {
            [self processPendingOperations];
        } else {
            [self clearPendingOperations];
        }
    }];
}

#pragma mark - Requests

- (NSURLSessionTask *)GETRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RequestCompletionBlock)completion {
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:[self baseParameters]];
    NSArray *keys = [parameters allKeys];
    if (keys.count > 0) {
        for (NSUInteger i = 0; i < keys.count; i++) {
            [body setObject:[parameters objectForKey:[keys objectAtIndex:i]] forKey:[keys objectAtIndex:i]];
        }
    }
    Request *request = [Request GETRequestWithPath:path parameters:[body copy]];
    return [self performOperationkWithRequest:request completion:completion];
}

- (NSURLSessionTask *)POSTRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RequestCompletionBlock)completion {
    // 每个POST请求都得有deviceId，platform参数
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:[self baseParameters]];
    NSArray *keys = [parameters allKeys];
    if (keys.count > 0) {
        for (NSUInteger i = 0; i < keys.count; i++) {
            [body setObject:[parameters objectForKey:[keys objectAtIndex:i]] forKey:[keys objectAtIndex:i]];
        }
    }

    Request *request = [Request POSTRequestWithPath:path parameters:[body copy]];
    return [self performOperationkWithRequest:request completion:completion];
}

- (NSMutableDictionary *)baseParameters {
    // 每个POST请求都得有deviceId，platform参数
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    UIDevice *device = [UIDevice currentDevice];
    //渠道统计
    param[kClientChannelKey] = @27;
    NSString *displayVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    param[kClientVersionKey] = displayVersion;
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    param[kClientSystemKey] = [systemName stringByAppendingFormat:@" %@", systemVersion];
    param[kClientDeviceKey] = [CommonFuncs getCurrentDeviceModel];
    param[kClientDeviceIDKey] = [Room107UserDefaults UUIDString] ? [Room107UserDefaults UUIDString] : device.identifierForVendor.UUIDString;
    param[kClientPlatformKey] = platformKey;
    if ([[AppClient sharedInstance] isLogin]) {
        //telephone，token：登录后的用户必填
        param[kClientUsernameKey] = [[AppClient sharedInstance] telephone] ? [[AppClient sharedInstance] telephone] : [[AppClient sharedInstance] username];
        param[kClientTokenKey] = [[AppClient sharedInstance] encryptToken];
    }
    
    return param;
}

- (NSURLSessionTask *)PUTRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RequestCompletionBlock)completion {
    Request *request = [Request PUTRequestWithPath:path parameters:parameters];
    return [self performOperationkWithRequest:request completion:completion];
}

- (NSURLSessionTask *)DELETERequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(RequestCompletionBlock)completion {
    Request *request = [Request DELETERequestWithPath:path parameters:parameters];
    return [self performOperationkWithRequest:request completion:completion];
}

- (NSURLSessionTask *)GETRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters completion:(RequestCompletionBlock)completion {
    Request *request = [Request GETRequestWithURL:url parameters:parameters];
    return [self performOperationkWithRequest:request completion:completion];
}

- (NSURLSessionTask *)POSTRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters completion:(RequestCompletionBlock)completion {
    // 每个POST请求都得有deviceId，platform参数
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:[self baseParameters]];
    NSArray *keys = [parameters allKeys];
    if (keys.count > 0) {
        for (NSUInteger i = 0; i < keys.count; i++) {
            [body setObject:[parameters objectForKey:[keys objectAtIndex:i]] forKey:[keys objectAtIndex:i]];
        }
    }
    
    Request *request = [Request POSTRequestWithURL:url parameters:[body copy]];
    return [self performOperationkWithRequest:request completion:completion];
}

- (NSURLSessionTask *)PUTRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters completion:(RequestCompletionBlock)completion {
    Request *request = [Request PUTRequestWithURL:url parameters:parameters];
    return [self performOperationkWithRequest:request completion:completion];
}

- (NSURLSessionTask *)DELETERequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters completion:(RequestCompletionBlock)completion {
    Request *request = [Request DELETERequestWithURL:url parameters:parameters];
    return [self performOperationkWithRequest:request completion:completion];
}

- (NSURLSessionTask *)performRequest:(Request *)request completion:(RequestCompletionBlock)completion {
    NSURLSessionTask *operation = nil;
    
    if (self.isAuthenticated) {
        // Authenticated request, might need token refresh
        if (![self.oauthToken willExpireWithinIntervalFromNow:kTokenExpirationLimit]) {
            operation = [self performOperationkWithRequest:request completion:completion];
        } else {
            operation = [self enqueueOperationWithRequest:request completion:completion];
            [self refreshToken];
        }
    } else if (self.savedAuthenticationRequest) {
        // Can self-authenticate, authenticate before performing request
        operation = [self enqueueOperationWithRequest:request completion:completion];
        [self authenticateWithSavedRequest:self.savedAuthenticationRequest];
    } else {
        // Unauthenticated request
        operation = [self performOperationkWithRequest:request completion:completion];
    }
    
    return operation;
}

- (NSURLSessionTask *)performOperationkWithRequest:(Request *)request completion:(RequestCompletionBlock)completion {
    NSURLSessionTask *operation = [self.HTTPClient operationWithRequest:request completion:completion];
    [operation resume];
    
    return operation;
}

- (NSURLSessionTask *)enqueueOperationWithRequest:(Request *)request completion:(RequestCompletionBlock)completion {
    NSURLSessionTask *operation = [self.HTTPClient operationWithRequest:request completion:completion];
    [self.pendingOperations addObject:operation];
    
    return operation;
}

- (void)processPendingOperations {
    for (NSURLSessionTask *operation in self.pendingOperations) {
        [operation resume];
    }
    
    [self.pendingOperations removeAllObjects];
}

- (void)clearPendingOperations {
    for (NSURLSessionTask *operation in self.pendingOperations) {
        [operation cancel];
        [operation resume];
    }
    
    [self.pendingOperations removeAllObjects];
}


-(NSString *) makeRequestReturnFieldsConfig:(Request *) request {
    BOOL isFirstClassName = YES;
    Class clazz;
    NSString * selectorString = [NSMutableString string];
    NSString * path = request.path;
    NSArray * configClassPathTmp = [path componentsSeparatedByString:@"?"];
    NSArray * configClassPath = [configClassPathTmp[0] componentsSeparatedByString:@"/"];
    for (NSString * classPath in configClassPath) {
        if (![classPath isEqualToString:@""]) {
            if (isFirstClassName == YES) {
                isFirstClassName = NO;
                clazz = NSClassFromString([NSString stringWithFormat:@"RequestConfig%@", [classPath stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[classPath substringToIndex:1] uppercaseString]]]);
            } else {
                // 如果是数字参数，则跳过
                NSScanner* scan = [NSScanner scannerWithString:[classPath substringToIndex:1]];
                int val;
                if ([scan scanInt:&val]) {
                    continue;
                }
                
                if ([selectorString length] != 0) {
                    selectorString = [selectorString stringByAppendingString:[classPath stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[classPath substringToIndex:1] uppercaseString]]];
                } else {
                    selectorString = [selectorString stringByAppendingString:classPath];
                }
            }
        }
    }
    id configObject = [[clazz alloc] init];
    if (![configObject isKindOfClass:NSClassFromString(@"RequestConfigBase")]) {
        return nil;
    }
    SEL selector = NSSelectorFromString(selectorString.length == 0 ? @"get" : selectorString);
    if ([configObject respondsToSelector:selector]) {
        return [configObject performSelector:selector withObject:nil];
    }
    return nil;
}

#pragma mark - State

- (void)authenticationStateDidChange:(BOOL)isAuthenticated {
    [self updateAuthorizationHeader:isAuthenticated];
    [self updateStoredToken];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ClientTempAuthenticationStateDidChange" object:self];
}

- (void)updateAuthorizationHeader:(BOOL)isAuthenticated {
    if (isAuthenticated) {
        [self.HTTPClient setAuthorizationHeaderWithOAuth2AccessToken:self.oauthToken.accessToken];
        
        // Update all pending tasks with the new access token
        for (NSURLSessionTask *operation in self.pendingOperations) {
            if ([operation.originalRequest isKindOfClass:[NSMutableURLRequest class]]) {
                [(NSMutableURLRequest *)operation.originalRequest setAuthorizationHeaderWithOAuth2AccessToken:self.oauthToken.accessToken];
            }
        }
    } else if (self.apiKey && self.apiSecret) {
        [self.HTTPClient setAuthorizationHeaderWithAPIKey:self.apiKey secret:self.apiSecret];
    }
}

- (void)updateStoredToken {
    if (!self.tokenStore) return;
    
    OAuth2Token *token = self.oauthToken;
    if (token) {
        [self.tokenStore storeToken:token];
    } else {
        [self.tokenStore deleteStoredToken];
    }
}

- (void)restoreTokenIfNeeded {
    if (!self.tokenStore) {
        return;
    }
    if (!self.isAuthenticated) {
        self.oauthToken = [self.tokenStore storedToken];
    }
}

#pragma mark - Refresh token

- (NSURLSessionTask *)refreshTokenWithRefreshToken:(NSString *)refreshToken completion:(RequestCompletionBlock)completion {
    NSParameterAssert(refreshToken);
    
    Request *request = [AuthenticationAPI requestToRefreshToken:refreshToken];
    return [self authenticateWithRequest:request requestPolicy:ClientAuthRequestPolicyIgnore completion:completion];
}

- (NSURLSessionTask *)refreshToken:(RequestCompletionBlock)completion {
    NSAssert([self.oauthToken.refreshToken length] > 0, @"Can't refresh session, refresh token is missing.");
    
    return [self refreshTokenWithRefreshToken:self.oauthToken.refreshToken completion:completion];
}

- (NSURLSessionTask *)refreshToken {
    return [self refreshToken:^(Response *response, NSError *error) {
        if (!error) {
            [self processPendingOperations];
        } else {
            [self clearPendingOperations];
        }
    }];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kIsAuthenticatedContext) {
        BOOL isAuthenticated = [change[NSKeyValueChangeNewKey] boolValue];
        [self authenticationStateDidChange:isAuthenticated];
    }
}

@end
