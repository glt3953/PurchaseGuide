//
//  NSValueTransformer+Transformers.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 15/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "NSValueTransformer+Transformers.h"
#import "Constants.h"
#import "NumberValueTransformer.h"

@implementation NSValueTransformer (Transformers)

+ (NSValueTransformer *)transformerWithBlock:(ValueTransformationBlock)block {
  return [BlockValueTransformer transformerWithBlock:block];
}

+ (NSValueTransformer *)transformerWithBlock:(ValueTransformationBlock)block reverseBlock:(ValueTransformationBlock)reverseBlock {
  return [ReversibleBlockValueTransformer transformerWithBlock:block reverseBlock:reverseBlock];
}

+ (NSValueTransformer *)transformerWithModelClass:(Class)modelClass {
  return [ModelValueTransformer transformerWithModelClass:modelClass];
}

+ (NSValueTransformer *)transformerWithDictionary:(NSDictionary *)dictionary {
  return [DictionaryMappingValueTransformer transformerWithDictionary:dictionary];
}

+ (NSValueTransformer *)URLTransformer {
  return [URLValueTransformer new];
}

+ (NSValueTransformer *)dateValueTransformer {
  return [DateValueTransformer new];
}

+ (NSValueTransformer *)referenceTypeTransformer {
  return [ReferenceTypeValueTransformer new];
}

+ (NSValueTransformer *)appFieldTypeTransformer {
  return [AppFieldTypeValueTransformer new];
}

+ (NSValueTransformer *)numberValueTransformer {
  return [NumberValueTransformer new];
}
@end
