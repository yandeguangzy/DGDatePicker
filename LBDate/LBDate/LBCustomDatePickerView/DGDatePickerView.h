//
//  MPickerView.h
//  LBDate
//
//  Created by FSLB on 16/7/5.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LBPickerViewType) {
    LB_YEAR_MONTH_DAY                           =0,         //@"yyyy-MM-dd";
    LB_YEAR_MONTH_DAY_HOURS_MINUTES,                        //@"yyyy-MM-dd HH:mm";
    LB_CreditCard_MONTH_YEAR                                //信用卡有效期选择yyyy-MM
};


@interface DGDatePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
//日期样式
@property (nonatomic, assign) LBPickerViewType lbPickerViewType;
//最小时间限制，默认为1970-1-1 0：0
@property (nonatomic, strong) NSString *minTime;
//最大时间限制，默认为当前时间，当maxTime传nil时实时更新最大时间
@property (nonatomic, strong) NSString *maxTime;
//设置当前显示时间，在textfield呼出时设置，默认为显示当前时间，若当前时间大于最大时间，则显示最大时间
@property (nonatomic, strong) NSString *showDate;

//完成回调
@property (nonatomic, copy) void (^finishBlock)(NSString *result);

- (instancetype) initWithTextFiled:(UITextField *) textField andFinishBlock:(void(^)(NSString *result))finishBlock;
@end

