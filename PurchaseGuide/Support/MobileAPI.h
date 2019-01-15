//
//  MobileAPI.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MobileAPI : NSObject

// 初始化接口
+ (Request *)requestForMobileInit;

// 绑定推送的设备
+ (Request *)requestForMobileBindWithToken:(NSString *)token version:(NSString *)version;

// 解绑设备
+ (Request *)requestForMobileUnBind;

+ (Request *)requestForUpdateWituildVersion:(NSString *)version;


@end
