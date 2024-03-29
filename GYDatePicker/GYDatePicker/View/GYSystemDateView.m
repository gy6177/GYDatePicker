//
//  GYSystemDateView.m
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import "GYSystemDateView.h"

@interface GYSystemDateView ()
{
    UIDatePickerMode _datePickerMode;
    NSString *_title;
    NSDate *_minDateStr;
    NSDate *_maxDateStr;
    NSString *_selectValue;
}
// 时间选择器(默认大小: 320px × 216px)
@property (nonatomic, strong) UIDatePicker *datePicker;

// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
// 选中后的回调
@property (nonatomic, copy) GYDateResultBlock resultBlock;

@end

@implementation GYSystemDateView

#pragma mark - 显示时间选择器
+ (void)showDatePickerWithTitle:(NSString *)title
                       DateType:(UIDatePickerMode)type
                DefaultSelValue:(NSString *)defaultSelValue
                     MinDateStr:(NSDate *)minDateStr
                     MaxDateStr:(NSDate *)maxDateStr
                   IsAutoSelect:(BOOL)isAutoSelect
                    ResultBlock:(GYDateResultBlock)resultBlock
{
    GYSystemDateView *datePickerView = [[GYSystemDateView alloc]initWithTitle:title DateType:type DefaultSelValue:defaultSelValue MinDateStr:minDateStr MaxDateStr:maxDateStr IsAutoSelect:isAutoSelect ResultBlock:resultBlock Manager:nil];
    [datePickerView showWithAnimation:YES];
}
+ (void)showDatePickerWithTitle:(NSString *)title
                       DateType:(UIDatePickerMode)type
                DefaultSelValue:(NSString *)defaultSelValue
                     MinDateStr:(NSDate *)minDateStr
                     MaxDateStr:(NSDate *)maxDateStr
                   IsAutoSelect:(BOOL)isAutoSelect
                    ResultBlock:(GYDateResultBlock)resultBlock
                        Manager:(GYPickerViewManager *)manager
{
    GYSystemDateView *datePickerView = [[GYSystemDateView alloc]initWithTitle:title DateType:type DefaultSelValue:defaultSelValue MinDateStr:minDateStr MaxDateStr:maxDateStr IsAutoSelect:isAutoSelect ResultBlock:resultBlock Manager:manager];
    [datePickerView showWithAnimation:YES];
}

#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title
                     DateType:(UIDatePickerMode)type
              DefaultSelValue:(NSString *)defaultSelValue
                   MinDateStr:(NSDate *)minDateStr
                   MaxDateStr:(NSDate *)maxDateStr
                 IsAutoSelect:(BOOL)isAutoSelect
                  ResultBlock:(GYDateResultBlock)resultBlock
                      Manager:(GYPickerViewManager *)manager
{
    if (self = [super init]) {
        _datePickerMode = type;
        _title = title;
        _minDateStr = minDateStr;
        _maxDateStr = maxDateStr;
        _isAutoSelect = isAutoSelect;
        _resultBlock = resultBlock;
        
        if (manager) {
            self.manager = manager;
        }
        // 默认选中今天的日期
        if (defaultSelValue.length > 0) {
            _selectValue = defaultSelValue;
        } else {
            _selectValue = [self toStringWithDate:[NSDate date]];
        }
        
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = _title;
    // 添加时间选择器
    [self.alertView addSubview:self.datePicker];
}

#pragma mark - 时间选择器
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.manager.kTopViewH + 0.5, SCR_WIDTH, self.manager.kPickerViewH)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.datePickerMode = _datePickerMode;
        // 设置该UIDatePicker的国际化Locale，以简体中文习惯显示日期，UIDatePicker控件默认使用iOS系统的国际化Locale
        _datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CHS_CN"];
        // 设置时间范围
        if (_minDateStr) {
            _datePicker.minimumDate = _minDateStr;
            
        }
        if (_maxDateStr) {
            _datePicker.maximumDate = _maxDateStr;
            
        }
        // 把当前时间赋值给 _datePicker
        [_datePicker setDate:[NSDate date] animated:YES];
        //        // 设置UIDatePicker的显示模式
        // 滚动改变值的响应事件
        [_datePicker addTarget:self action:@selector(didSelectValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _datePicker;
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCR_HEIGHT;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            rect.origin.y -= self.manager.kTopViewH + self.manager.kPickerViewH;
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        rect.origin.y += self.manager.kTopViewH + self.manager.kPickerViewH;
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 时间选择器的滚动响应事件
- (void)didSelectValueChanged:(UIDatePicker *)sender {
    // 读取日期：datePicker.date
    _selectValue = [self toStringWithDate:sender.date];
    NSLog(@"滚动完成后，执行block回调:%@", _selectValue);
    // 设置是否开启自动回调
    if (_isAutoSelect) {
        if (_resultBlock) {
            _resultBlock(_selectValue);
        }
    }
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    NSLog(@"点击确定按钮后，执行block回调");
    [self dismissWithAnimation:YES];
    if (_resultBlock) {
        _resultBlock(_selectValue);
    }
}

#pragma mark - 格式转换：NSDate --> NSString
- (NSString *)toStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (_datePickerMode) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            [dateFormatter setDateFormat:@"yyyy-MM"];
            break;
    }
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}

#pragma mark - 格式转换：NSDate <-- NSString
- (NSDate *)toDateWithDateString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    switch (_datePickerMode) {
        case UIDatePickerModeTime:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        case UIDatePickerModeDate:
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            break;
        case UIDatePickerModeDateAndTime:
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            break;
        case UIDatePickerModeCountDownTimer:
            [dateFormatter setDateFormat:@"HH:mm"];
            break;
        default:
            [dateFormatter setDateFormat:@"yyyy-MM"];
            break;
    }
    NSDate *destDate = [dateFormatter dateFromString:dateString];
    
    return destDate;
}

@end
