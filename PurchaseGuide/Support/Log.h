//
//  Log.h
//  room107
//
//  Created by ningxia on 15/6/18.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

void LogWithLine(const char *filePath, int lineNumber, NSString *fmt, ...);

#define Log(fmt...) LogWithLine(__FILE__, __LINE__, fmt)

// Log levels
#ifdef DEBUG
#define LOG_LEVEL_DEBUG
#endif

#define LOG_LEVEL_INFO
#define LOG_LEVEL_WARNING
#define LOG_LEVEL_ERROR

#ifdef LOG_LEVEL_DEBUG
#define LogDebug(fmt...) Log(@"DEBUG: " fmt)
#else
#define LogDebug(fmt...)
#endif

#ifdef LOG_LEVEL_INFO
#define LogInfo(fmt...) Log(@"INFO: " fmt)
#else
#define LogInfo(fmt...)
#endif

#ifdef LOG_LEVEL_WARNING
#define LogWarn(fmt...) Log(@"WARNING: " fmt)
#else
#define LogWarn(fmt...)
#endif

#ifdef LOG_LEVEL_ERROR
#define LogError(fmt...) Log(@"ERROR: " fmt)
#else
#define LogError(fmt...)
#endif

#define LogRect(rect) Log(NSStringFromCGRect(rect))
#define LogSize(size) Log(NSStringFromCGSize(size))
#define LogInsets(insets) Log(NSStringFromUIEdgeInsets(insets))
