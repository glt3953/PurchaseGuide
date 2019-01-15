//
//  NSManagedObject+Additions.h
//  Room107Kit
//
//  Created by Sebastian Rehnby on 9/27/11.
//  Copyright (c) 2012 Citrix Systems, Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Additions)

+ (NSString *)entityName;

+ (NSEntityDescription *)entityInContext:(NSManagedObjectContext *)context;

+ (id)createInContext:(NSManagedObjectContext *)context;

@end
