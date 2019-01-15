//
//  Response.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (nonatomic, assign, readonly) NSInteger statusCode;
@property (nonatomic, copy, readonly) id body;

- (instancetype)initWithStatusCode:(NSInteger)statusCode body:(id)body;

@end
