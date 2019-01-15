//
//  MobileAPI.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "MobileAPI.h"
#import "Request.h"
#import <UIKit/UIKit.h>

@implementation MobileAPI

+ (Request *)requestForMobileInit {
    UIDevice *device = [UIDevice currentDevice];
    return [Request PUTRequestWithPath:@"/mobile/init" parameters:@{@"imei" : device.identifierForVendor.UUIDString}];
}

+ (Request *)requestForMobileBindWithToken:(NSString *)token version:(NSString *)version {
    UIDevice *device = [UIDevice currentDevice];
    NSDictionary *parameters = @{
                                 @"imei" : device.identifierForVendor.UUIDString,
                                 @"name" : device.model,
                                 @"os_platform" : platformKey,
                                 @"device_token" : token,
                                 @"build_code" : version,
                                 @"push_server" : @"development"
                                 };
    return [Request POSTRequestWithPath:@"/mobile/bind" parameters:parameters];
}

+ (Request *)requestForMobileUnBind {
    UIDevice *device = [UIDevice currentDevice];
    return [Request PUTRequestWithPath:@"/mobile/unbind" parameters:@{@"imei" : device.identifierForVendor.UUIDString}];
}

+ (Request *)requestForUpdateWituildVersion:(NSString *)version {
    UIDevice *device = [UIDevice currentDevice];
    NSDictionary *parameters =@{
                                @"platform" : platformKey,
                                @"system_version" : device.systemVersion,
                                @"device": @"phone",
                                @"build_code": version,
                                @"system_name" : device.systemName,
                                @"app_version" : version,
                                @"imei" : device.identifierForVendor.UUIDString
                                };
    
    return [Request GETRequestWithPath:@"/mobile/upgrade" parameters:parameters];
}

@end
