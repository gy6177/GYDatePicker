//
//  Utility.h
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Utility : NSObject

//每月总天数
+(NSInteger)getNumberOfDaysInMonth:(NSString *)dateString;

+(NSInteger)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

+(NSInteger)numberOfMonthsWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

+(NSInteger)numberOfYearsWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
//获取当前时
+(NSInteger )getCurrentHour;

//获取当前分钟
+(NSInteger )getCurrentMinute;

//获取某年
+(NSInteger )getCurrentYear:(NSDate *)date;

//获取某个月
+(NSInteger )getCurrentMonth:(NSDate *)date;

//获取某天
+(NSInteger )getCurrentDay:(NSDate *)date;



//获取距现在六个月的日期 包含本月
+(NSDate *)getDateSixMonthsFromNow;

//获取距现在之后的第六个月的日期 包含本月
+(NSDate *)getDateSixMonthsToNow;


//获取距现在之前第六个月的日期
-(NSString *)getSixMonthsFromNow;

//获取距现在之后的第六个月的日期
+(NSString *)getSixMonthsToNow;

//获取当前的日期 2016-01-01 12:12
+(NSString *)getCurrentDateSecond;

@end

NS_ASSUME_NONNULL_END
