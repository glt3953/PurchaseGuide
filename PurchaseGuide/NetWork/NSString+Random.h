//
//  NSString+PKRandom.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 12/5/12.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Random)

+ (instancetype)randomHexStringOfLength:(NSUInteger)length;

@end
