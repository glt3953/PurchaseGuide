//
//  RequestFileData.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestFileData : NSObject

@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy, readonly) NSString *filePath;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *fileName;
@property (nonatomic, copy, readonly) NSString *mimeType;

+ (instancetype)fileDataWithData:(NSData *)data name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

+ (instancetype)fileDataWithFilePath:(NSString *)filePath name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType;

@end
