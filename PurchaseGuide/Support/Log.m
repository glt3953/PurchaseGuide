//
//  Log.m
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "Log.h"

void LogWithLine(const char *filePath, int lineNumber, NSString *fmt, ...) {
    va_list args;
    va_start(args, fmt);
    
    NSString *string = [[NSString alloc] initWithFormat:fmt arguments:args];
    NSString *fileName = [@(filePath) lastPathComponent];
    printf("%s:%d %s\n", [fileName UTF8String], lineNumber, [string UTF8String]);
    va_end(args);
}
