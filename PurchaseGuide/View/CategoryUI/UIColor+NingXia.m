//
//  UIColor++NingXia.m
//  NingXia
//
//  Created by ningxia on 15/6/24.
//  Copyright (c) 2015年 NingXia. All rights reserved.
//

#import "UIColor+NingXia.h"
#import "UIImage+NingXia.h"

@implementation UIColor (NingXia)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (NSDictionary *)rgbFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return @{@"red":@(((rgbValue & 0xFF0000) >> 16)) , @"green" : @(((rgbValue & 0xFF00) >> 8)) ,
             @"blue":@((rgbValue & 0xFF)) };
}

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(float)alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (UIColor *)colorWithKey:(NSString *)key {
    static NSDictionary *colorDictionary = nil;
    if (colorDictionary == nil) {
        // TODO:通过配置文件初始化颜色键值对
        colorDictionary = @{@"a":[self colorFromHexString:@"#4b81ca"],
                            @"b":[self colorFromHexString:@"#38b478"],
                            @"c":[self colorFromHexString:@"#e46933"],
                            @"d":[self colorFromHexString:@"#7badc0"],
                            @"e":[self colorFromHexString:@"#cacf3d"],
                            @"f":[self colorFromHexString:@"#77af4a"],
                            @"S":[self colorFromHexString:@"#ff8400"],
                            @"W":[self colorFromHexString:@"#0658a3"],
                            @"T":[self colorFromHexString:@"#86c927"],
                            @"E":[self colorFromHexString:@"#009cff"]};
    }
    
    return colorDictionary[key];
}

+ (UIColor *)colorWithCircleImageByKey:(NSString *)key radius:(CGFloat)radius {
    UIColor *color = [self colorWithKey:key];
    if (color == nil) {
        color = [UIColor whiteColor];
    }
    
    return [UIColor colorWithPatternImage:[UIImage makeCircleImageWithColor:color radius:radius]];
}

+ (UIColor *)colorWithCircleImageWithColor:(UIColor *)color radius:(CGFloat)radius {
    return [UIColor colorWithPatternImage:[UIImage makeCircleImageWithColor:color radius:radius]];
}

+ (UIColor *)room107GreenColor {
    return [UIColor colorFromHexString:@"#00ac97"];
}

+ (UIColor *)room107GreenColorA {
    return [UIColor colorFromHexString:@"#009482"];
}

+ (UIColor *)room107DeepGreenColor {
    return [UIColor colorFromHexString:@"#009a87"];
}

+ (UIColor *)room107LightGreenColor {
    return [UIColor colorFromHexString:@"#1fa38c" alpha:0.5];
}

+ (UIColor *)room107GrayColorA {
    return [UIColor colorFromHexString:@"#f1f1f1"];
}

+ (UIColor *)room107GrayColorB {
    return [UIColor colorFromHexString:@"#e4e4e4"];
}

+ (UIColor *)room107GrayColorC {
    return [UIColor colorFromHexString:@"#c9c9c9"];
}

+ (UIColor *)room107GrayColorD {
    return [UIColor colorFromHexString:@"#797979"];
}

+ (UIColor *)room107GrayColorE {
    return [UIColor colorFromHexString:@"#494949"];
}

+ (UIColor *)room107GrayColorEWithAlpha:(float)alpha {
    return [UIColor colorFromHexString:@"#494949" alpha:alpha];
}

+ (UIColor *)room107ViewBackgroundColor {
    return [UIColor colorFromHexString:@"#f1f1f1"];
}

+ (UIColor *)room107YellowColor {
    return [UIColor colorFromHexString:@"#ffbc00"];
}

+ (UIColor *)room107PinkColor {
    return [UIColor colorFromHexString:@"#ff8080"];
}

+ (UIColor *)room107BlueColor {
    return [UIColor colorFromHexString:@"#199bff"];
}

+ (UIColor *)room107AlipayBlueColor {
    return [UIColor colorFromHexString:@"#00bbee"];
}

+ (UIColor *)room107WechatGreenColor {
    return [UIColor colorFromHexString:@"#00c800"];
}

+ (UIColor *)room107CMBPayRedColor {
    return [UIColor colorFromHexString:@"#b1130d"];
}

+ (UIColor *)room107BlackColorWithAlpha:(float)alpha {
    return [UIColor colorFromHexString:@"#000000" alpha:alpha];
}

@end
