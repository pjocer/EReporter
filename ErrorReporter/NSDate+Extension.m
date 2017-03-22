//
//  NSDate+Extension.m
//  MWProjectTemplate
//
//  Created by Ning.liu on 16/8/17.
//  Copyright © 2016年 Memebox. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
- (NSString *)timestamp{
    return [NSString stringWithFormat:@"%0.f", [self timeIntervalSince1970]];
}
+ (NSDate *)dateWithTimestamp:(NSString *)timestamp{
    return [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
}

/*获取日期（date_）对应的元素*/

- (NSInteger)second {
    return [NSDate ordinality:self ordinalitySign:NSCalendarUnitSecond];
}

- (NSInteger)minute {
    return [NSDate ordinality:self ordinalitySign:NSCalendarUnitMinute];
}

- (NSInteger)hour {
    return [NSDate ordinality:self ordinalitySign:NSCalendarUnitHour];
}

- (NSInteger)day {
    return [NSDate ordinality:self ordinalitySign:NSCalendarUnitDay];
}

- (NSInteger)month {
    return [NSDate ordinality:self ordinalitySign:NSCalendarUnitMonth];
}

- (NSInteger)year {
    return [NSDate ordinality:self ordinalitySign:NSCalendarUnitYear];
}

///*判断date_是否和当前日期在指定的范围之内*/

- (BOOL)isDateThisWeek {
    NSDate *start;
    
    NSTimeInterval extends;
    
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
                         startDate:&start
                          interval: &extends
                           forDate:today];
    
    if(!success) {
        return NO;
    }
    
    NSTimeInterval dateInSecs = [self timeIntervalSinceReferenceDate];
    
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs + extends)) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isDateThisMonth {
    NSDate *start;
    
    NSTimeInterval extends;
    
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitMonth
                         startDate: &start
                          interval: &extends
                           forDate:today];
    
    if(!success) return NO;
    
    NSTimeInterval dateInSecs = [self timeIntervalSinceReferenceDate];
    
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)) {
        return YES;
    }
    
    return NO;
    
}

- (BOOL)isDateThisYear {
    NSDate *start;
    
    NSTimeInterval extends;
    
    NSCalendar *cal=[NSCalendar autoupdatingCurrentCalendar];
    
    NSDate *today=[NSDate date];
    
    BOOL success= [cal rangeOfUnit:NSCalendarUnitYear
                         startDate: &start
                          interval: &extends
                           forDate:today];
    
    if(!success) {
        return NO;
    }
    
    NSTimeInterval dateInSecs = [self timeIntervalSinceReferenceDate];
    
    NSTimeInterval dayStartInSecs= [start timeIntervalSinceReferenceDate];
    
    if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)) {
        return YES;
    }
    
    return NO;
}

///*判断两个时间是否在指定的范围之内*/

- (BOOL)isSameYear:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit = NSCalendarUnitYear;
    
    NSDateComponents *fistComponets = [calendar components:unit fromDate: self];
    
    NSDateComponents *secondComponets = [calendar components: unit
                                         
                                                    fromDate: date];
    
    if ([fistComponets year] == [secondComponets year]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isSameMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit =NSCalendarUnitMonth |NSCalendarUnitYear;
    
    NSDateComponents *fistComponets = [calendar components:unit fromDate: self];
    
    NSDateComponents *secondComponets = [calendar components:unit
                                                    fromDate:date];
    
    if ([fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)isSameDay:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    int unit =NSCalendarUnitMonth|NSCalendarUnitYear|NSCalendarUnitDay;
    
    NSDateComponents *fistComponets = [calendar components:unit
                                                  fromDate: self];
    
    NSDateComponents *secondComponets = [calendar components:unit
                                                    fromDate:date];
    if ([fistComponets day] == [secondComponets day]
        && [fistComponets month] == [secondComponets month]
        && [fistComponets year] == [secondComponets year]) {
        return YES;
    }
    
    return NO;
}

/* 获取指定日期所在月的天数*/
- (NSUInteger)numberDaysInMonthOfDate {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSRange range = [calender rangeOfUnit:NSCalendarUnitDay
                                   inUnit: NSCalendarUnitMonth
                                  forDate: self];
    return range.length;
}

- (NSDate *)dataByAddingOffsetComponents:(NSDateComponents *)offsetComponents {
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateByAddingComponents:offsetComponents
                                              toDate:self
                                             options:0];
    return date;
}

/*获取指定日期所在的周对应的周开始时间和周结束时间*/
- (NSDate *)startDateOfWeek {
    double interval = 0;
    NSDate *start = nil;
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal setFirstWeekday:2];
    
    BOOL ok = [cal rangeOfUnit:NSCalendarUnitWeekOfMonth
                     startDate:&start
                      interval:&interval
                       forDate:self];
    if (ok) {
        return start;
    }
    return nil;
}

- (NSDate *)endDateOfWeek {
    double interval = 0;
    NSDate *end = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitWeekOfMonth
                           startDate:&end
                            interval:&interval
                             forDate:self];
    if (ok) {
        return [end dateByAddingTimeInterval:interval];
    }
    
    return nil;
}

/*获取指定日期所在的月对应的月开始时间和月结束时间*/
- (NSDate *)startDateOfMonth {
    double interval = 0;
    NSDate *beginningOfMonth = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitMonth
                           startDate:&beginningOfMonth
                            interval:&interval
                             forDate:self];
    if (ok) {
        return beginningOfMonth;
    }
    return nil;
}

- (NSDate *)endDateOfMonth {
    double interval = 0;
    NSDate *beginningOfMonth = nil;
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    BOOL ok = [gregorian rangeOfUnit:NSCalendarUnitMonth
                           startDate:&beginningOfMonth
                            interval:&interval
                             forDate:self];
    if (ok) {
        return [beginningOfMonth dateByAddingTimeInterval:interval];
    }
    
    return nil;
}


//+ (NSDate *)dateWithDays:(NSInteger)days sinceDate:(NSDate *)date;
- (NSDate *)dateByAddingDays:(NSInteger)days {
    return [self dateByAddingTimeInterval:SecondsOfDay*days];

}

//+ (NSString *)stringFromDate:(NSDate *)date Formate:(NSString *)formate;
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)time formate:(NSString *)formate {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return [date stringFromFormate:formate];
}

- (NSString *)stringFromFormate:(NSString *)formate {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    });
    [dateFormatter setDateFormat:formate];
    return [dateFormatter stringFromDate:self];
}

+ (NSString *)formatTimeString:(NSTimeInterval)time {
    
    NSString * timeString = @"";
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval cha = now - time;
    
    if (cha/3600 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num= [timeString intValue];
        
        if (num <= 1) {
            
            timeString = [NSString stringWithFormat:@"刚刚..."];
            
        }else{
            
            timeString = [NSString stringWithFormat:@"%@分钟前", timeString];
            
        }
        
    }
    
    if (cha/3600 > 1 && cha/86400 < 1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString = [NSString stringWithFormat:@"%@小时前", timeString];
        
    }
    
    if (cha/86400 > 1) {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        int num = [timeString intValue];
        
        if (num < 2) {
            
            timeString = [NSString stringWithFormat:@"昨天"];
            
        } else if (num == 2){
            
            timeString = [NSString stringWithFormat:@"前天"];
            
        } else if (num > 2 && num <7){
            
            timeString = [NSString stringWithFormat:@"%@天前", timeString];
            
        } else if (num >= 7 && num <= 10) {
            
            timeString = [NSString stringWithFormat:@"1周前"];
            
        } else if (num > 10){
            
            timeString = [NSString stringWithFormat:@"n天前"];
            
        }
        
    }
    return timeString;
}

+ (NSTimeInterval)timeIntervalFromString:(NSString *)timeString {
    return [NSDate timeIntervalFromString:timeString Formate:DEFAULT_TIME_FORMATE3];
}

+ (NSTimeInterval)timeIntervalFromString:(NSString *)timeString Formate:(NSString *)formate {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    });
    [dateFormatter setDateFormat:formate];
    return [[dateFormatter dateFromString:timeString] timeIntervalSince1970];
}


#pragma mark - 私有方法
+ (NSInteger)ordinality:(NSDate *)date_ ordinalitySign:(NSCalendarUnit)ordinalitySign_
{
    NSInteger ordinality = -1;
    if (ordinalitySign_ < NSCalendarUnitEra || ordinalitySign_ >NSCalendarUnitWeekdayOrdinal) {
        return ordinality;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:ordinalitySign_ fromDate:date_];
    
    switch (ordinalitySign_)
    {
        case NSCalendarUnitSecond:
            ordinality = [components second];
            break;
        case NSCalendarUnitMinute:
            ordinality = [components minute];
            break;
        case NSCalendarUnitHour:
            ordinality = [components hour];
            break;
        case NSCalendarUnitDay:
            ordinality = [components day];
            break;
        case NSCalendarUnitMonth:
            ordinality = [components month];
            break;
        case NSCalendarUnitYear:
            ordinality = [components year];
            break;
        default:
            break;
    }
    
    return ordinality;
}



@end
