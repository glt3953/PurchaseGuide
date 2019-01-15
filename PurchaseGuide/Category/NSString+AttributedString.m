//
//  NSString+AttributedString.m
//  room107
//
//  Created by ningxia on 15/7/29.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "NSString+AttributedString.h"

@implementation NSString (AttributedString)

+ (NSMutableAttributedString *)attributedStringFromString:(NSString *)string andFont:(UIFont *)font  andColor:(UIColor *)color{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string ? string : @""];
    [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

+ (NSMutableAttributedString *)attributedStringFromPriceStr:(NSString *)price andPriceFont:(UIFont *)priceFont andPriceColor:(UIColor *)priceColor andUnitFont:(UIFont *)unitFont andUnitColor:(UIColor *)unitColor {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price ? price : @""];
    [attributedString addAttribute:NSFontAttributeName value:unitFont range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:unitColor ? unitColor : [UIColor blackColor] range:NSMakeRange(0, 1)];
    [attributedString addAttribute:NSFontAttributeName value:priceFont range:NSMakeRange(1, attributedString.length - 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:priceColor ? priceColor : [UIColor blackColor] range:NSMakeRange(1, attributedString.length - 1)];
    
    return attributedString;
}

+ (NSMutableAttributedString *)attributedStringFromAreaStr:(NSString *)area andAreaFont:(UIFont *)areaFont andAreaColor:(UIColor *)areaColor andUnitFont:(UIFont *)unitFont andUnitColor:(UIColor *)unitColor {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:area ? area : @""];
    [attributedString addAttribute:NSFontAttributeName value:unitFont range:NSMakeRange(attributedString.length - 1, 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:unitColor ? unitColor : [UIColor blackColor] range:NSMakeRange(attributedString.length - 1, 1)];
    [attributedString addAttribute:NSFontAttributeName value:areaFont range:NSMakeRange(0, attributedString.length - 1)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:areaColor ? areaColor : [UIColor blackColor] range:NSMakeRange(0, attributedString.length - 1)];
    
    return attributedString;
}

+ (NSMutableAttributedString *)attributedStringFromAreaStr:(NSString *)changeStr color:(UIColor *)color {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:changeStr ? changeStr : @""];
    [attributeString setAttributes:@{NSForegroundColorAttributeName:color} range:NSMakeRange(0, 1)];
    
    return attributeString;
}

@end
