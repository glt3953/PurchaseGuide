//
//  RequestSerializer.m
//  PodioKit
//
//  Created by Romain Briche on 22/01/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "RequestSerializer.h"
#import "NSString+Random.h"
#import "Request.h"
#import "AppConfig.h"
#import "HTTPClient.h"

static NSString * const kHTTPMethodGET = @"GET";
static NSString * const kHTTPMethodPOST = @"POST";
static NSString * const kHTTPMethodPUT = @"PUT";
static NSString * const kHTTPMethodDELETE = @"DELETE";

static NSString * const kHeaderRequestId = @"X-107room-Request-Id";
static NSUInteger const kRequestIdLength = 8;

static NSString * const kHeaderAuthorization = @"Authorization";
static NSString * const kAuthorizationOAuth2AccessTokenFormat = @"Bearer %@";

@interface RequestSerializer ()

@property (nonatomic, assign) RequestContentType requestContentType;

@end

@implementation RequestSerializer

#pragma mark - AFURLRequestSerialization

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request withParameters:(id)parameters error:(NSError *__autoreleasing *)error {
    NSParameterAssert(request);
    
    if ([self.HTTPMethodsEncodingParametersInURI containsObject:[[request HTTPMethod] uppercaseString]] ||
        self.requestContentType == RequestContentTypeFormURLEncoded) {
        return [super requestBySerializingRequest:request withParameters:parameters error:error];
    }
    
    // Format as JSON
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    
    [self.HTTPRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id field, id value, BOOL * __unused stop) {
        if (![request valueForHTTPHeaderField:field]) {
            [mutableRequest setValue:value forHTTPHeaderField:field];
        }
    }];
    
    if (!parameters) {
        return mutableRequest;
    }
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    // 请求头的类型修改为parameter的形式
//    [mutableRequest setValue:[NSString stringWithFormat:@"application/json; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setValue:[NSString stringWithFormat:@"application/x-www-form-urlencoded; charset=%@", charset] forHTTPHeaderField:@"Content-Type"];
    
    NSArray *keys = [parameters allKeys];
    if (keys.count > 0) {
        NSString *parameter = [NSString stringWithFormat:@"%@=%@", [keys objectAtIndex:0], [parameters objectForKey:[keys objectAtIndex:0]]];
        for (NSUInteger i = 1; i < keys.count; i++) {
           parameter = [parameter stringByAppendingFormat:@"&%@=%@", [keys objectAtIndex:i], [parameters objectForKey:[keys objectAtIndex:i]]];
        }
        [mutableRequest setHTTPBody:[parameter dataUsingEncoding:NSUTF8StringEncoding]];
    }

//    [mutableRequest setHTTPBody:[NSJSONSerialization dataWithJSONObject:parameters options:0 error:error]];
    
    return mutableRequest;
}

#pragma mark - HTTP headers

- (void)setAuthorizationHeaderFieldWithOAuth2AccessToken:(NSString *)accessToken {
    NSParameterAssert(accessToken);
    
    [self setValue:[NSString stringWithFormat:kAuthorizationOAuth2AccessTokenFormat, accessToken] forHTTPHeaderField:kHeaderAuthorization];
}

#pragma mark - URL request

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters error:(NSError *__autoreleasing *)error {
    NSMutableURLRequest *request = [super requestWithMethod:method URLString:URLString parameters:parameters error:error];
    
    [request setValue:[self generatedRequestId] forHTTPHeaderField:kHeaderRequestId];
    
    return request;
}

- (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method URLString:(NSString *)URLString parameters:(NSDictionary *)parameters fileData:(RequestFileData *)fileData error:(NSError *__autoreleasing *)error {
    NSMutableURLRequest *request = [super multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (fileData.data) {
            [formData appendPartWithFormData:[fileData.fileName dataUsingEncoding:NSUTF8StringEncoding] name:@"filename"];
            [formData appendPartWithFormData:[fileData.name dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
            [formData appendPartWithFileData:fileData.data name:@"source" fileName:fileData.fileName mimeType:fileData.mimeType];
        } else if (fileData.filePath) {
            [formData appendPartWithFormData:[fileData.fileName dataUsingEncoding:NSUTF8StringEncoding] name:@"filename"];
            [formData appendPartWithFormData:[fileData.name dataUsingEncoding:NSUTF8StringEncoding] name:@"type"];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:fileData.filePath]
                                       name:@"source"
                                   fileName:fileData.fileName
                                   mimeType:fileData.mimeType
                                      error:nil];
        }
    } error:error];
    
    [request setValue:[self generatedRequestId] forHTTPHeaderField:kHeaderRequestId];
    
    return request;
}

- (NSMutableURLRequest *)URLRequestForRequest:(Request *)request relativeToURL:(NSURL *)baseURL {
    @synchronized(self) {
        NSParameterAssert(request);
        NSParameterAssert(baseURL);
        
        NSURL *url = nil;
        if (request.URL) {
            url = request.URL;
        } else if([request.path isEqualToString:AuthenticationPath]) {
            url = [NSURL URLWithString:request.path];
        } else {
            NSParameterAssert(request.path);
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kDefaultAPIVerson,request.path] relativeToURL:baseURL];
        }
        
        NSString *urlString = [url absoluteString];
        NSString *method = [[self class] HTTPMethodForMethod:request.method];
        
        NSMutableURLRequest *urlRequest = nil;
        
        if (request.contentType == RequestContentTypeMultipart) {
            urlRequest = [self multipartFormRequestWithMethod:method
                                                    URLString:urlString
                                                   parameters:request.parameters
                                                     fileData:request.fileData
                                                        error:nil];
        } else {
            // Use content type of request
            RequestContentType contentType = self.requestContentType;
            self.requestContentType = request.contentType;
            
            urlRequest = [self requestWithMethod:method URLString:urlString parameters:request.parameters error:nil];
            
            // Reset content type
            self.requestContentType = contentType;
        }
        
        if (request.URLRequestConfigurationBlock) {
            urlRequest = [request.URLRequestConfigurationBlock(urlRequest) mutableCopy];
        }
        
        return urlRequest;
    }
}

#pragma mark - Private

- (NSString *)generatedRequestId {
    return [NSString randomHexStringOfLength:kRequestIdLength];
}

+ (NSString *)HTTPMethodForMethod:(RequestMethod)method {
    NSString *string = nil;
    
    switch (method) {
        case RequestMethodGET:
            string = kHTTPMethodGET;
            break;
        case RequestMethodPOST:
            string = kHTTPMethodPOST;
            break;
        case RequestMethodPUT:
            string = kHTTPMethodPUT;
            break;
        case RequestMethodDELETE:
            string = kHTTPMethodDELETE;
            break;
        default:
            break;
    }
    
    return string;
}

@end
