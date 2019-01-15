//
//  NSDate+Additions.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 08/05/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "NSDate+Additions.h"
#import "NSDateFormatter+Additions.h"

static NSDateFormatter *sUTCDateFormatter = nil;
static NSDateFormatter *sUTCDateTimeFormatter = nil;

@implementation NSDate (Additions)

#pragma mark - Public

+ (NSDate *)dateFromUTCDateString:(NSString *)dateString {
  return [[self UTCDateFormatter] dateFromString:dateString];
}

+ (NSDate *)dateFromUTCDateTimeString:(NSString *)dateTimeString {
  return [[self UTCDateTimeFormatter] dateFromString:dateTimeString];
}

- (NSString *)UTCDateString {
  return [[[self class] UTCDateFormatter] stringFromDate:self];
}

- (NSString *)UTCDateTimeString {
  return [[[self class] UTCDateTimeFormatter] stringFromDate:self];
}

#pragma mark - Private

+ (NSDateFormatter *)UTCDateFormatter {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sUTCDateFormatter = [NSDateFormatter UTCDateFormatter];
  });
  
  return sUTCDateFormatter;
}

+ (NSDateFormatter *)UTCDateTimeFormatter {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sUTCDateTimeFormatter = [NSDateFormatter UTCDateTimeFormatter];
  });
  
  return sUTCDateTimeFormatter;
}

@end
