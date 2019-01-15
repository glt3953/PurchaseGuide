//
//  NSString+Valid.m
//  room107
//
//  Created by ningxia on 15/8/27.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "NSString+Valid.h"

@implementation NSString (Valid)

- (BOOL)isEmpty {
    return [self isEqualToString:@""] || ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0);
}

- (NSArray *)getComponentsBySeparatedString:(NSString *)separator {
    NSArray *strings = [self isEqualToString:@""] ? [[NSArray alloc] init] : [self componentsSeparatedByString:separator];
    NSMutableArray *mutableStrings = [strings mutableCopy];
    for (NSString *string in strings) {
        if ([string isEqualToString:@""]) {
            [mutableStrings removeObject:string];
        }
    }
    
    return [mutableStrings copy];
}

- (NSString *)firstStringBySeparatedString:(NSString *)separator {
    NSArray *strings = [self getComponentsBySeparatedString:separator];
    return strings.count > 0 ? strings[0] : @"";
}

@end
