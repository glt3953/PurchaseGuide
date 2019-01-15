//
//  DictionaryMappingValueTransformer.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 22/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryMappingValueTransformer : NSValueTransformer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)transformerWithDictionary:(NSDictionary *)dictionary;

@end
