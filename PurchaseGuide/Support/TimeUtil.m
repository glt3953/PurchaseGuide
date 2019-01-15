//
//  TimeUtil.m
//  room107
//
//  Created by ningxia on 15/7/8.
//  Copyright (c) 2015年 107room. All rights reserved.
//

#import "TimeUtil.h"

#define SECONDS_PER_DAY 60 * 60 * 24

@implementation TimeUtil

+ (NSDate *)stringToDate:(NSString *)strdate{
    NSString * timeFormatter = nil;
    if (strdate.length == 27) {
        timeFormatter = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'";
    } else if (strdate.length == 20) {
        timeFormatter = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    }else {
        timeFormatter = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:timeFormatter];
    //    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    //    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *anyDate = [dateFormatter dateFromString:strdate];
    
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}

+ (NSTimeInterval)timestampFromTimeString:(NSString *)timeString {
    return [[self stringToDate:timeString] timeIntervalSince1970];
}

+ (NSString *)dateToString:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

//根据用户指定的日期格式将本地日期串转化成NSDate类型的日期
+ (NSDate *)getDateFromFormatString:(NSString *)date withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:dateFormat];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate * dateTransformed = [dateFormatter dateFromString:date];
    
    return dateTransformed;
}

//根据用户指定的日期格式把NSDate时间转换成日期串
+ (NSString *)getFormatDateStringFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    
    NSString * strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

+ (NSString *)getFormatDateStringForTodayWithDateFormat:(NSString *)dateFormat {
    return [self getFormatDateStringFromDate:[NSDate date] withDateFormat:dateFormat];
}

//根据日期差获取新的日期
+ (NSDate *)getNewDateWithOldDate:(NSDate *)oldDate withDateDifference:(NSDictionary *)dateDifference
{
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * adcomps = [[NSDateComponents alloc] init];
    [adcomps setYear:[dateDifference[@"years"] integerValue]];
    [adcomps setMonth:[dateDifference[@"months"] integerValue]];
    [adcomps setDay:[dateDifference[@"days"] integerValue]];
    [adcomps setHour:[dateDifference[@"hours"] integerValue]];
    [adcomps setMinute:[dateDifference[@"minutes"] integerValue]];
    [adcomps setSecond:[dateDifference[@"seconds"] integerValue]];
    
    NSDate * newDate = [calendar dateByAddingComponents:adcomps toDate:oldDate options:0];
    
    return newDate;
}

+ (NSString *)dateToDateString:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    
    time_t current_time = [self getTodayZeroTime];
    
    time_t this_time = [date timeIntervalSince1970];
    
    time_t delta = current_time - this_time;
    
    NSString * format = nil;
    struct tm tm_now, tm_in;
    localtime_r(&current_time, &tm_now);
    localtime_r(&this_time, &tm_in);
    
    if (tm_now.tm_year == tm_in.tm_year) {
        if (delta <= 0 ) {
            //今天
            format = @"今天";
        } else if (delta > 0 && delta <= SECONDS_PER_DAY) {
            //昨天
            format = @"昨天";
        } else if (delta > SECONDS_PER_DAY) {
            format = @"%-m月%-d日 ";
        }
    } else {
        format = @"%Y年%-m月%-d日 ";
    }
    
    char buf[256] = {0};
    strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
    return [NSString stringWithUTF8String:buf];
}

+(time_t)getTodayZeroTime {
    NSDate * current_date = [NSDate date];
    
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSChineseCalendar];
    [gregorian setTimeZone:zone];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: current_date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    return [[gregorian dateFromComponents: components]timeIntervalSince1970];//获取今天零时
}

+ (NSString *)timeStringFromTimestamp:(NSTimeInterval)timestamp {
    return [self dateToString:[NSDate dateWithTimeIntervalSince1970:timestamp]];
}

+ (NSString *)timeStringFromTimestamp:(NSTimeInterval)timestamp withDateFormat:(NSString *)dateFormat {
    return [self getFormatDateStringFromDate:[NSDate dateWithTimeIntervalSince1970:timestamp] withDateFormat:dateFormat];
}

+ (NSDateComponents *)componetsWithTimeInterval:(NSTimeInterval)timeInterval{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];
    
    unsigned int unitFlags =
    NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit |
    NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    
    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString *)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval{
    NSDateComponents *components = [self.class componetsWithTimeInterval:timeInterval];
    
    if (components.hour > 0){
        return [NSString stringWithFormat:@"%zd:%02zd:%02zd", components.hour, components.minute, components.second];
    }else{
        return [NSString stringWithFormat:@"%zd:%02zd", components.minute, components.second];
    }
}

+ (NSString *)dateToTimeString:(NSDate *)date {
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSTimeZone * timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    
    NSString * strTime = [dateFormatter stringFromDate:date];
    return strTime;
}

//将本地日期字符串转为UTC日期字符串
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate formatter:(NSString *) formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:formatter];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

//将本地日期字符串转为UTC日期字符串
+ (NSDate *)getUTCDateFromLocalDate:(NSString *)localDate withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:format];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    
    return dateFormatted;
}

//将本地日期字符串转为UTC日期字符串
+ (NSTimeInterval)getUTCFormateLocalTimeInterval:(NSString *)localDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    
    return [dateFormatted timeIntervalSince1970];
}

//将UTC日期字符串转为本地时间字符串
//输入的UTC日期格式2013-08-03T04:53:51+0000
+(NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate formatter:(NSString *) formatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:formatter];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

+ (NSDate *)getLocalDateFormateUTCDate:(NSString *)utcDate{
    // 2014-01-16T10:03:29.000000Z
    NSString * timeFormatter = nil;
    if ([utcDate hasSuffix:@"Z"]) {
        // 2014-03-10T08:00:37.373465Z
        timeFormatter = @"yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'";
    }else{
        timeFormatter = @"yyyy-MM-dd HH:mm:ss";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:timeFormatter];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:timeFormatter];
    
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return [dateFormatter dateFromString:dateString];
}

#pragma mark - 获取当前零点时间戳
+ (NSUInteger) nowZeroDayTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSString *zeroDay = [dateFormatter stringFromDate:date];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter1.timeZone = [NSTimeZone systemTimeZone];
    NSDate *nowDate = [dateFormatter1 dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",zeroDay]];
    
    NSUInteger interval = [nowDate timeIntervalSince1970];
    
    //    LogDebug(@"--+++%d  %@",interval,zeroDay);
    return interval;
}

#pragma mark - 获取当前时间的时间戳
+(NSUInteger) nowTime {
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    NSDate * date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now =[date timeIntervalSince1970];
    NSUInteger interval = now;
    return interval;
}

#pragma mark - 主页TableView的title通过时间戳转化成人性标题时间
+ (NSString *) titleTime:(NSUInteger) timeInterval
{
    if (timeInterval > [self nowZeroDayTime]) {
        return LocalizedString(@"Today");
    }else if(timeInterval  + 24 * 60 * 60 > [self nowZeroDayTime]){
        return LocalizedString(@"Yesterday");
    }
    //获得日期
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter* dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=[NSString stringWithFormat:@"yyyy%@MM%@dd%@",LocalizedString(@"Year"),LocalizedString(@"Moon"),LocalizedString(@"Day")];
    dateFormatter.dateFormat=[NSString stringWithFormat:@"yyyy%@MM%@dd%@",LocalizedString(@"Year"),LocalizedString(@"Moon"),LocalizedString(@"Day")];
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    return [dateFormatter stringFromDate:date];
}


#pragma mark - 自定义时间显示格式
+ (NSString *)friendlyTimeFromString:(NSString *)datetime
{
    time_t current_time = time(NULL);
    
    NSDateFormatter *dateFormatter =nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    }
    
    NSDate *date = [dateFormatter dateFromString:datetime];
    
    time_t this_time = [date timeIntervalSince1970];
    
    time_t delta = current_time - this_time;
    
    if (delta <= 0) {
        return @"刚刚";
    }
    else if (delta <60) {
        return [NSString stringWithFormat:@"%ld秒前", delta];
    } else if (delta <3600) {
        return [NSString stringWithFormat:@"%ld分钟前", delta /60];
    } else {
        struct tm tm_now, tm_in;
        localtime_r(&current_time, &tm_now);
        localtime_r(&this_time, &tm_in);
        NSString *format = nil;
        
        if (tm_now.tm_year == tm_in.tm_year) {
            if (tm_now.tm_yday == tm_in.tm_yday)
                format = @"今天 %-H:%M";
            else
                format = @"%-m月%-d日 %-H:%M";
        }
        else
            format = @"%Y年%-m月%-d日 %-H:%M";
        
        char buf[256] = {0};
        strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
        return [NSString stringWithUTF8String:buf];
    }
}

+ (NSString *)friendlyTimeFromTimestamp:(NSTimeInterval)timesptamp
{
    time_t current_time = time(NULL);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timesptamp];
    
    time_t this_time = [date timeIntervalSince1970];
    
    time_t delta = current_time - this_time;
    
    if (delta <= 0) {
        return @"刚刚";
    }
    else if (delta < 60) {
        return [NSString stringWithFormat:@"%ld秒前", delta];
    } else if (delta < 3600) {
        return [NSString stringWithFormat:@"%ld分钟前", delta /60];
    } else {
        struct tm tm_now, tm_in;
        localtime_r(&current_time, &tm_now);
        localtime_r(&this_time, &tm_in);
        NSString *format = nil;
        
        if (tm_now.tm_year == tm_in.tm_year) {
            if (tm_now.tm_yday == tm_in.tm_yday)
                return @"今天";
            else if (tm_now.tm_yday == (tm_in.tm_yday + 1))
            {   return @"昨天";
            }
            else
                format = @"%-m月%-d日";
        }
        else
            format = @"%Y年%-m月%-d日";
        
        char buf[256] = {0};
        strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
        return [NSString stringWithUTF8String:buf];
    }
}

+ (NSString *)friendlyDateTimeFromDateTime:(NSString *)dateTime withFormat:(NSString *)format {
//    return [self friendlyTimeFromDate:[self getUTCFormateLocalDate:time]];
    if (!dateTime) {
        return @"";
    }
    
    time_t current_time = time(NULL);
    
    NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:(dateTime.length == 8) ? @"yyyyMMdd" : @"yyyyMMddHHmmss"];
        dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    }
    
    NSDate *date = [dateFormatter dateFromString:dateTime];
    time_t this_time = [date timeIntervalSince1970];
    struct tm tm_now, tm_in;
    localtime_r(&current_time, &tm_now);
    localtime_r(&this_time, &tm_in);
    
    char buf[256] = {0};
    strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
    return [NSString stringWithUTF8String:buf];
}

/**
 * 计算指定时间与当前的时间差
 * @param date 某一指定时间
 * @return 指定格式的时间串，如
 今天内1小时内：刚刚（1分钟内）、1分钟前、59分钟前 ——1 minute ago, 59 minutes ago
 今天内超过1小时：今天 11:12      ——11:12
 昨天内：昨天 11:12 ——Yesterday 11:12
 今年内：8月9日 11:12 ——   08/09 11:12
 今年之前：2012年12月13日 20:42 ——12/13/2012 20:42
 */
+ (NSString *)friendlyTimeFromDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    
    NSDate *current_date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSChineseCalendar];
    [gregorian setTimeZone:zone];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: current_date];
    [components setHour: 0];
    [components setMinute:0];
    [components setSecond: 0];
    NSDate *zeroDate = [gregorian dateFromComponents: components];//获取今天零时
    
    time_t current_time = [zeroDate timeIntervalSince1970];
    time_t this_time = [date timeIntervalSince1970];
    time_t delta = current_time - this_time;
    
    NSString * format = nil;
    NSString * timeFormat = @"%H:%M";
    struct tm tm_now, tm_in;
    localtime_r(&current_time, &tm_now);
    localtime_r(&this_time, &tm_in);
    
    if (tm_now.tm_year == tm_in.tm_year) {
        if (delta <= 0 ) {
            //今天
            NSTimeInterval timeInterval = [date timeIntervalSinceNow];
            timeInterval = -timeInterval;
            long temp = 0;
            if (timeInterval <= 60) {
                format = [NSString stringWithFormat:lang(@"1MinuteAgo")];
            } else if ((temp = timeInterval / 60) < 60){
                if ((temp = timeInterval / 60) == 1) {
                    format = [NSString stringWithFormat:lang(@"1MinuteAgo")];
                } else {
                    format = [NSString stringWithFormat:@"%ld%@", temp, lang(@"MinutesAgo")];
                }
            } else {
                format = [[NSString stringWithFormat:@"%@ ", lang(@"Today")] stringByAppendingString:timeFormat ? timeFormat : @""];
            }
        } else if (delta > 0 && delta <= SECONDS_PER_DAY) {
            //昨天
            format = [[NSString stringWithFormat:@"%@ ", lang(@"Yesterday")] stringByAppendingString:timeFormat ? timeFormat : @""];
        } else if (delta > SECONDS_PER_DAY) {
            //今年内
            format = [[NSString stringWithFormat:@"%@ ", lang(@"ThisYearFormat")] stringByAppendingString:timeFormat ? timeFormat : @""];
        }
    } else {
        //往年
        format = [[NSString stringWithFormat:@"%@ ", lang(@"PreviousYearsFormat")] stringByAppendingString:timeFormat ? timeFormat : @""];
    }
    
    char buf[256] = {0};
    strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
    return [NSString stringWithUTF8String:buf];
}

+ (NSString *)friendlyConversationsTimeFromDate:(NSDate *)date
{
    if (!date) {
        return @"";
    }
    
    if (!date) {
        return @"";
    }
    
    time_t current_time = [self getTodayZeroTime];
    
    time_t this_time = [date timeIntervalSince1970];
    
    time_t delta = current_time - this_time;
    
    NSString * format = nil;
    struct tm tm_now, tm_in;
    localtime_r(&current_time, &tm_now);
    localtime_r(&this_time, &tm_in);
    
    if (tm_now.tm_year == tm_in.tm_year) {
        if (delta <= 0 ) {
            //今天
            format = @"今天 ";
            format = [format stringByAppendingString:@"%H:%M"];
        } else if (delta > 0 && delta <= SECONDS_PER_DAY) {
            //昨天
            format = @"昨天 ";
            format = [format stringByAppendingString:@"%H:%M"];
        } else if (delta > SECONDS_PER_DAY) {
            format = @"%-m月%-d日 ";
        }
    } else {
        format = @"%Y年%-m月%-d日 ";
    }
    
    
    char buf[256] = {0};
    strftime(buf, sizeof(buf), [format UTF8String], &tm_in);
    return [NSString stringWithUTF8String:buf];
}

+ (NSDate *)dateWithServerString:(NSString *)datetime
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    return [formatter dateFromString:datetime];
}

+(NSString *)timeFromHttpDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Tue, 15 Nov 2014 12:45:26 GMT
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss 'GMT'"];
    NSString *strDate = [dateFormatter stringFromDate:date];
    return strDate;
}

//将本地日期字符串转为UTC日期字符串
+ (NSDate *)getUTCFormateLocalDate:(NSString *)localDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    
    return dateFormatted;
}

@end
