//
//  Request.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "Request.h"

@implementation Request

- (instancetype)initWithPath:(NSString *)path url:(NSURL *)url parameters:(NSDictionary *)parameters method:(RequestMethod)method {
    self = [super init];
    if (!self) return nil;
    
    _path = [path copy];
    _URL = [url copy];
    _parameters = [parameters copy];
    _method = method;
    _contentType = RequestContentTypeJSON;
    
    return self;
}

+ (instancetype)requestWithPath:(NSString *)path parameters:(NSDictionary *)parameters method:(RequestMethod)method {
    return [[self alloc] initWithPath:path url:nil parameters:parameters method:method];
}

+ (instancetype)requestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters method:(RequestMethod)method {
    return [[self alloc] initWithPath:nil url:url parameters:parameters method:method];
}

+ (instancetype)GETRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    return [self requestWithPath:path parameters:parameters method:RequestMethodGET];
}

+ (instancetype)POSTRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    return [self requestWithPath:path parameters:parameters method:RequestMethodPOST];
}

+ (instancetype)PUTRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    return [self requestWithPath:path parameters:parameters method:RequestMethodPUT];
}

+ (instancetype)DELETERequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
    return [self requestWithPath:path parameters:parameters method:RequestMethodDELETE];
}

+ (instancetype)GETRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters {
    return [self requestWithURL:url parameters:parameters method:RequestMethodGET];
}

+ (instancetype)POSTRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters {
    return [self requestWithURL:url parameters:parameters method:RequestMethodPOST];
}

+ (instancetype)PUTRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters {
    return [self requestWithURL:url parameters:parameters method:RequestMethodPUT];
}

+ (instancetype)DELETERequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters {
    return [self requestWithURL:url parameters:parameters method:RequestMethodDELETE];
}

@end
