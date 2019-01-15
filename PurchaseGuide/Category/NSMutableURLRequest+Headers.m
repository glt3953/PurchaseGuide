//
//  NSMutableURLRequest+Headers.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 21/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "NSMutableURLRequest+Headers.h"
#import "NSString+Base64.h"

static NSString * const kHeaderAuthorization = @"Authorization";
static NSString * const kAuthorizationOAuth2AccessTokenFormat = @"OAuth2 %@";

@implementation NSMutableURLRequest (Headers)

- (void)setAuthorizationHeaderWithOAuth2AccessToken:(NSString *)accessToken {
  NSString *value = [NSString stringWithFormat:kAuthorizationOAuth2AccessTokenFormat, accessToken];
  [self setValue:value forHTTPHeaderField:kHeaderAuthorization];
}

- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password {
  NSString *authString = [NSString stringWithFormat:@"%@:%@", username, password];
  [self setValue:[NSString stringWithFormat:@"Basic %@", [authString base64String]] forHTTPHeaderField:@"Authorization"];
}

@end
