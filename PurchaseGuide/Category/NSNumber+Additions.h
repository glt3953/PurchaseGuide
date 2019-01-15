//
//  NSNumber(Additions) 
//  PodioKit
//
//  Created by Sebastian Rehnby on 18/05/14
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSNumber (Additions)

+ (NSNumber *)numberFromUSNumberString:(NSString *)numberString;
- (NSString *)USNumberString;
//正整数判断
- (BOOL)isPureInt;

@end