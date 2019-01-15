//
//  TimeUtil.h
//  room107
//
//  Created by ningxia on 15/7/8.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject
//
+ (NSDate *)stringToDate:(NSString *)time;
+ (NSTimeInterval)timestampFromTimeString:(NSString *)timeString;

+ (NSString *)dateToString:(NSDate *)date;
+ (NSString *)dateToDateString:(NSDate *)date;
+ (NSString *)timeStringFromTimestamp:(NSTimeInterval)timestamp;
+ (NSString *)timeStringFromTimestamp:(NSTimeInterval)timestamp withDateFormat:(NSString *)dateFormat;
+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString *)getFormatDateStringForTodayWithDateFormat:(NSString *)dateFormat;
/**
 *  通过NSDate得到时间字符串
 *
 *  @param date 待转换的时间
 *
 *  @return 返回格式为"HH:mm"的字符串
 */
+ (NSString *)dateToTimeString:(NSDate *)date;

/**
 *  根据用户指定的日期格式将本地日期串转化成NSDate类型的日期
 *
 *  @param date 格式化的日期串
 *
 *  @param dateFormat 用户指定的日期格式
 *
 *  @return NSDate类型的日期
 */
+ (NSDate *)getDateFromFormatString:(NSString *)date withDateFormat:(NSString *)dateFormat;

/**
 *  根据用户指定的日期格式把NSDate时间转换成日期串
 *
 *  @param date 待转换时间
 *
 *  @param dateFormat 用户指定的日期格式
 *
 *  @return 字符串时间
 */
+ (NSString *)getFormatDateStringFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat;

/**
 *  根据日期差获取新的Date
 *
 *  @param oldDate 未计算前的Date
 *
 *  @param dateDifference Date差值，类型为字典型
 *
 *  @return 新的Date
 */
+ (NSDate *)getNewDateWithOldDate:(NSDate *)oldDate withDateDifference:(NSDictionary *)dateDifference;

// 通过当地时间得到UTC的时间
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate formatter:(NSString *)formatter;
+ (NSTimeInterval)getUTCFormateLocalTimeInterval:(NSString *)localDate;
+ (NSDate *)getUTCDateFromLocalDate:(NSString *)localDate withFormat:(NSString *)format;
// 通过UTC得到当地时间
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate formatter:(NSString *) formatter;
+ (NSDate *)getLocalDateFormateUTCDate:(NSString *)utcDate;
+ (NSUInteger)nowTime;                           //获取当前时间
+ (NSString *)titleTime:(NSUInteger) timeInterval;//主页TableView的title通过时间戳转化成人性标题时间

#pragma mark - 自定义时间显示格式
//将时间转换为自定义的格式，如“15秒前”、“25分钟前”
+ (NSString *)friendlyTimeFromString:(NSString *)datetime;
/**
 *  把字符串时间转化成友情字符串时间
 *
 *  @param time 
 *
 *  @return
 */
+ (NSString *)friendlyDateTimeFromDateTime:(NSString *)dateTime withFormat:(NSString *)format;
//将时间转换为自定义的格式，如“昨天 早上10:45”、“周一 中午12:31”
+ (NSString *)friendlyTimeFromDate:(NSDate *)date;
+ (NSString *)friendlyTimeFromTimestamp:(NSTimeInterval)timesptamp;
+ (NSString *)friendlyConversationsTimeFromDate:(NSDate *)date;
+ (NSDate *) dateWithServerString:(NSString *) datetime;
// 格式化为“Tue, 15 Nov 2014 12:45:26 GMT”
+ (NSString *)timeFromHttpDate:(NSDate *)date;

/**
 *  将本地时间串转化成UTC时间
 *
 *  @param datetime 本地时间串，时间格式为'yyyy-MM-dd HH:mm:ss'
 *
 *  @return NSDate类型的UTC时间
 */
+ (NSDate *)getUTCFormateLocalDate:(NSString *)datetime;

@end
