//
//  DateValueTransformer.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 02/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "DateValueTransformer.h"
#import "NSDate+Additions.h"

@implementation DateValueTransformer

- (instancetype)init {
  return [super initWitlock:^id(NSString *dateString) {
    return [NSDate dateFromUTCDateTimeString:dateString];
  } reverseBlock:^id(NSDate *date) {
    return [date UTCDateTimeString];
  }];
}

@end
