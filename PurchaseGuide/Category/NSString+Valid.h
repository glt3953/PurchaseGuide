//
//  NSString+Valid.h
//  room107
//
//  Created by ningxia on 15/8/27.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Valid)

- (BOOL)isEmpty;
- (NSArray *)getComponentsBySeparatedString:(NSString *)separator;
- (NSString *)firstStringBySeparatedString:(NSString *)separator;

@end
