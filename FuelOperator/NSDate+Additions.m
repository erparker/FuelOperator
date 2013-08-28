//
//  NSDate+Additions.m
//  FuelOperator
//
//  Created by Gary Robinson on 5/31/13.
//  Copyright (c) 2013 GaryRobinson. All rights reserved.
//

#import "NSDate+Additions.h"

@implementation NSDate (Additions)

+ (NSTimeInterval)secondsPerDay
{
    return 60 * 60 * 24;
}

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
    return [[NSDate startOfToday] dateByAddingTimeInterval:(-1 * [NSDate secondsPerDay] * (currentWeekday - 1))];
}

+ (NSDate *)startOfNextWeekFromToday
{
    return [NSDate dateWithTimeInterval:([NSDate secondsPerDay] * 7) sinceDate:[NSDate startOfTheWeekFromToday]];
}

+ (NSDate *)dateWithNumberOfDays:(NSInteger)days sinceDate:(NSDate*)date
{
    return [NSDate dateWithTimeInterval:([NSDate secondsPerDay]*days) sinceDate:date];
}

+ (NSDate*) getDateFromJSON:(NSString *)dateString
{
    // Expect date in this format "/Date(1268123281843)/"
    int startPos = [dateString rangeOfString:@"("].location+1;
    int endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos,endPos-startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSLog(@"%llu",milliseconds);
    NSTimeInterval interval = milliseconds/1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

@end
