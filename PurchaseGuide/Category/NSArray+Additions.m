//
//  NSArray+Additions.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 01/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSMutableArray *)mappedArrayWithBlock:(id (^)(id obj))block {
    NSParameterAssert(block);
    
    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:[self count]];
    for (id object in self) {
        id mappedObject = block(object);
        if (mappedObject) {
            [mutArray addObject:mappedObject];
        }
    }
    return mutArray;
}

- (NSMutableArray *)filteredArrayWithBlock:(BOOL (^)(id obj))block {
    NSParameterAssert(block);
    
    return [self mappedArrayWithBlock:^id(id obj) {
        return block(obj) ? obj : nil;
    }];
}

- (id)firstObjectPassingTest:(BOOL (^)(id obj))block {
    NSParameterAssert(block);
    
    __block id object = nil;
    [self enumerateObjectsUsingBlock:^(id currentObject, NSUInteger idx, BOOL *stop) {
        if (block(currentObject)) {
            object = currentObject;
            *stop = YES;
        }
    }];
    
    return object;
}

@end
