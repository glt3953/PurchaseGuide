//
//  NSURLRequest+Description.m
//  Room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "NSURLRequest+Description.h"

@implementation NSURLRequest (Description)

- (NSString *)description {
    NSMutableString *mutString = [[NSMutableString alloc] init];
    
    [mutString appendString:@"--------------------------------------------------\n"];
    
    [mutString appendFormat:@"%@ %@\n", self.HTTPMethod, [self.URL absoluteString]];
    [mutString appendString:@"Headers:\n"];
    [self.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(id name, id value, BOOL *stop) {
        [mutString appendFormat:@"  %@=%@\n", name, value];
    }];
    
    if ([self.HTTPBody length] > 0) {
        [mutString appendString:@"Body:\n"];
        [mutString appendFormat:@"  %@\n", [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding]];
    }
    
    [mutString appendString:@"--------------------------------------------------"];
    
    return [mutString copy];
}

@end
