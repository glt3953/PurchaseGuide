//
//  ModelValueTransformer.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 15/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelValueTransformer : NSValueTransformer

- (instancetype)initWithModelClass:(Class)modelClass;

+ (instancetype)transformerWithModelClass:(Class)modelClass;

@end
