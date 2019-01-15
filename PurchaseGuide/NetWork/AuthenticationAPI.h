//
//  AuthenticationAPI.h
//  PodioKit
//
//  Created by Romain Briche on 28/01/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "Request.h"

@interface AuthenticationAPI : NSObject

+ (Request *)requestForAuthenticationWithEmail:(NSString *)email password:(NSString *)password;

+ (Request *)requestForAuthenticationWithAppID:(NSUInteger)appID token:(NSString *)appToken;

+ (Request *)requestToRefreshToken:(NSString *)refreshToken;

+ (Request *)requestToClientCredentialsToken;

@end
