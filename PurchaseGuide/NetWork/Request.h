//
//  Request.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestFileData.h"

#define RequestPath(fmt, ...) [NSString stringWithFormat:fmt, ##__VA_ARGS__]

typedef NSURLRequest * (^URLRequestConfigurationBlock) (NSURLRequest *request);

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGET = 0,
    RequestMethodPOST,
    RequestMethodPUT,
    RequestMethodDELETE,
};

typedef NS_ENUM(NSUInteger, RequestContentType) {
    RequestContentTypeJSON = 0,
    RequestContentTypeFormURLEncoded,
    RequestContentTypeMultipart
};

@interface Request : NSObject

@property (nonatomic, assign, readonly) RequestMethod method;
@property (nonatomic, copy, readonly) NSString *path;
@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, copy, readonly) NSDictionary *parameters;
@property (nonatomic, strong) RequestFileData *fileData;
@property (nonatomic, assign, readwrite) RequestContentType contentType;
@property (nonatomic, copy, readwrite) URLRequestConfigurationBlock URLRequestConfigurationBlock;

+ (instancetype)GETRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;
+ (instancetype)POSTRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;
+ (instancetype)PUTRequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;
+ (instancetype)DELETERequestWithPath:(NSString *)path parameters:(NSDictionary *)parameters;

+ (instancetype)GETRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters;
+ (instancetype)POSTRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters;
+ (instancetype)PUTRequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters;
+ (instancetype)DELETERequestWithURL:(NSURL *)url parameters:(NSDictionary *)parameters;

@end
