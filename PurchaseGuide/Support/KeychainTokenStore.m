//
//  KeychainTokenStore.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 10/06/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "KeychainTokenStore.h"
#import "Keychain.h"

static NSString * const kTokenKeychainKey = @"Room107KitOAuthToken";

@interface KeychainTokenStore ()

@end

@implementation KeychainTokenStore

- (instancetype)initWithService:(NSString *)service {
  return [self initWithService:service accessGroup:nil];
}

- (instancetype)initWithService:(NSString *)service accessGroup:(NSString *)accessGroup {
  Keychain *keychain = [Keychain keychainForService:service accessGroup:accessGroup];
  return [self initWithKeychain:keychain];
}

- (instancetype)initWithKeychain:(Keychain *)keychain {
  self = [super init];
  if (!self) return nil;
  
  _keychain = keychain;
  
  return self;
}

#pragma mark - TokenStore

- (void)storeToken:(OAuth2Token *)token {
  [self.keychain setObject:(id)token ForKey:kTokenKeychainKey];
}

- (void)deleteStoredToken {
  [self.keychain removeObjectForKey:kTokenKeychainKey];
}

- (OAuth2Token *)storedToken {
  return [self.keychain objectForKey:kTokenKeychainKey];
}

@end
