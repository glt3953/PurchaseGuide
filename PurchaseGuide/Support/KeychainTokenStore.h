//
//  KeychainTokenStore.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 10/06/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenStore.h"

@class Keychain;

@interface KeychainTokenStore : NSObject <TokenStore>

@property (nonatomic, strong, readonly) Keychain *keychain;

- (instancetype)initWithService:(NSString *)service;

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup;

- (instancetype)initWithKeychain:(Keychain *)keychain;

@end
