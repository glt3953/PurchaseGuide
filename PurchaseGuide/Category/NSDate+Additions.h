//
//  NSDate+Additions.h
//  PodioKit
//
//  Created by Sebastian Rehnby on 08/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Additions)

+ (NSDate *)dateFromUTCDateString:(NSString *)dateString;
+ (NSDate *)dateFromUTCDateTimeString:(NSString *)dateTimeString;

- (NSString *)UTCDateString;
- (NSString *)UTCDateTimeString;

@end
