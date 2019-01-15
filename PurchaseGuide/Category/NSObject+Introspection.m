//
//  NSObject+Introspection.m
//  PodioKit
//
//  Created by Sebastian Rehnby on 14/04/14.
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import <objc/runtime.h>
#import "NSObject+Introspection.h"

@implementation NSObject (Introspection)

+ (id)valueByPerformingSelectorWithName:(NSString *)selectorName {
  return [self valueByPerformingSelectorWithName:selectorName withObject:nil];
}

+ (id)valueByPerformingSelectorWithName:(NSString *)selectorName withObject:(id)object {
  id value = nil;
  
  SEL selector = NSSelectorFromString(selectorName);
  if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    value = [self performSelector:selector withObject:object];
#pragma clang diagnostic pop
  }
  
  return value;
}

@end
