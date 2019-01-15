//
//  ReversibleBlockValueTransformer.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 14/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "BlockValueTransformer.h"

@interface ReversibleBlockValueTransformer : BlockValueTransformer

- (instancetype)initWitlock:(ValueTransformationBlock)block reverseBlock:(ValueTransformationBlock)reverseBlock;

+ (instancetype)transformerWitlock:(ValueTransformationBlock)block reverseBlock:(ValueTransformationBlock)reverseBlock;

@end
