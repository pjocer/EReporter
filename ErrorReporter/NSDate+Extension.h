//
//  NSDate-Extension.h
//  MWProjectTemplate
//
//  Created by Ning.liu on 16/8/17.
//  Copyright © 2016年 Memebox. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SecondsOfDay 24*60*60
#define SecondsOfHour 60*60

@interface NSDate (Extension)
/**
 *  返回Unix时间戳
 *
 *  @return 
 */
- (NSString *)timestamp;

/**
 根据时间戳返回date

 @param timestamp 时间戳

 @return date
 */
+ (NSDate *)dateWithTimestamp:(NSString *)timestamp;

/*获取日期（date_）对应的元素*/

- (NSInteger)second;

- (NSInteger)minute;

- (NSInteger)hour;

- (NSInteger)day;

- (NSInteger)month;

- (NSInteger)year;

/*判断date_是否和当前日期在指定的范围之内*/

- (BOOL)isDateThisWeek;

- (BOOL)isDateThisMonth;

- (BOOL)isDateThisYear;

/*判断两个时间是否在指定的范围之内*/

- (BOOL)isSameYear:(NSDate *)date;

- (BOOL)isSameMonth:(NSDate *)date;

- (BOOL)isSameDay:(NSDate *)date;

/* 获取指定日期所在月的天数*/
- (NSUInteger)numberDaysInMonthOfDate;

//+ (NSDate *)dateByAddingComponents:(NSDate *)date_
//                  offsetComponents:(NSDateComponents *)offsetComponents_;
- (NSDate *)dataByAddingOffsetComponents:(NSDateComponents *)offsetComponents;

/*获取指定日期所在的周对应的周开始时间和周结束时间*/
- (NSDate *)startDateOfWeek;
- (NSDate *)endDateOfWeek;

/*获取指定日期所在的月对应的月开始时间和月结束时间*/
- (NSDate *)startDateOfMonth;
- (NSDate *)endDateOfMonth;


//+ (NSDate *)dateWithDays:(NSInteger)days sinceDate:(NSDate *)date;
- (NSDate *)dateByAddingDays:(NSInteger)days;

#define DEFAULT_TIME_FORMATE @"yyyy-MM-dd"
#define DEFAULT_TIME_FORMATE2 @"yyyy-MM-dd HH:mm"
#define DEFAULT_TIME_FORMATE3 @"yyyy-MM-dd HH:mm:ss"
#define DEFAULT_TIME_FORMATE4 @"yyyy.MM.dd HH:mm"

/**
 根据距1970的秒数返回格式化时间
 */

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)time formate:(NSString *)formate;
- (NSString *)stringFromFormate:(NSString *)formate;

+ (NSString *)formatTimeString:(NSTimeInterval)time;

+ (NSTimeInterval)timeIntervalFromString:(NSString *)timeString;

+ (NSTimeInterval)timeIntervalFromString:(NSString *)timeString Formate:(NSString *)formate;

@end
