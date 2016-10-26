//
//  NSDate+Addition.m
//  LBDate
//
//  Created by FSLB on 16/7/5.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import "NSDate+Addition.h"

@implementation NSDate (Addition)

+ (NSInteger) getCurrentYear{
    
    NSDateComponents * dateComponent = [self getCurrentDateComponents];
    
    NSInteger year = [dateComponent year];
    
    return year;
    
}
+ (NSInteger) getCurrentMonth{
    
    NSDateComponents * dateComponent = [self getCurrentDateComponents];
    
    NSInteger month = [dateComponent month];
    
    return month;
}

+ (NSInteger) getCurrentHours{
    
    NSDateComponents * dateComponent = [self getCurrentDateComponents];
    
    NSInteger month = [dateComponent month];
    
    return month;
}



+ (NSDateComponents *) getCurrentDateComponents{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setLocale:[NSLocale systemLocale]];
    [calendar setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    return dateComponent;
}

#pragma mark - 获取某年某月有多少天
+ (NSUInteger) getDays:(NSInteger)year month:(NSInteger) month{
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%ld-01 00:00:00",year,month];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:timeStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return days.length;
}


@end
