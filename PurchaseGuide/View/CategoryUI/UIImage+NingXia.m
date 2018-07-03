//
//  UIImage+NingXia.m
//  NingXia
//
//  Created by ningxia on 15/6/24.
//  Copyright (c) 2015年 NingXia. All rights reserved.
//

#import "UIImage+NingXia.h"

@implementation UIImage (NingXia)

- (UIImage *)makeContactAvatar {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, self.size.width, self.size.width, 8, 4 * self.size.width, colorSpace, 2);
    CGRect ovalRect = CGRectMake(0.f, 0.f, self.size.width, self.size.width);

    CGContextSaveGState(context);
    
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    CGContextAddPath(context, ovalPath.CGPath);
    CGContextClip(context);
    CGContextDrawImage(context, ovalRect, self.CGImage);
    
    CGContextRestoreGState(context);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *avatarImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return avatarImage;
}

+ (UIImage *)makeGroupAvatarWithImages:(NSArray *)images {
    NSAssert(images.count > 0, @"images.count should > 0<createGroupAvatarImage>");
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, 96.f, 96.f, 8, 4 * 96.f, colorSpace, 2);
    static const float avatarWidth = 44.f;
    static const float avatarHeight = 44.f;
    static CGRect rect1[] = {{{21.f,21.f},{54.f,54.f}}};
    static CGRect rect2[] = {{{0.f,24.f},{avatarWidth,avatarHeight}}, {{48.f,24.f},{avatarWidth,avatarHeight}}};
    static CGRect rect3[] = {{{24.f,48.f},{avatarWidth,avatarHeight}},{{0.f,0.f},{avatarWidth,avatarHeight}},{{48.f,0.f},{avatarWidth,avatarHeight}}};
    static CGRect rect4[] = {{{0.f,48.f},{avatarWidth,avatarHeight}},{{48.f,48.f},{avatarWidth,avatarHeight}},{{0.f,0.f},{avatarWidth,avatarHeight}},{{48.f,0.f},{avatarWidth,avatarHeight}}};
    static CGRect *rectss[] = {rect1, rect2, rect3, rect4};
    
    CGRect *rects = rectss[images.count - 1];
    for (NSInteger i = 0; i < images.count; ++i) {
        UIImage *image = [images objectAtIndex:i];

        CGContextSaveGState(context);
        
        UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect:rects[i]];
        CGContextAddPath(context, ovalPath.CGPath);
        CGContextClip(context);
        CGContextDrawImage(context, rects[i], image.CGImage);
        
        CGContextRestoreGState(context);
    }
   
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *avatarImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return avatarImage;
}

+ (CGSize)getThumbnailSizeFromSize:(CGSize)imageSize {
    static const float maxwh = 120.f;
    
    float max = MAX(imageSize.width, imageSize.height);
    
    if (max <= maxwh) {
        return imageSize;
    }
    
    float r = maxwh / max;
    if (imageSize.height > imageSize.width) {
        return CGSizeMake(imageSize.width * r, maxwh);
    } else {
        return CGSizeMake(maxwh, imageSize.height * r);
    }
}

+ (UIImage *)makeThumbnailFromImage:(NSData *)data {
    if (data == nil) {
        return nil;
    }
    
    UIImage *image = [UIImage imageWithData:data];
    CGSize sizeNew = [self getThumbnailSizeFromSize:image.size];
    if (CGSizeEqualToSize(sizeNew, image.size)) {
        return image;
    }
    
    UIGraphicsBeginImageContext(sizeNew);
    [image drawInRect:CGRectMake(0.f, 0.f, sizeNew.width, sizeNew.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (CGImageRef)CopyImageAndAddAlphaChannel :(CGImageRef) sourceImage {
    CGImageRef retVal = NULL;
    size_t width = CGImageGetWidth(sourceImage);
    size_t height = CGImageGetHeight(sourceImage);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL, width, height,
                                                          8, 0, colorSpace, kCGBitmapAlphaInfoMask);
    
    if (offscreenContext != NULL) {
        CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), sourceImage);
        
        retVal = CGBitmapContextCreateImage(offscreenContext);
        CGContextRelease(offscreenContext);
    }
    
    CGColorSpaceRelease(colorSpace);
    return retVal;
}

/*
+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = [self CopyImageAndAddAlphaChannel:maskImage.CGImage];//maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    //add alpha channel for images that don’t have one (ie GIF, JPEG, etc…)
    //this however has a computational cost
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
        imageWithAlpha = [self CopyImageAndAddAlphaChannel :sourceImage];
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);
    CGImageRelease(mask);
    
    //release imageWithAlpha if it was created by CopyImageAndAddAlphaChannel
    if (sourceImage != imageWithAlpha) {
        CGImageRelease(imageWithAlpha);
    }
    
    UIImage *retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    return retImage;
}
*/

+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    if ((image == nil) || (maskImage == nil))  return image;
    
    CGRect destRect = CGRectMake(0.f, 0.f, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContext(image.size);
    [maskImage drawInRect:destRect];
    UIImage *newMaskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, image.size.width, image.size.height, 8, 4 * image.size.width, colorSpace, 2);
    
    CGContextClipToMask(context, destRect, newMaskImage.CGImage);
    CGContextDrawImage(context, destRect, image.CGImage);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIImage *retImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    return retImage;

}

+ (UIImage *)makeImageFromText:(NSString *)text font:(UIFont *)font color:(UIColor *)color {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(ctx, color.CGColor);
//    CGContextSetShouldSmoothFonts(ctx, YES);
//    
//    CGContextSetShouldAntialias(ctx, YES);
//    CGContextSetLineWidth(ctx, 10);
    [text drawAtPoint:CGPointMake(0.0, 0.0) withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:color}]; //增加颜色属性
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)makeImageFromText:(NSString *)text font:(UIFont *)font color:(UIColor *)color bgColor:(UIColor *)bgColor radius:(CGFloat)radius {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName:font}];
    CGFloat diameter = radius * 2;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){ diameter, diameter},NO,0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect aRect= CGRectMake(0, 0, diameter, diameter);
    CGContextSetLineWidth(context, 3.0);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillEllipseInRect(context, aRect);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    [text drawAtPoint:CGPointMake(radius - size.width/2, radius - size.height/2) withAttributes:@{NSFontAttributeName:font}];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)makeCircleImageWithColor:(UIColor *)color radius:(CGFloat)radius {
    CGFloat diameter = radius * 2;
    
    UIGraphicsBeginImageContextWithOptions((CGSize){ diameter, diameter},NO,0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect aRect= CGRectMake(0, 0, diameter, diameter);
    CGContextSetLineWidth(context, 3.0);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillEllipseInRect(context, aRect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    if (image.images) {
        // Do not decode animated images
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return image;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}


+ (UIImage *)blur:(UIImage *)theImage {
    // ***********If you need re-orienting (e.g. trying to blur a photo taken from the device camera front facing camera in portrait mode)
    // theImage = [self reOrientIfNeeded:theImage];
    
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *returnImage = [UIImage imageWithCGImage:cgImage];//create a UIImage for this function to "return" so that ARC can manage the memory of the blur... ARC can't manage CGImageRefs so we need to release it before this function "returns" and ends.
    CGImageRelease(cgImage);//release CGImageRef because ARC doesn't manage this on its own.
    
    return returnImage;
    
    // *************** if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

+ (UIImage *)scaleIfNeeded:(CGImageRef)cgimg {
    bool isRetina = [[[UIDevice currentDevice] systemVersion] intValue] >= 4 && [[UIScreen mainScreen] scale] == 2.0;
    if (isRetina) {
        return [UIImage imageWithCGImage:cgimg scale:2.0 orientation:UIImageOrientationUp];
    } else {
        return [UIImage imageWithCGImage:cgimg];
    }
}

+ (UIImage *)reOrientIfNeeded:(UIImage *)theImage {
    
    if (theImage.imageOrientation != UIImageOrientationUp) {
        
        CGAffineTransform reOrient = CGAffineTransformIdentity;
        switch (theImage.imageOrientation) {
            case UIImageOrientationDown:
            case UIImageOrientationDownMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, theImage.size.height);
                reOrient = CGAffineTransformRotate(reOrient, M_PI);
                break;
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, 0);
                reOrient = CGAffineTransformRotate(reOrient, M_PI_2);
                break;
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, 0, theImage.size.height);
                reOrient = CGAffineTransformRotate(reOrient, -M_PI_2);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationUpMirrored:
                break;
            default:
                break;
        }
        
        switch (theImage.imageOrientation) {
            case UIImageOrientationUpMirrored:
            case UIImageOrientationDownMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.width, 0);
                reOrient = CGAffineTransformScale(reOrient, -1, 1);
                break;
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
                reOrient = CGAffineTransformTranslate(reOrient, theImage.size.height, 0);
                reOrient = CGAffineTransformScale(reOrient, -1, 1);
                break;
            case UIImageOrientationUp:
            case UIImageOrientationDown:
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
                break;
            default:
                break;
        }
        
        CGContextRef myContext = CGBitmapContextCreate(NULL, theImage.size.width, theImage.size.height, CGImageGetBitsPerComponent(theImage.CGImage), 0, CGImageGetColorSpace(theImage.CGImage), CGImageGetBitmapInfo(theImage.CGImage));
        
        CGContextConcatCTM(myContext, reOrient);
        
        switch (theImage.imageOrientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRight:
            case UIImageOrientationRightMirrored:
                CGContextDrawImage(myContext, CGRectMake(0,0,theImage.size.height,theImage.size.width), theImage.CGImage);
                break;
                
            default:
                CGContextDrawImage(myContext, CGRectMake(0,0,theImage.size.width,theImage.size.height), theImage.CGImage);
                break;
        }
        
        CGImageRef CGImg = CGBitmapContextCreateImage(myContext);
        theImage = [UIImage imageWithCGImage:CGImg];
        
        CGImageRelease(CGImg);
        CGContextRelease(myContext);
    }
    
    return theImage;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if(newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    return newImage ;
}

- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    switch ( self.imageOrientation )
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
        default:
            drawTransposed = NO;
            break;
    }
    
    CGAffineTransform transform = [self transformForOrientation:newSize];
    
    return [self resizedImage:newSize transform:transform drawTransposed:drawTransposed interpolationQuality:quality];
}

#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat scale = MAX(1.0f, self.scale);
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width*scale, newSize.height*scale));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Fix for a colorspace / transparency issue that affects some types of
    // images. See here: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/comment-page-2/#comment-39951
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(
                                                NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8, /* bits per channel */
                                                (newRect.size.width * 4), /* 4 channels per pixel * numPixels/row */
                                                colorSpace,
                                                kCGBitmapAlphaInfoMask
                                                );
    CGColorSpaceRelease(colorSpace);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:self.scale orientation:UIImageOrientationUp];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

+ (UIImage *)scalingPictures:(UIImage *)image withMaxWidth:(NSInteger)widthPix withMaxHeight:(NSInteger)heightPix {
    CGSize oldImageSize = image.size;
    CGSize newImageSize;
    
    if ((widthPix * 1.0 / oldImageSize.width) * oldImageSize.height < heightPix) {
        newImageSize = (CGSize){widthPix,(widthPix * 1.0 / oldImageSize.width) * oldImageSize.height};
    } else {
        newImageSize = (CGSize){(heightPix * 1.0 / oldImageSize.height) * oldImageSize.width,heightPix};
    }
    
    UIGraphicsBeginImageContext(newImageSize);
    
    [image drawInRect:CGRectMake(0,0,newImageSize.width,newImageSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
