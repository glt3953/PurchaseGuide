//
//  UIColor++NingXia.h
//  NingXia
//
//  Created by ningxia on 15/6/24.
//  Copyright (c) 2015年 NingXia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NingXia)

+ (NSDictionary *)rgbFromHexString:(NSString *)hexString;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(float)alpha;

+ (UIColor *)colorWithKey:(NSString *)key;

+ (UIColor *)colorWithCircleImageByKey:(NSString *)key radius:(CGFloat)radius;

+ (UIColor *)colorWithCircleImageWithColor:(UIColor *)color radius:(CGFloat)radius;

+ (UIColor *)room107GreenColor;

+ (UIColor *)room107GreenColorA;

+ (UIColor *)room107DeepGreenColor;

+ (UIColor *)room107LightGreenColor;

+ (UIColor *)room107GrayColorA;

+ (UIColor *)room107GrayColorB;

+ (UIColor *)room107GrayColorC;

+ (UIColor *)room107GrayColorD;

+ (UIColor *)room107GrayColorE;

+ (UIColor *)room107GrayColorEWithAlpha:(float)alpha;

+ (UIColor *)room107ViewBackgroundColor;

+ (UIColor *)room107YellowColor;

+ (UIColor *)room107PinkColor;

+ (UIColor *)room107BlueColor;

+ (UIColor *)room107AlipayBlueColor;

+ (UIColor *)room107WechatGreenColor;

+ (UIColor *)room107CMBPayRedColor;

+ (UIColor *)room107BlackColorWithAlpha:(float)alpha;

@end
