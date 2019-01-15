//
//  RequestSerializer.h
//  PodioKit
//
//  Created by Romain Briche on 22/01/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <AFNetworking/AFURLRequestSerialization.h>

@class Request;

@interface RequestSerializer : AFHTTPRequestSerializer

- (void)setAuthorizationHeaderFieldWithOAuth2AccessToken:(NSString *)accessToken;
- (NSMutableURLRequest *)URLRequestForRequest:(Request *)request relativeToURL:(NSURL *)baseURL;

@end
