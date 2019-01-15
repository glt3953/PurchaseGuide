//
//  Response.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "Response.h"

@implementation Response

- (instancetype)initWithStatusCode:(NSInteger)statusCode body:(id)body {
    self = [super init];
    if (!self) return nil;
    
    _statusCode = statusCode;
    _body = body;
    
    return self;
}

@end
