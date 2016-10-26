//
//  NSDate+extension.h
//  LBDemo
//
//  Created by FSLB on 16/7/8.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LBDate)

@property (nonatomic, readonly) NSInteger year;//年
@property (nonatomic, readonly) NSInteger month; //月
@property (nonatomic, readonly) NSInteger day; //日
@property (nonatomic, readonly) NSInteger hour; //时
@property (nonatomic, readonly) NSInteger minute;//分
@property (nonatomic, readonly) NSInteger second;//秒
@property (nonatomic, readonly) NSInteger weekday;//周几（周日为1,周一为2,周二为3...）
@property (nonatomic, readonly) NSInteger weekdayOrdinal;//第几个周几（周几为今天是周几）
@property (nonatomic, readonly) NSInteger weekOfMonth;//今天为本月的第几周
@property (nonatomic, readonly) NSInteger weekOfYear;//今天为本年的第几周
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;//第几周年
@property (nonatomic, readonly) NSInteger quarter;//季度
@property (nonatomic, readonly) BOOL isLeapMonth;//是否为闰月
@property (nonatomic, readonly) BOOL isLeapYear;//是否为闰年
@property (nonatomic, readonly) BOOL isToday;//是否是今天

/**
 *  @author Yan deguang, 16-06-29 10:06:14
 *
 *  获取当前时间字符串
 *
 *  @param format 时间格式 G:显示AD（公元）
 yy:年份的后两位    yyyy：显示完整的年份
 M:月显示1~12，1位或两位   MM：显示01~12：不足两位前面补0  MMM：英文月份缩写，如：January MMMM:英文月份全写 如：January
 d:日显示成1~31，1位或两位数    dd:显示01~31，不足2位数前面补0
 EEE：星期的英文缩写，如Sun   EEEE：星期的英文完整显示，如，Sunday
 H：时显示成0~23，1位数或2位数(24小时制    HH：显示成00~23，不足2位数会补0(24小时制)
 K：时显示成0~12，1位数或2位数(12小時制)   KK：显示成0~12，不足2位数会补0(12小时制)
 m：分显示0~59，1位数或2位数              mm：显示00~59，不足2位数会补0
 s：秒显示0~59，1位数或2位数              ss：显示00~59，不足2位数会补0
 S： 毫秒的显示
 *
 *  @return 时间字符串
 */
+ (NSString *) currentDateStringWithFormat:(NSString *)format;
+ (NSString *) currentDateString;


/**
 *  @author Yan deguang, 16-07-21 10:07:02
 *
 *  将NSDate转化为时间字符串
 *
 *  @param format 自定义格式   如:yyyy-MM-dd HH:mm:ss,默认为yyyy-MM-dd HH:mm:ss
 *
 *  @return 按照默认格式或给定格式返回时间字符串，如：2016-07-21 10:07:02
 */
- (NSString *) dateToStringWithDateFormat:(NSString *)format;
- (NSString *) dateToString;


/**
 *  @author Yan deguang, 16-07-21 10:07:35
 *
 *  将时间戳转化成时间字符串
 *
 *  @param timeInterval 时间戳
 *  @param dateFormat   自定义格式   如:yyyy-MM-dd HH:mm:ss,默认为yyyy-MM-dd HH:mm:ss
 *
 *  @return 按照默认格式或给定格式返回时间字符串，如：2016-07-21 10:07:02
 */
+ (NSString *) dateStringByTimeInterval:(NSTimeInterval)timeInterval
                        withDateFormat:(NSString *)dateFormat;
+ (NSString *) dateStringByTimeInterval:(NSTimeInterval)timeInterval;

//获取当前时间戳
+ (NSTimeInterval) getTimerIntervalSince1970;
//NSDate转时间戳
- (NSTimeInterval) dataToTimerInterval;

/**
 *  @author Yan deguang, 16-07-21 10:07:10
 *
 *  将时间字符串转化成时间戳
 *
 *  @param dateString 时间字符串，如：2016-07-21 10:10:21
 *  @param dateFormat 时间字符串格式，必须与所给定时间字符串格式一样，如：yyyy-MM-dd HH:mm:ss
 *
 *  @return 时间字符串对应的时间戳
 */

+ (NSTimeInterval)timeIntervalByDateString:(NSString *)dateString
                            withDateFormat:(NSString *)dateFormat;


/**
 *  @author Yan deguang, 16-07-21 11:07:02
 *
 *  将时间字符串转NSDate
 *
 *  @param dateFormat 时间字符串格式，必须与所给定时间字符串格式一样，如：yyyy-MM-dd HH:mm:ss
 *  @param dateString 时间字符串，如：2016-07-21 10:10:21
 *
 *  @return 时间字符串对应的NSDate
 */
+ (NSDate *) dateStringToDateWithDateFormat:(NSString *)dateFormat
                                 dateString:(NSString *)dateString;



/**
 *  @author Yan deguang, 16-07-21 11:07:50
 *
 *  计算给定时间离当前时间是多少秒前，或多少分前，或多少小时前等等
 *
 *  @param stringTime 当前时间戳字符串
 *
 *  @return 如:5秒前  或者   1分钟前
 */
+ (NSString*)timeStampTimeValueForKey:(NSString*)stringTime;

//获取今天星期几 如:星期日
+ (NSString *)getCurrentWeek;

//根据月份和日获取星座
+ (NSString *)getAstroWithMonth:(int)m day:(int)d;
@end
