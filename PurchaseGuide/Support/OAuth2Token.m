//
//  OAuth2Token.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "OAuth2Token.h"
#import "NSValueTransformer+Transformers.h"

@implementation OAuth2Token

#pragma mark - NSObject

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]])
        return NO;
    
    return [self.accessToken isEqualToString:[object accessToken]];
}

- (NSUInteger)hash {
    return [self.accessToken hash];
}

#pragma mark - Model

+ (NSDictionary *)dictionaryKeyPathsForPropertyNames {
    return @{
             @"accessToken": @"access_token",
             @"refreshToken": @"refresh_token",
             @"expiresIn": @"expires_in",
             @"expires" : @"expires",
             @"tokenType": @"token_type",
             @"userID" : @"user_id",
             };
}

+ (NSValueTransformer *)expiresValueTransformer {
    return [NSValueTransformer transformerWithBlock:^id(NSNumber *expires) {
        return [NSDate dateWithTimeIntervalSince1970:[expires doubleValue]];
    }];
}

+ (NSValueTransformer *)expiresInValueTransformer {
    return [NSValueTransformer transformerWithBlock:^id(NSNumber *expiresIn) {
        return [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
    }];
}

#pragma mark - Public

- (BOOL)willExpireWithinIntervalFromNow:(NSTimeInterval)expireInterval {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:expireInterval];
    /**
     * expiresIn是通过时间差计算出来的本地过期时间，在expireInterval（10分钟）误差范围内，这个过期时间
     * 相对于expires可能更准确些（不需要考虑时区问题）
     */
    return [self.expiresIn earlierDate:date] == self.expiresIn;
}

@end
