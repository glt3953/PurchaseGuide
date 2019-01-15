//
//  NumberValueTransformer
//  PodioKit
//
//  Created by Sebastian Rehnby on 16/05/14
//  Copyright (c) 2014 Citrix Systems, Inc. All rights reserved.
//

#import "NumberValueTransformer.h"
#import "NSNumber+Additions.h"


@implementation NumberValueTransformer

#pragma mark - NSValueTransformer

+ (BOOL)allowsReverseTransformation {
  return YES;
}

- (id)reverseTransformedValue:(id)value {
  if (![value isKindOfClass:[NSNumber class]]) {
       return nil;
  }

  return [(NSNumber *)value USNumberString];
}

- (id)transformedValue:(id)value {
  if (![value isKindOfClass:[NSString class]]) {
    return nil;
  }

  return [NSNumber numberFromUSNumberString:value];
}


@end