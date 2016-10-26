//
//  NSDate+extension.m
//  LBDemo
//
//  Created by FSLB on 16/7/8.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import "NSDate+LBDate.h"

@implementation NSDate (LBDate)

- (NSInteger)year {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
}

- (NSInteger)month {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
}

- (NSInteger)day {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
}

- (NSInteger)hour {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
}

- (NSInteger)minute {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
}

- (NSInteger)second {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSInteger)weekdayOrdinal {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
}

- (NSInteger)weekOfMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
}

- (NSInteger)weekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
}

- (NSInteger)yearForWeekOfYear {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
}

- (NSInteger)quarter {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
}

- (BOOL)isLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}

- (BOOL)isLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)isToday {
    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
    return [NSDate new].day == self.day;
}



+ (NSString *)currentDateStringWithFormat:(NSString *)format
{
    NSDate *chosenDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:chosenDate];
    return date;
}

+ (NSString *) currentDateString{
    return [self currentDateStringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)dateToString{
    return [self dateToStringWithDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSString *)dateToStringWithDateFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *date = [formatter stringFromDate:self];
    return date;
}


+ (NSString *)dateStringByTimeInterval:(NSTimeInterval)timeInterval{
    return [self dateStringByTimeInterval:timeInterval withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}
+ (NSString *)dateStringByTimeInterval:(NSTimeInterval)timeInterval
                        withDateFormat:(NSString *)dateFormat{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}


+ (NSTimeInterval)getTimerIntervalSince1970
{
    return [[NSDate date] timeIntervalSince1970];
}

- (NSTimeInterval) dataToTimerInterval{
    return [[NSDate date] timeIntervalSinceDate:self];
}

+ (NSTimeInterval)timeIntervalByDateString:(NSString *)dateString
                            withDateFormat:(NSString *)dateFormat{
    NSTimeInterval timeInterval = [[self dateStringToDateWithDateFormat:dateFormat dateString:dateString] timeIntervalSince1970];
    return timeInterval;
}

+ (NSDate *) dateStringToDateWithDateFormat:(NSString *)dateFormat
                                 dateString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}


+ (NSString*)timeStampTimeValueForKey:(NSString*)stringTime{
    //定一个时间戳字符串对象
    NSString* _timeStamp = @"";
    
    //获取当前具体时间，精确到秒
    time_t now;
    time(&now);
    
    //    time_t createdAt = [JPDateUtility getTimeValueForKey:stringTime defaultValue:0];
    time_t createdAt = [stringTime floatValue];
    int distance = (int)difftime(now, createdAt);
    
    //忽略时间误差
    if(distance < 0) {
        distance = 0;
    }
    
    if(distance < 60) {
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"秒前"];
    } else if(distance < 60 * 60){
        distance = distance / 60;
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"分钟前"];
    }
    else if(distance < 60 * 60 * 24){
        distance = distance / 60 / 60;
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"小时前"];
    }
    else if(distance < 60 * 60 * 24 * 7){
        distance = distance / 60 / 60 / 24;
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"天前"];
    }
    else if(distance < 60 * 60 * 24 * 7 * 4){
        distance = distance / 60 / 60 / 24 / 7;
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"周前"];
    }
    else{
        static NSDateFormatter * dateFormatter = nil;
        if(dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        }
        NSDate* date = [NSDate  dateWithTimeIntervalSince1970:createdAt];
        _timeStamp = [dateFormatter stringFromDate:date];
    }
    return _timeStamp;
}

+ (NSString *)getCurrentWeek{
    switch ([[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]] weekday]) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 0:
            return @"星期六";
            break;
        default:
            break;
    }
    return @"";
}


+(NSString *)getAstroWithMonth:(int)m day:(int)d{
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    
    NSString *astroFormat = @"102123444543";
    
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        
        return @"错误日期格式!";
        
    }
    
    if(m==2 && d>29)
        
    {
        
        return @"错误日期格式!!";
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            
            return @"错误日期格式!!!";
            
        }
        
    }
    
    result=[NSString stringWithFormat:@"%@座",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
    
}



@end
