//
//  NSString+AttributedString.h
//  room107
//
//  Created by ningxia on 15/7/29.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (AttributedString)

+ (NSMutableAttributedString *)attributedStringFromString:(NSString *)string andFont:(UIFont *)font andColor:(UIColor *)color;
+ (NSMutableAttributedString *)attributedStringFromPriceStr:(NSString *)price andPriceFont:(UIFont *)priceFont andPriceColor:(UIColor *)priceColor andUnitFont:(UIFont *)unitFont andUnitColor:(UIColor *)unitColor;
+ (NSMutableAttributedString *)attributedStringFromAreaStr:(NSString *)area andAreaFont:(UIFont *)areaFont andAreaColor:(UIColor *)areaColor andUnitFont:(UIFont *)unitFont andUnitColor:(UIColor *)unitColor;
+ (NSMutableAttributedString *)attributedStringFromAreaStr:(NSString *)changeStr color:(UIColor *)color;
@end
