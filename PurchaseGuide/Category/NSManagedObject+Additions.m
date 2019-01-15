//
//  NSManagedObject+Additions.m
//  Room107Kit
//
//  Created by Sebastian Rehnby on 9/27/11.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import "NSManagedObject+Additions.h"

@implementation NSManagedObject (Additions)

+ (NSString *)entityName {
  // Default is class name
  return NSStringFromClass([self class]);
}

+ (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context {
  return [NSEntityDescription entityForName:[self entityName] inManagedObjectContext:context];
}

+ (id)createInContext:(NSManagedObjectContext *)context {
  return [[self alloc] initWithEntity:[self entityInContext:context] insertIntoManagedObjectContext:context];
}

@end
