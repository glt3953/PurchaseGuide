//
//  URLValueTransformer.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 22/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "URLValueTransformer.h"

@implementation URLValueTransformer

- (instancetype)init {
  return [super initWitlock:^id(NSString *URLString) {
    return [NSURL URLWithString:URLString];
  }];
}

@end
