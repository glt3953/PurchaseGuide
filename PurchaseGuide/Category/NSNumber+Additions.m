//
//  NSNumber(Additions)
//  PodioKit
//
//  Created by Sebastian Rehnby on 18/05/14
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//


#import "NSNumber+Additions.h"
#import "NSNumberFormatter+Additions.h"

static NSNumberFormatter *sNumberFormatter = nil;

@implementation NSNumber (Additions)

+ (NSNumber *)numberFromUSNumberString:(NSString *)numberString {
    return [[self USNumberFormatter] numberFromString:[numberString isEqualToString:@""] ? @"0" : numberString];
}

- (NSString *)USNumberString {
  return [[[self class] USNumberFormatter] stringFromNumber:self];
}

+ (NSNumberFormatter *)USNumberFormatter {
  if (!sNumberFormatter) {
    sNumberFormatter = [NSNumberFormatter USNumberFormatter];
  }

  return sNumberFormatter;
}

- (BOOL)isPureInt {
    BOOL isInt = YES;
    if (strcmp([self objCType], @encode(double)) == 0) {
        isInt = NO;
    } else if (strcmp([self objCType], @encode(float)) == 0) {
        isInt = NO;
    }
    
    return isInt;
}

@end