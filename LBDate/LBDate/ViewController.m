//
//  ViewController.m
//  LBDate
//
//  Created by FSLB on 16/7/5.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import "ViewController.h"
#import "DGDatePickerView.h"
#import "NSDate+LBDate.h"

@interface ViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) DGDatePickerView *mDatePickerView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(0, 0, 375, 276);
    [view addSubview:self.mDatePickerView];
    
    
}



- (DGDatePickerView *) mDatePickerView{
    if(!_mDatePickerView){
        __weak typeof(self) weakSelf = self;
        _mDatePickerView = [[DGDatePickerView alloc] initWithTextFiled:self.textFiled andFinishBlock:^(NSString *result) {
            weakSelf.textFiled.text = result;
        }];
        //指定显示样式
        _mDatePickerView.lbPickerViewType = LB_YEAR_MONTH_DAY_HOURS_MINUTES;
        _mDatePickerView.minTime = @"2000-1-1 00:00";
        _mDatePickerView.maxTime = @"2020-12-31 00:00";
        
        
    }
    return _mDatePickerView;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    self.mDatePickerView.showDate = [[NSDate date] dateToString];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
