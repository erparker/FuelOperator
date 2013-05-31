//
//  NSDate+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 5/31/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSDate *)startOfToday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
    
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    
    return [cal dateFromComponents:components];
}

+ (NSDate *)startOfTheWeekFromToday
{
    NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate startOfToday]];
    int currentWeekday = [weekdayComponents weekday]; //[1;7] ... 1 is sunday, 7 is saturday in gregorian calendar
    return [[NSDate startOfToday] dateByAddingTimeInterval:-60.0 * 60.0 * 24.0 * (currentWeekday - 1)];
}

+ (NSDate *)startOfNextWeekFromToday
{
    return [NSDate dateWithTimeInterval:60.0 * 60.0 * 24.0 * 7 sinceDate:[NSDate startOfTheWeekFromToday]];
}

+ (NSDate *)dateWithNumberOfDays:(NSInteger)days sinceDate:(NSDate*)date
{
    return [NSDate dateWithTimeInterval:60.0*60.0*24.0*days sinceDate:date];
}

@end
