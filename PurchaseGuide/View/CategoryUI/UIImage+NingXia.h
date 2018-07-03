//
//  UIImage+NingXia.h
//  NingXia
//
//  Created by ningxia on 15/6/24.
//  Copyright (c) 2015年 NingXia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NingXia)

- (UIImage *)makeContactAvatar;

+ (UIImage *)makeGroupAvatarWithImages:(NSArray *)images;

+ (CGSize)getThumbnailSizeFromSize:(CGSize)imageSize;
+ (UIImage *)makeThumbnailFromImage:(NSData *)data;

+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

+ (UIImage *)makeImageFromText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

+ (UIImage *)makeImageFromText:(NSString *)text font:(UIFont *)font color:(UIColor *)color bgColor:(UIColor *)bgColor radius:(CGFloat)radius;

+ (UIImage *)makeCircleImageWithColor:(UIColor *)color radius:(CGFloat)radius;

+ (UIImage *)decodedImageWithImage:(UIImage *)image;

+ (UIImage *)blur:(UIImage *)theImage;

+ (UIImage *)scaleIfNeeded:(CGImageRef)cgimg;

+ (UIImage *)reOrientIfNeeded:(UIImage *)theImage;

//动态改变UIImage图片的大小
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

+ (UIImage *)scalingPictures:(UIImage *)image withMaxWidth:(NSInteger)widthPix withMaxHeight:(NSInteger)heightPix;

@end
