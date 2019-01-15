//
//  NSString+IsPureNumer.h
//  room107
//
//  Created by 107间 on 15/11/20.
//  Copyright © 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (IsPureNumer)
+ (BOOL)isPureInt:(NSString *)string;
+ (BOOL)isPureFloat:(NSString *)string;
@end
