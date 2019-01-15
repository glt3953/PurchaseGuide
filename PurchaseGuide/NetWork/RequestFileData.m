//
//  RequestFileData.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "RequestFileData.h"

@implementation RequestFileData

- (instancetype)initWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    self = [super init];
    if (!self) return nil;
    
    _data = data;
    _name = [name copy];
    _fileName = [fileName copy];
    _mimeType = [mimeType copy];
    
    return self;
}

- (instancetype)initWithFilePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    self = [super init];
    if (!self) return nil;
    
    _filePath = [filePath copy];
    _name = [name copy];
    _fileName = [fileName copy];
    _mimeType = [mimeType copy];
    
    return self;
}

+ (instancetype)fileDataWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    return [[self alloc] initWithData:data name:name fileName:fileName mimeType:mimeType];
}

+ (instancetype)fileDataWithFilePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType {
    return [[self alloc] initWithFilePath:filePath name:name fileName:fileName mimeType:mimeType];
}

@end
