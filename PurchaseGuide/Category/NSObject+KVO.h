//
//  NSObject+KVO.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KVO) <NSCoding, NSCopying>

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)updateFromDictionary:(NSDictionary *)dictionary;

// Override in subclass to define how to map
+ (NSDictionary *)dictionaryKeyPathsForPropertyNames;

@end
