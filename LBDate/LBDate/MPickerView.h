//
//  MPickerView.h
//  LBDate
//
//  Created by FSLB on 16/7/5.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *mPickerView;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *done;
@property (weak, nonatomic) IBOutlet UIView *midView;

typedef NS_ENUM(NSInteger, LBPickerViewType) {
    LB_YEAR_MONTH_DAY                           =0,
    LB_YEAR_MONTH_DAY_HOURS_MINUTES
};

@property (nonatomic, assign) LBPickerViewType lbPickerViewType;

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;

@property (nonatomic, strong) NSMutableArray *years;
@property (nonatomic, strong) NSMutableArray *months;
@property (nonatomic, strong) NSMutableArray *days;
@property (nonatomic, strong) NSMutableArray *hours;
@property (nonatomic, strong) NSMutableArray *minutes;
@property (nonatomic, strong) NSMutableArray *seconds;

@property (nonatomic, copy) void (^finishBlock)(NSString *result);

@end
