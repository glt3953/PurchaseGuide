//
//  NSMutableURLRequest+Headers.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 21/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Headers)

- (void)setAuthorizationHeaderWithOAuth2AccessToken:(NSString *)accessToken;
- (void)setAuthorizationHeaderWithUsername:(NSString *)username password:(NSString *)password;

@end
