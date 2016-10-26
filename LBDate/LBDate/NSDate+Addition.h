//
//  NSDate+Addition.h
//  LBDate
//
//  Created by FSLB on 16/7/5.
//  Copyright © 2016年 FSLB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)

+ (NSInteger) getCurrentYear;

+ (NSUInteger) getDays:(NSInteger)year month:(NSInteger) month;

@end
