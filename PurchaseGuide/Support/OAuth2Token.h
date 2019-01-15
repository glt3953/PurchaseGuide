//
//  OAuth2Token.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuth2Token : NSObject

@property (nonatomic, copy, readonly) NSString *accessToken;
@property (nonatomic, copy, readonly) NSString *refreshToken;
@property (nonatomic, copy, readonly) NSDate *expires;
@property (nonatomic, copy, readonly) NSDate *expiresIn;
@property (nonatomic, assign, readonly) NSInteger userID;
@property (nonatomic, copy, readonly) NSString *tokenType;

- (BOOL)willExpireWithinIntervalFromNow:(NSTimeInterval)expireInterval;

@end
