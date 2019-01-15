//
//  BlockValueTransformer.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 14/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^ValueTransformationBlock) (id value);

@interface BlockValueTransformer : NSValueTransformer

- (instancetype)initWitlock:(ValueTransformationBlock)block;

+ (instancetype)transformerWitlock:(ValueTransformationBlock)block;

@end
