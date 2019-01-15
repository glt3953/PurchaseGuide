//
//  AppConfig.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "AppConfig.h"

NSString * const ConfigAPIKey = @"2";
NSString * const ConfigAPISecret = @"cr9pw1Gzbg65OmdIr0BN4MVS88swiKV8";

NSString * const AuthenticationPath = @"http://oauth.com/token";

@implementation AppConfig

+ (NSString *)requestEtagsCachePath {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentPath stringByAppendingPathComponent:@"requestEtags.archiver"];
}

@end
