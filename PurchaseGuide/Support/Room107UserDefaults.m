//
//  Room107UserDefaults.m
//  room107
//
//  Created by ningxia on 15/7/23.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "Room107UserDefaults.h"

static NSString *PrefixKey = @"Room107"; //Room107UserDefaults的key值前缀

@implementation Room107UserDefaults

+ (void)saveUserDefaultsWithKey:(NSString *)key andValue:(id)value {
    NSUserDefaults *getItemsDefaults = [NSUserDefaults standardUserDefaults];
    [getItemsDefaults setObject:value forKey:[PrefixKey stringByAppendingString:key ? key : @""]];
    [getItemsDefaults synchronize];
}

+ (id)getValueFromUserDefaultsWithKey:(NSString *)key {
    NSUserDefaults *getItemsDefaults = [NSUserDefaults standardUserDefaults];
    return [getItemsDefaults objectForKey:[PrefixKey stringByAppendingString:key ? key : @""]];
}

+ (void)clearUserDefaults {
    NSUserDefaults *getItemsDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [getItemsDefaults dictionaryRepresentation];
    for(NSString *key in [dictionary allKeys]){
        if ([key hasPrefix:PrefixKey]) {
            //前缀
            if ([key hasSuffix:SubscribeTimestampKey] || [key hasSuffix:SubscribeNewHomesCountKey]) {
                //后缀
                continue;
            }
            [getItemsDefaults removeObjectForKey:key];
            [getItemsDefaults synchronize];
        }
    }
    //记录当前连接的服务器域名
    [self saveUserDefaultsWithKey:KEY_BASEURL andValue:[[AppClient sharedInstance] baseDomain]];
}

+ (NSString *)getPublicKeyString {
//    return @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCJzjkg17+kKo4TNED+RM6hdS5whhgEh4RHwkJ0LtYaCJf4ggF0QjjRYkuNyWha3lvkHX36suImYjyB+rTcYHn6HV7BnEw2BCZAP7GS2sSiupDTWw2kcPb1S7refjfHaEwAYXVZpdjQeNePSCWaSxupkOI/QfuazpcTot9PtMVdBwIDAQAB";
    //必须有头尾信息
    return @"-----BEGIN PUBLIC KEY-----\n"
    "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCJzjkg17+kKo4TNED+RM6hdS5w\n"
    "hhgEh4RHwkJ0LtYaCJf4ggF0QjjRYkuNyWha3lvkHX36suImYjyB+rTcYHn6HV7B\n"
    "nEw2BCZAP7GS2sSiupDTWw2kcPb1S7refjfHaEwAYXVZpdjQeNePSCWaSxupkOI/\n"
    "QfuazpcTot9PtMVdBwIDAQAB\n"
    "-----END PUBLIC KEY-----\n";
}

+ (BOOL)isLogin {
    id object = [self getValueFromUserDefaultsWithKey:KEY_EXPIRES];
    if ([object isKindOfClass:[NSDate class]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isAuthenticated {
    return YES;
}

+ (BOOL)hasAvatar {
    return YES;
}

+ (NSString *)encryptToken {
    NSDate *expires = (NSDate *)[self getValueFromUserDefaultsWithKey:KEY_EXPIRES];
    if ([expires compare:[NSDate date]] == NSOrderedAscending) {
        //有效期已早于当前日期
        NSString *encryptToken = [[self getValueFromUserDefaultsWithKey:KEY_TOKEN] stringByAppendingFormat:@"_%.f000", [NSDate date].timeIntervalSince1970];
        encryptToken = [RSA encryptString:encryptToken publicKey:[self getPublicKeyString]];
        [self saveUserDefaultsWithKey:KEY_ENCRYPTTOKEN andValue:encryptToken];
        
        return encryptToken;
    }
    
    return [self getValueFromUserDefaultsWithKey:KEY_ENCRYPTTOKEN];
}

+ (NSString *)username {
    return [self getValueFromUserDefaultsWithKey:KEY_USERNAME];
}

+ (NSString *)telephone {
    return [self getValueFromUserDefaultsWithKey:KEY_TELEPHONE];
}

+ (NSString *)UUIDString {
    return [self getValueFromUserDefaultsWithKey:KEY_UUIDString];
}

+ (void)saveSubscribeTimestamp:(id)timestamp {
    NSMutableArray *timestampArray = [[NSMutableArray alloc] initWithArray:[Room107UserDefaults getValueFromUserDefaultsWithKey:SubscribeTimestampKey]];
    if (!timestampArray) {
        timestampArray = [[NSMutableArray alloc] init];
    }
    NSString *username = platformKey;
    if ([self isLogin]) {
        username = [self username];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username=%@", username ? username : platformKey]; //实现数组的快速查询
    NSArray *filteredArray = [timestampArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count == 0) {
        NSMutableDictionary *timestampDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:username ? username : platformKey, @"username", timestamp ? timestamp : @0, SubscribeTimestampKey, nil];
        [timestampArray addObject:timestampDic];
    } else {
        NSMutableDictionary *timestampDic = [NSMutableDictionary dictionaryWithDictionary:filteredArray[0]];
        [timestampDic setValue:timestamp ? timestamp : @0 forKey:SubscribeTimestampKey];
        [timestampArray replaceObjectAtIndex:[timestampArray indexOfObject:filteredArray[0]] withObject:timestampDic];
    }
    
    [Room107UserDefaults saveUserDefaultsWithKey:SubscribeTimestampKey andValue:timestampArray];
}

+ (id)subscribeTimestamp {
    NSMutableArray *timestampArray = [Room107UserDefaults getValueFromUserDefaultsWithKey:SubscribeTimestampKey];
    if (!timestampArray) {
        return nil;
    }
    
    NSString *username = platformKey;
    if ([self isLogin]) {
        username = [self username];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username=%@", username ? username : platformKey]; //实现数组的快速查询
    NSArray *filteredArray = [timestampArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count == 0) {
        return nil;
    } else {
        return filteredArray[0][SubscribeTimestampKey];
    }
}

+ (void)saveSubscribeNewHomesCount:(id)count {
    NSMutableArray *newHomesCountArray = [[NSMutableArray alloc] initWithArray:[Room107UserDefaults getValueFromUserDefaultsWithKey:SubscribeNewHomesCountKey]];
    if (!newHomesCountArray) {
        newHomesCountArray = [[NSMutableArray alloc] init];
    }
    NSString *username = platformKey;
    if ([self isLogin]) {
        username = [self username];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username=%@", username ? username : platformKey]; //实现数组的快速查询
    NSArray *filteredArray = [newHomesCountArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count == 0) {
        NSMutableDictionary *newHomesCountDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:username ? username : platformKey, @"username", count ? count : @0, SubscribeNewHomesCountKey, nil];
        [newHomesCountArray addObject:newHomesCountDic];
    } else {
        NSMutableDictionary *newHomesCountDic = [NSMutableDictionary dictionaryWithDictionary:filteredArray[0]];
        [newHomesCountDic setValue:count ? count : @0 forKey:SubscribeNewHomesCountKey];
        [newHomesCountArray replaceObjectAtIndex:[newHomesCountArray indexOfObject:filteredArray[0]] withObject:newHomesCountDic];
    }
    
    [Room107UserDefaults saveUserDefaultsWithKey:SubscribeNewHomesCountKey andValue:newHomesCountArray];
}

+ (id)subscribeNewHomesCount {
    NSMutableArray *newHomesCountArray = [Room107UserDefaults getValueFromUserDefaultsWithKey:SubscribeNewHomesCountKey];
    if (!newHomesCountArray) {
        return nil;
    }
    
    NSString *username = platformKey;
    if ([self isLogin]) {
        username = [self username];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username=%@", username ? username : platformKey]; //实现数组的快速查询
    NSArray *filteredArray = [newHomesCountArray filteredArrayUsingPredicate:predicate];
    if (filteredArray.count == 0) {
        return nil;
    } else {
        return filteredArray[0][SubscribeNewHomesCountKey];
    }
}

@end
