//
//  AuthenticationAPI.m
//  PodioKit
//
//  Created by Romain Briche on 28/01/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "AuthenticationAPI.h"
#import "AppConfig.h"

//static NSString * const kAuthenticationPath = @"/oauth/token";




static NSString * const kAuthenticationGrantTypeKey = @"grant_type";
static NSString * const kAuthenticationUsernameKey = @"username";
static NSString * const kAuthenticationPasswordKey = @"password";
static NSString * const kAuthenticationAppIDKey = @"app_id";
static NSString * const kAuthenticationAppTokenKey = @"app_token";
static NSString * const kAuthenticationrRefreshTokenKey = @"refresh_token";

static NSString * const kAuthenticationGrantTypePassword = @"password";
static NSString * const kAuthenticationGrantTypeApp = @"app";
static NSString * const kAuthenticationGrantTypeRefreshToken = @"refresh_token";

@implementation AuthenticationAPI

+ (Request *)requestForAuthenticationWithEmail:(NSString *)email password:(NSString *)password {
    NSParameterAssert(email);
    NSParameterAssert(password);
    
    return [self requestForAuthenticationWithGrantType:kAuthenticationGrantTypePassword parameters:@{kAuthenticationUsernameKey: email, kAuthenticationPasswordKey: password, @"client_id": ConfigAPIKey, @"client_secret": ConfigAPISecret}];
}

+ (Request *)requestForAuthenticationWithAppID:(NSUInteger)appID token:(NSString *)appToken {
    NSParameterAssert(appID);
    NSParameterAssert(appToken);
    
    return [self requestForAuthenticationWithGrantType:kAuthenticationGrantTypeApp parameters:@{kAuthenticationAppIDKey: @(appID), kAuthenticationAppTokenKey: appToken}];
}

+ (Request *)requestToRefreshToken:(NSString *)refreshToken {
    NSParameterAssert(refreshToken);
    
    return [self requestForAuthenticationWithGrantType:kAuthenticationGrantTypeRefreshToken parameters:@{kAuthenticationrRefreshTokenKey:refreshToken ? refreshToken : @""}];
}

+ (Request *)requestToClientCredentialsToken {
    return [self requestForAuthenticationWithGrantType:@"client_credentials" parameters:@{kAuthenticationUsernameKey : ConfigAPIKey,kAuthenticationGrantTypePassword : ConfigAPISecret}];
}

#pragma mark - Private

+ (Request *)requestForAuthenticationWithGrantType:(NSString *)grantType parameters:(NSDictionary *)parameters {
    NSParameterAssert(grantType);
    NSParameterAssert(parameters);
    
    NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:parameters];
    body[kAuthenticationGrantTypeKey] = grantType;
    
    Request *request = [Request POSTRequestWithPath:AuthenticationPath parameters:[body copy]];
    //request.contentType = RequestContentTypeFormURLEncoded;
    
    return request;
}

@end
