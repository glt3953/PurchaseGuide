//
//  NSString+IsPureNumer.m
//  room107
//
//  Created by 107间 on 15/11/20.
//  Copyright © 2015年 107room. All rights reserved.
//

#import "NSString+IsPureNumer.h"

@implementation NSString (IsPureNumer)

//整形判断
+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

//浮点形判断：
+ (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
@end
