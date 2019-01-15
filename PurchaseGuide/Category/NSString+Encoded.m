//
//  NSString+Encoded.m
//  room107
//
//  Created by ningxia on 15/8/12.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "NSString+Encoded.h"

@implementation NSString (Encoded)

- (NSString *)URLEncodedString {
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&=+$,/?%#[] "),
                                            kCFStringEncodingUTF8);

    return result;
}

- (NSString *)URLDecodedString {
    return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            CFSTR(""),
                                            kCFStringEncodingUTF8);
}

@end
