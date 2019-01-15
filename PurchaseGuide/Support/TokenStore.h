//
//  TokenStore.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 10/06/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuth2Token.h"

@protocol TokenStore <NSObject>

- (void)storeToken:(OAuth2Token *)token;

- (void)deleteStoredToken;

- (OAuth2Token *)storedToken;

@end
