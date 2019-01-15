//
//  ReversibleBlockValueTransformer.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 14/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "ReversibleBlockValueTransformer.h"

@interface ReversibleBlockValueTransformer ()

@property (nonatomic, copy) ValueTransformationBlock reverseBlock;

@end

@implementation ReversibleBlockValueTransformer

- (instancetype)init {
  return [self initWitlock:nil reverseBlock:nil];
}

- (instancetype)initWitlock:(ValueTransformationBlock)block reverseBlock:(ValueTransformationBlock)reverseBlock {
  self = [super initWitlock:block];
  if (!self) return nil;
  
  _reverseBlock = [reverseBlock copy];
  
  return self;
}

+ (instancetype)transformerWitlock:(ValueTransformationBlock)block reverseBlock:(ValueTransformationBlock)reverseBlock {
  return [[self alloc] initWitlock:block reverseBlock:reverseBlock];
}

#pragma mark - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
  return YES;
}

- (id)reverseTransformedValue:(id)value {
  return self.reverseBlock ? self.reverseBlock(value) : nil;
}

@end
