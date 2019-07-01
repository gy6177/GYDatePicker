//
//  GYSystemDateView.h
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import "GYPickerUIBaseView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  @param selectValue     选择的行标题文字
 */
typedef void(^GYDateResultBlock)(NSString *selectValue);

@interface GYSystemDateView : GYPickerUIBaseView

/**
 *  显示时间选择器
 *
 *  @param title            标题
 *  @param type             类型（时间、日期、日期和时间、倒计时）
 *  @param defaultSelValue  默认选中的时间（为空，默认选中现在的时间）
 *  @param minDateStr       最小时间（如：2015-08-28 00:00:00），可为空
 *  @param maxDateStr       最大时间（如：2018-05-05 00:00:00），可为空
 *  @param isAutoSelect     是否自动选择，即选择完(滚动完)执行结果回调，传选择的结果值
 *  @param resultBlock      选择结果的回调
 *
 */
+ (void)showDatePickerWithTitle:(NSString *)title
                       DateType:(UIDatePickerMode)type
                DefaultSelValue:(NSString *)defaultSelValue
                     MinDateStr:(NSDate *)minDateStr
                     MaxDateStr:(NSDate *)maxDateStr
                   IsAutoSelect:(BOOL)isAutoSelect
                    ResultBlock:(GYDateResultBlock)resultBlock;

+ (void)showDatePickerWithTitle:(NSString *)title
                       DateType:(UIDatePickerMode)type
                DefaultSelValue:(NSString *)defaultSelValue
                     MinDateStr:(NSDate *)minDateStr
                     MaxDateStr:(NSDate *)maxDateStr
                   IsAutoSelect:(BOOL)isAutoSelect
                    ResultBlock:(GYDateResultBlock)resultBlock
                        Manager:(GYPickerViewManager *)manager;

@end

NS_ASSUME_NONNULL_END
