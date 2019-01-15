//
//  NSArray+Additions.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 01/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Additions)

- (NSMutableArray *)mappedArrayWithBlock:(id (^)(id obj))block;
- (NSMutableArray *)filteredArrayWithBlock:(BOOL (^)(id obj))block;
- (id)firstObjectPassingTest:(BOOL (^)(id obj))block;

@end
