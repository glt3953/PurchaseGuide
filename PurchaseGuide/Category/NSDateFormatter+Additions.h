//
//  NSDateFormatter+Additions.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 02/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Additions)

+ (NSDateFormatter *)UTCDateFormatter;
+ (NSDateFormatter *)UTCDateTimeFormatter;

@end
