//
//  BlockValueTransformer.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 14/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "BlockValueTransformer.h"

@interface BlockValueTransformer ()

@property (nonatomic, copy) ValueTransformationBlock transformBlock;

@end

@implementation BlockValueTransformer

- (instancetype)init {
  return [self initWitlock:nil];
}

- (instancetype)initWitlock:(ValueTransformationBlock)block {
  self = [super init];
  if (!self) return nil;
  
  _transformBlock = [block copy];
  
  return self;
}

+ (instancetype)transformerWitlock:(ValueTransformationBlock)block {
  return [[self alloc] initWitlock:block];
}

#pragma mark - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
  return NO;
}

- (id)transformedValue:(id)value {
  return self.transformBlock ? self.transformBlock(value) : nil;
}

@end
