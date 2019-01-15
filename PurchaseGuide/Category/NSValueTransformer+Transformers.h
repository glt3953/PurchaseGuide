//
//  NSValueTransformer+Transformers.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 15/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BlockValueTransformer.h"
#import "ReversibleBlockValueTransformer.h"
#import "ModelValueTransformer.h"
#import "URLValueTransformer.h"
#import "ReferenceTypeValueTransformer.h"
#import "AppFieldTypeValueTransformer.h"
#import "DateValueTransformer.h"

@interface NSValueTransformer (Transformers)

+ (NSValueTransformer *)transformerWithBlock:(ValueTransformationBlock)block;
+ (NSValueTransformer *)transformerWithBlock:(ValueTransformationBlock)block reverseBlock:(ValueTransformationBlock)reverseBlock;
+ (NSValueTransformer *)transformerWithModelClass:(Class)modelClass;

+ (NSValueTransformer *)transformerWithDictionary:(NSDictionary *)dictionary;
+ (NSValueTransformer *)URLTransformer;
+ (NSValueTransformer *)dateValueTransformer;
+ (NSValueTransformer *)referenceTypeTransformer;
+ (NSValueTransformer *)appFieldTypeTransformer;
+ (NSValueTransformer *)numberValueTransformer;

@end
