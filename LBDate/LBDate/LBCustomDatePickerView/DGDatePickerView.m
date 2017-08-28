//
//  MPickerView.m
//  LBDate
//
//  Created by FSLB on 16/7/5.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import "DGDatePickerView.h"
#import "NSDate+LBDate.h"

#define UIColorForHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface DGDatePickerView()
@property (strong, nonatomic) UIPickerView *mPickerView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *done;
@property (nonatomic, strong) UITextField *mTextField;

@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSMutableArray *months;
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, strong) NSMutableArray *hours;
@property (nonatomic, strong) NSMutableArray *minutes;
@property (nonatomic, strong) NSMutableArray *seconds;

@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;

//是否实施更新最大时间，当maxdate传nil时实时更新
@property (nonatomic, assign) BOOL realTimeUpdateMaxDate;

//时间格式设置,默认为 yyyy-MM-dd 或 yyyy-MM-dd HH:mm    (注:如需传minTime和maxTime，请务必先设置outDataFormatter.dateFormat,且格式要一致，否则可能导致崩溃)
@property (nonatomic, strong) NSDateFormatter *outDataFormatter;
@end

@implementation DGDatePickerView{
    NSInteger SYear;
    NSInteger SMonth;
    NSInteger SDay;
    NSInteger SHours;
    NSInteger SMinute;
}

- (instancetype) initWithTextFiled:(UITextField *) textField andFinishBlock:(void(^)(NSString *result))finishBlock{
    self = [super init];
    if(self){
        self = [[NSBundle mainBundle] loadNibNamed:@"DGDatePickerView" owner:self options:nil][0];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40);
        
        textField.inputView = self.mPickerView;
        textField.inputAccessoryView = self;
        
        self.mTextField = textField;
        self.minDate = [NSDate dateWithTimeIntervalSince1970:0];
        self.maxDate = [NSDate date];
        self.finishBlock = finishBlock;
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = UIColorForHexRGB(0x333333).CGColor;
    }
    return self;
}

- (void) layoutSubviews{
    if(self.realTimeUpdateMaxDate){
        _maxDate = [NSDate date];
    }
}

- (void) setLbPickerViewType:(LBPickerViewType)lbPickerViewType {
    _lbPickerViewType = lbPickerViewType;
    switch (_lbPickerViewType) {
        case LB_YEAR_MONTH_DAY:
            self.outDataFormatter.dateFormat = @"yyyy-MM-dd";
            break;
        case LB_YEAR_MONTH_DAY_HOURS_MINUTES:
            self.outDataFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            break;
        case LB_CreditCard_MONTH_YEAR:
            self.outDataFormatter.dateFormat = @"yyyy-MM";
            break;
        default:
            break;
    }
}

- (NSDateFormatter *) outDataFormatter{
    if(!_outDataFormatter){
        _outDataFormatter = [[NSDateFormatter alloc] init];
    }
    return _outDataFormatter;
}


- (UIPickerView *) mPickerView{
    if(!_mPickerView){
        _mPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 216)];
        _mPickerView.backgroundColor = [UIColor whiteColor];
        _mPickerView.delegate = self;
        _mPickerView.dataSource = self;
        
        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, _mPickerView.bounds.size.width, 36)];
        midView.layer.borderWidth = 1;
        midView.layer.borderColor = [UIColor colorWithRed:0.00f green:0.58f blue:0.89f alpha:1.00f].CGColor;
        midView.userInteractionEnabled = NO;
        [_mPickerView addSubview:midView];
    }
    return _mPickerView;
}

- (void) setMinTime:(NSString *)minTime{
    _minTime = minTime;
    self.minDate =  [NSDate dateStringToDateWithDateFormat:_outDataFormatter.dateFormat dateString:minTime];
}

- (void) setMaxTime:(NSString *)maxTime{
    if(maxTime == nil){
        self.realTimeUpdateMaxDate = YES;
    }
    _maxTime = maxTime;
    self.maxDate = [NSDate dateStringToDateWithDateFormat:_outDataFormatter.dateFormat dateString:maxTime];
}

- (void) setMinDate:(NSDate *)minDate{
    _minDate = minDate;
    if([_minDate compare:_maxDate] == NSOrderedDescending){
        _maxDate = _minDate;
    }
    
    SYear = [_minDate year];
    SMonth = [_minDate month];
    SDay = [_minDate day];
    SHours = [_minDate hour];
    SMinute = [_minDate minute];
}

- (void) setMaxDate:(NSDate *)maxDate{
    if(maxDate == nil){
        _maxDate = [NSDate date];
    }else{
        _maxDate = maxDate;
    }
    
    if([_maxDate compare:_minDate] == NSOrderedAscending){
        _minDate = _maxDate;
    }
}

- (void) setShowDate:(NSString *)showDate{
    if(showDate == nil || [showDate isEqualToString:@""]){
        [self reloadmDateViewWithTime:[NSDate date]];
    }else{
        _showDate = showDate;
        [self reloadmDateViewWithTime:[NSDate dateStringToDateWithDateFormat:_outDataFormatter.dateFormat dateString:_showDate]];
    }
    [self setResultLableText];
}


#pragma mark - UIPickerViewdelegateAndDatasource

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    switch (_lbPickerViewType) {
        case LB_YEAR_MONTH_DAY:
            return 3;
            break;
        case LB_YEAR_MONTH_DAY_HOURS_MINUTES:
            return 5;
            break;
        case LB_CreditCard_MONTH_YEAR:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if(_lbPickerViewType == LB_CreditCard_MONTH_YEAR){
                return [self.months count];
            }else{
               return [self.years count];
            }
        case 1:
            if(_lbPickerViewType == LB_CreditCard_MONTH_YEAR){
                return [self.years count];
            }else{
                return [self.months count];
            }
        case 2:
            return [self.days count];
        case 3:
            return [self.hours count];
        case 4:
            return [self.minutes count];
        default:
            return 0;
    }
}


- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if(_lbPickerViewType == LB_CreditCard_MONTH_YEAR){
                return [self.months[row] stringByAppendingString:@"月"];
            }else{
                return [self.years[row] stringByAppendingString:@"年"];
            }
        case 1:
            if(_lbPickerViewType == LB_CreditCard_MONTH_YEAR){
                return [self.years[row] stringByAppendingString:@"年"];
            }else{
                return [self.months[row] stringByAppendingString:@"月"];
            }        case 2:
            return [self.days[row] stringByAppendingString:@"日"];
        case 3:
            return [self.hours[row]stringByAppendingString:@"时"];
        case 4:
            return [self.minutes[row]stringByAppendingString:@"分"];
        default:
            return @"";
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.textColor = [UIColor colorWithRed:0.0f green:0.53f blue:0.89f alpha:1.00f];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            if(_lbPickerViewType == LB_CreditCard_MONTH_YEAR){
                SMonth = [[self.months objectAtIndex:[pickerView selectedRowInComponent:0]] integerValue];
            }else{
                SYear = [[self.years objectAtIndex:[pickerView selectedRowInComponent:0]] integerValue];
                [pickerView reloadComponent:1];
            }
        case 1:
            if(_lbPickerViewType == LB_CreditCard_MONTH_YEAR){
                SYear = [[self.years objectAtIndex:[pickerView selectedRowInComponent:1]] integerValue];
                break;
            }else{
                SMonth = [[self.months objectAtIndex:[pickerView selectedRowInComponent:1]] integerValue];
                [pickerView reloadComponent:2];
            }
            
        case 2:
            if(_lbPickerViewType == LB_YEAR_MONTH_DAY_HOURS_MINUTES){
                SDay = [[self.days objectAtIndex:[pickerView selectedRowInComponent:2]] integerValue];
                [pickerView reloadComponent:3];
            }else{
                SDay = [[self.days objectAtIndex:[pickerView selectedRowInComponent:2]] integerValue];
                //年月日不需要刷新时分
                break;
            }
        case 3:
            SHours = [[self.hours objectAtIndex:[pickerView selectedRowInComponent:3]] integerValue];
            [pickerView reloadComponent:4];
            
            SMinute = [[self.minutes objectAtIndex:[pickerView selectedRowInComponent:4]] integerValue];
        default:
            break;
    }
    [self setResultLableText];
}

#pragma mark - init数据源
- (NSMutableArray *) years{
    _years = [[NSMutableArray alloc] init];

    NSAssert([_minDate compare:_maxDate] == NSOrderedAscending, @"最小时间不能大于最大时间");
    for (NSInteger i = [_minDate year]; i <= [_maxDate year]; i++){
        [_years addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    return _years;
}

- (NSMutableArray *) months{
    _months = [[NSMutableArray alloc] init];
    NSInteger min = 1;
    NSInteger max = 12;
    if([_minDate year] == SYear){
        min = [_minDate month];
    }else if ([_maxDate year] == SYear){
        max = [_maxDate month];
    }
    for (NSInteger i = min; i <= max; i++){
        [_months addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return _months;
}

- (NSMutableArray *) days{
    _days = [[NSMutableArray alloc] init];
    
    if(_years.count == 0 || _months.count == 0){
        return nil;
    }
    NSInteger newYear = SYear?SYear:[_years[0] integerValue];
    NSInteger newMonth = SMonth?SMonth:[_months[0] integerValue];
    
    NSUInteger allDays = [self getDays:newYear month:newMonth];
    NSInteger min = 1;
    NSInteger max = allDays;
    if([_minDate year] == SYear && [_minDate month] == SMonth){
        min = [_minDate day];
    }else if ([_maxDate year] == SYear && [_maxDate month] == SMonth){
        max = [_maxDate day];
    }
    for(NSInteger i = min; i<=max;i++){
        [_days addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return _days;

}

#pragma mark - 获取某年某月有多少天
- (NSUInteger)getDays:(NSInteger)year
                month:(NSInteger)month {
    NSString *timeStr = [NSString stringWithFormat:@"%ld-%ld-01 00:00:00",year,month];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [dateFormatter dateFromString:timeStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return days.length;
}

- (NSMutableArray *) hours{
    _hours = [[NSMutableArray alloc] init];
    NSInteger min = 0;
    NSInteger max = 23;
    if([_minDate year] == SYear && [_minDate month] == SMonth && [_minDate day] == SDay){
        min = [_minDate hour];
    }else if ([_maxDate year] == SYear && [_maxDate month] == SMonth && [_maxDate day] == SDay){
        max = [_maxDate hour];
    }
    
    for (NSInteger i = min; i <= max; i++){
        [_hours addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return _hours;

}


- (NSMutableArray *) minutes{
    _minutes = [[NSMutableArray alloc] init];
    NSInteger min = 0;
    NSInteger max = 59;
    if([_minDate year] == SYear && [_minDate month] == SMonth && [_minDate day] == SDay && [_minDate hour] == SHours){
        min = [_minDate minute];
    }else if ([_maxDate year] == SYear && [_maxDate month] == SMonth && [_maxDate day] == SDay && [_maxDate hour] == SHours){
        max = [_maxDate minute];
    }
    
    for (NSInteger i = min; i <= max; i++){
        [_minutes addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return _minutes;

}

#pragma mark - Other
- (void) reloadmDateViewWithTime:(NSDate *)date{
    NSDate *NDate = [[NSDate alloc] init];
    NDate = date;
    if(NDate == nil){
        NDate = [NSDate date];
    }
    if([NDate compare:_minDate] == NSOrderedAscending){
        NDate = [NSDate date];
    }else if([NDate compare:_maxDate] == NSOrderedDescending){
        NDate = _maxDate;
    }
    
    for (int y = 0; y<self.years.count; y++) {
        if([self.years[y] integerValue] == [NDate year]){
            [self.mPickerView selectRow:y inComponent:0 animated:YES];
            SYear = [NDate year];
        }
    }
    
    [self.mPickerView reloadComponent:1];
    for (int m = 0; m < self.months.count; m++) {
        if([self.months[m] integerValue] == [NDate month]){
            [self.mPickerView selectRow:m inComponent:1 animated:YES];
            SMonth = [NDate month];
        }
    }
    
    if(self.lbPickerViewType == LB_CreditCard_MONTH_YEAR){
        return;
    }
    
    [self.mPickerView reloadComponent:2];
    for (int d = 0; d < self.days.count; d++) {
        if([self.days[d] integerValue] == [NDate day]){
            [self.mPickerView selectRow:d inComponent:2 animated:YES];
            SDay = [NDate day];
        }
    }
    
    if(self.lbPickerViewType == LB_YEAR_MONTH_DAY){
        return;
    }
    
    [self.mPickerView reloadComponent:3];
    for (int h = 0; h < self.hours.count; h++) {
        if([self.hours[h] integerValue] == [NDate hour]){
            [self.mPickerView selectRow:h inComponent:3 animated:YES];
            SHours = [NDate hour];
        }
    }
    
    [self.mPickerView reloadComponent:4];
    for (int m = 0; m < self.minutes.count; m++) {
        if([self.minutes[m] integerValue] == [NDate minute]){
            [self.mPickerView selectRow:m inComponent:4 animated:YES];
            SMinute = [NDate minute];
        }
    }
}

- (void) setResultLableText{
    switch (_lbPickerViewType) {
        case LB_YEAR_MONTH_DAY:
            self.resultLabel.text = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",SYear,SMonth,SDay];
            break;
        case LB_YEAR_MONTH_DAY_HOURS_MINUTES:
            self.resultLabel.text = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%@",SYear,SMonth,SDay,SHours,[self.minutes objectAtIndex:[self.mPickerView selectedRowInComponent:4]]];
            break;
        case LB_CreditCard_MONTH_YEAR:
            self.resultLabel.text = [NSString stringWithFormat:@"%02ld/%@",SMonth,[[NSString stringWithFormat:@"%04ld",SYear] substringFromIndex:2]];
            break;
        default:
            break;
    }
}


- (IBAction)done:(id)sender {
    if(self.finishBlock){
        self.finishBlock(_resultLabel.text);
    }
    [self.mTextField endEditing:YES];
}


@end




