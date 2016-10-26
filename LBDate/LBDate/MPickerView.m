//
//  MPickerView.m
//  LBDate
//
//  Created by FSLB on 16/7/5.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import "MPickerView.h"
#import "NSDate+Addition.h"

@interface MPickerView()

@end

@implementation MPickerView{
    NSInteger SYear;
    NSInteger SMonth;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self =  [[[NSBundle mainBundle] loadNibNamed:@"MPickerView" owner:self options:nil] lastObject];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 276);
        self.minYear = 1970;
        self.maxYear = [NSDate getCurrentYear];
        
        self.mPickerView.delegate = self;
        self.mPickerView.dataSource = self;
        //self.mPickerView.showsSelectionIndicator = YES;
        //self.midView.alpha = 0.6f;
        self.midView.layer.borderWidth = 1;
        self.midView.layer.borderColor = [UIColor colorWithRed:0.00f green:0.58f blue:0.89f alpha:1.00f].CGColor;
    }
    return self;
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
            
        default:
            return 0;
            break;
    }
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [[self getAllYears] count];
        case 1:
            return [[self getAllMonths] count];
        case 2:
            return [[self getAllDays:SYear month:SMonth] count];
        case 3:
            return [[self getAllHours] count];
        case 4:
            return [[self getAllMinutes] count];
        default:
            return 0;
    }
}


- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return [self.years[row] stringByAppendingString:@"年"];
        case 1:
            return [self.months[row] stringByAppendingString:@"月"];
        case 2:
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
        //pickerLabel.frame = CGRectMake(0, 0, 375/5+1, pickerView.bounds.size.height);
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        //[pickerLabel setBackgroundColor:[UIColor colorWithRed:0.95f green:0.98f blue:1.0f alpha:1]];
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.textColor = [UIColor colorWithRed:0.0f green:0.53f blue:0.89f alpha:1.00f];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    SYear = [[self.years objectAtIndex:[pickerView selectedRowInComponent:0]] integerValue];
    SMonth = [[self.months objectAtIndex:[pickerView selectedRowInComponent:1]] integerValue];
    
    switch (component) {
        case 0:
        case 1:
            [pickerView reloadComponent:2];
            //[self selectRow:0 inComponent:2 animated:YES];
            break;
            
        default:
            break;
    }
    
    
    switch (_lbPickerViewType) {
        case 0:
            self.resultLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[self.years objectAtIndex:[pickerView selectedRowInComponent:0]],[self.months objectAtIndex:[pickerView selectedRowInComponent:1]],[self.days objectAtIndex:[pickerView selectedRowInComponent:2]]];
            break;
        case 1:
            self.resultLabel.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[self.years objectAtIndex:[pickerView selectedRowInComponent:0]],[self.months objectAtIndex:[pickerView selectedRowInComponent:1]],[self.days objectAtIndex:[pickerView selectedRowInComponent:2]],[self.hours objectAtIndex:[pickerView selectedRowInComponent:3]],[self.minutes objectAtIndex:[pickerView selectedRowInComponent:4]]];
            break;
        default:
            break;
    }
    
    
}



- (IBAction)done:(id)sender {
    if(self.finishBlock){
        self.resultLabel.text = @"";
        self.finishBlock(_resultLabel.text);
    }
}


#pragma mark - init数据源
- (NSMutableArray *) getAllYears{
    self.years = [[NSMutableArray alloc] init];
    NSAssert(self.minYear <= self.maxYear, @"最小时间不能大于最大时间");
    for (NSInteger i = self.minYear; i <= self.maxYear; i++){
        [self.years addObject:[NSString stringWithFormat:@"%ld",i]];
    }
    return self.years;
}

- (NSMutableArray *) getAllMonths{
    self.months = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i <= 12; i++){
        [self.months addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return self.months;
}

- (NSMutableArray *) getAllDays:(NSInteger)year month:(NSInteger)month {
    self.days = [[NSMutableArray alloc] init];
    if(!year){NSAssert(self.years.count > 0, @"无年份");}
    if(!month){NSAssert(self.months.count > 0, @"无月份");}
    
    NSInteger newYear = year?year:[self.years[0] integerValue];
    NSInteger newMonth = month?month:[self.months[0] integerValue];
    
    NSUInteger maxDays = [NSDate getDays:newYear month:newMonth];
    for(NSInteger i = 1;i<=maxDays;i++){
        [self.days addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return self.days;
}

- (NSMutableArray *) getAllHours{
    self.hours = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i <= 23; i++){
        [self.hours addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return self.hours;
}

- (NSMutableArray *) getAllMinutes{
    self.minutes = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i <= 59; i++){
        [self.minutes addObject:[NSString stringWithFormat:@"%02ld",i]];
    }
    return self.minutes;
}

@end
