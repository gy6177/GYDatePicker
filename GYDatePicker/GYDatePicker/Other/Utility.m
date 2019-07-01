//
//  Utility.m
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import "Utility.h"

@implementation Utility

//每月总天数
+(NSInteger)getNumberOfDaysInMonth:(NSString *)dateString
{
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy年MM月"];
    NSDate *date = [dateformatter dateFromString:dateString];
    
    NSCalendar*calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSUInteger numberOfDaysInMonth = range.length;
    
    return numberOfDaysInMonth;
}

+(NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * comp = [calendar components:NSCalendarUnitDay
                                          fromDate:fromDate
                                            toDate:toDate
                                           options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.day;
}

+(NSInteger)numberOfMonthsWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * comp = [calendar components:NSCalendarUnitMonth
                                          fromDate:fromDate
                                            toDate:toDate
                                           options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.month;
}

+(NSInteger)numberOfYearsWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents * comp = [calendar components:NSCalendarUnitYear
                                          fromDate:fromDate
                                            toDate:toDate
                                           options:NSCalendarWrapComponents];
    NSLog(@" -- >>  comp : %@  << --",comp);
    return comp.year;
}

//获取当前时
+(NSInteger )getCurrentHour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger hour = [dateComponent hour];
    
    return hour;
}

//获取当前分钟
+(NSInteger )getCurrentMinute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMinute;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSInteger minute = [dateComponent minute];
    
    return minute;
}

//获取某年
+(NSInteger )getCurrentYear:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    NSInteger year = [dateComponent year];
    
    return year;
}

//获取某个月
+(NSInteger )getCurrentMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    NSInteger month = [dateComponent month];
    
    return month;
}

//获取某天
+(NSInteger )getCurrentDay:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    
    NSInteger day = [dateComponent day];
    
    return day;
}



//获取距现在六个月的日期 包含本月
+(NSDate *)getDateSixMonthsFromNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 0;
    dayComponent.month = -6;
    NSDate *nowDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    return nowDate;
}

//获取距现在六个月的日期 包含本月
+(NSDate *)getDateSixMonthsToNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 0;
    dayComponent.month = 6;
    NSDate *nowDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    
    return nowDate;
}


//获取距现在之前第六个月的日期
-(NSString *)getSixMonthsFromNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 0;
    dayComponent.month = -6;
    NSDate *nowDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:nowDate];
    
    return dateString;
}

//获取距现在之后的第六个月的日期
+(NSString *)getSixMonthsToNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 0;
    dayComponent.month = 6;
    NSDate *nowDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:nowDate];
    
    return dateString;
}

//获取当前的日期 2016-01-01 12:12
+(NSString *)getCurrentDateSecond
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *  locationString=[dateFormatter stringFromDate:senddate];
    return locationString;
    
}


@end
