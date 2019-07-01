//
//  GYDatePickerView.m
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import "GYDatePickerView.h"

@interface GYDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    NSInteger rowOfYear; // 保存年对应的下标
    NSInteger rowOfMonth;     // 保存月对应的下标
    NSInteger rowOfDay;     // 保存日对应的下标
    NSInteger rowOfHours;     // 保存小时对应的下标
    NSInteger rowOfMin;     // 保存分钟对应的下标
    
}
// 时间选择器（默认大小: 320px × 216px）
@property (nonatomic, strong) UIPickerView *pickerView;


@property (nonatomic, strong) NSMutableArray *dateArr;
@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;

// 默认选中的值（@[省索引, 市索引, 区索引]）
@property (nonatomic, strong) NSArray *defaultSelectedArr;
// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
//中间文字说明
@property (nonatomic , strong) NSString *titleStr;

// 选中后的回调
@property (nonatomic, copy) GYResultBlock resultBlock;

@end

@implementation GYDatePickerView

#pragma mark - 显示地址选择器
+ (void)showDatePickerWithTitle:(NSString *)title
                   DefaultSelected:(NSArray *)defaultSelectedArr
                      IsAutoSelect:(BOOL)isAutoSelect
                           Manager:(GYPickerViewManager *)manager
                       ResultBlock:(GYResultBlock)resultBlock
{
    GYDatePickerView *addressPickerView = [[GYDatePickerView alloc] initWithTitle:title DefaultSelected:defaultSelectedArr IsAutoSelect:isAutoSelect Manager:manager ResultBlock:resultBlock];
    [addressPickerView showWithAnimation:YES];
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithTitle:(NSString *)title
              DefaultSelected:(NSArray *)defaultSelectedArr
                 IsAutoSelect:(BOOL)isAutoSelect
                      Manager:(GYPickerViewManager *)manager
                  ResultBlock:(GYResultBlock)resultBlock

{
    if (self = [super init]) {
        // 默认选中
        self.defaultSelectedArr = defaultSelectedArr;
        self.isAutoSelect = isAutoSelect;
        self.resultBlock = resultBlock;
        self.titleStr = title;
        if (manager) {
            self.manager = manager;
        }
        [self loadData];
        [self initUI];
    }
    return self;
}

#pragma mark - 获地址数据
- (void)loadData {
    NSDate *currentDate = [Utility getDateSixMonthsFromNow];
    NSInteger sixOldYear = [Utility getCurrentYear:currentDate];
    NSInteger sixOldMonth = [Utility getCurrentMonth:currentDate];
    NSInteger sixOldDay = [Utility getCurrentDay:currentDate];
    
    NSDate *current1Date = [Utility getDateSixMonthsToNow];
    NSInteger sixYear = [Utility getCurrentYear:current1Date];
    NSInteger sixMonth = [Utility getCurrentMonth:current1Date];
    NSInteger sixDay = [Utility getCurrentDay:current1Date];
    
    //    NSInteger years = [self numberOfYearsWithFromDate:currentDate toDate:current1Date];
    for (NSInteger i=0; i<24; i++) {
        [self.hourArray addObject:[NSString stringWithFormat:@"%ld时",(long)(i+1)]];
    }
    for (NSInteger i=0; i<60; i++) {
        [self.minuteArray addObject:[NSString stringWithFormat:@"%.2ld分",(long)i]];
    }
    
    for (NSInteger i=sixOldYear; i<=sixYear; i++) {
        
        NSMutableArray *monthArray = [[NSMutableArray alloc]init];
        
        NSString *yearStr = [NSString stringWithFormat:@"%ld年",i];
        NSInteger startMonth;
        NSInteger monthNums;
        
        if(i==sixOldYear){
            startMonth = sixOldMonth;
        }else{
            startMonth = 1;
        }
        
        if(i==sixYear){
            monthNums = sixMonth;
        }else{
            monthNums = 12;
        }
        
        for (NSInteger j=startMonth; j<=monthNums; j++) {
            NSMutableArray *dayArray = [[NSMutableArray alloc]init];
            
            NSString *monthStr = [NSString stringWithFormat:@"%ld月",(long)j];
            NSString *yearMonthtring = [NSString stringWithFormat:@"%@%@",yearStr ,monthStr];
            NSInteger days = [Utility getNumberOfDaysInMonth:yearMonthtring];
            NSInteger startDay;
            NSInteger dayNums;
            
            if(j==sixOldMonth){
                if(i==sixOldYear){
                    startDay = sixOldDay;
                }else{
                    if (sixOldMonth == sixMonth) {
                        startDay = 1;
                    }else{
                        startDay = sixOldDay;
                    }
                }
                
            }else{
                startDay = 1;
            }
            
            if(j==sixMonth){
                if(i==sixOldYear){
                    dayNums = days;
                }else{
                    dayNums = sixDay;
                }
            }else{
                dayNums = days;
            }
            
            
            for (NSInteger k=startDay; k<=dayNums; k++) {
                [dayArray addObject:[NSString stringWithFormat:@"%ld日",(long)(k)]];
            }
            
            [monthArray addObject:@{@"month":monthStr,@"day":dayArray}];
            
        }
        [self.dateArr addObject:@{@"year":yearStr,@"month":monthArray}];
    }
    
    NSLog(@"%@",self.dateArr);
}



#pragma mark - 初始化子视图
- (void)initUI {
    
    [super initUI];
    
    
    if (self.titleStr) {
        self.titleLabel.text = self.titleStr;
    } else{
        self.titleLabel.text = [Utility getCurrentDateSecond];
    }
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    // 1.获取当前应用的主窗口
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
    
    NSInteger recordRowOfYear =0;
    NSInteger recordRowOfMonth = 0;
    NSInteger recordRowOfDay =0;
    NSInteger recordRowOfHours =0;
    NSInteger recordRowOfMin =0;
    // 2.滚动到默认行
    if (self.defaultSelectedArr.count == 1) {
        NSString *year = self.defaultSelectedArr[0];
        for (NSInteger i=0; i<self.dateArr.count; i++) {
            NSDictionary *dict = self.dateArr[i];
            if ([year isEqualToString:dict[@"year"]]) {
                recordRowOfYear = i;
                break;
            }
        }
    }
    if (self.defaultSelectedArr.count == 2) {
        NSString *year = self.defaultSelectedArr[0];
        NSString *month = self.defaultSelectedArr[1];
        for (NSInteger i=0; i<self.dateArr.count; i++) {
            NSDictionary *dict = self.dateArr[i];
            if ([year isEqualToString:dict[@"year"]]) {
                recordRowOfYear = i;
                NSArray *monthArray = dict[@"month"];
                for (NSInteger j=0; j<monthArray.count; j++) {
                    NSDictionary *monthDict = monthArray[j];
                    if ([month isEqualToString:monthDict[@"month"]]) {
                        recordRowOfMonth = j;
                        break;
                    }
                }
            }
        }
        
    }
    if (self.defaultSelectedArr.count ==3) {
        NSString *year = self.defaultSelectedArr[0];
        NSString *month = self.defaultSelectedArr[1];
        NSString *day = self.defaultSelectedArr[2];
        for (NSInteger i=0; i<self.dateArr.count; i++) {
            NSDictionary *dict = self.dateArr[i];
            if ([year isEqualToString:dict[@"year"]]) {
                recordRowOfYear = i;
                NSArray *monthArray = dict[@"month"];
                for (NSInteger j=0; j<monthArray.count; j++) {
                    NSDictionary *monthDict = monthArray[j];
                    if ([month isEqualToString:monthDict[@"month"]]) {
                        recordRowOfMonth = j;
                        NSArray *dayArray = monthDict[@"day"];
                        for (NSInteger k=0; k<dayArray.count; k++) {
                            if ([day isEqualToString:dayArray[k]]) {
                                recordRowOfDay = k;
                                break;
                            }
                        }
                        
                    }
                }
            }
        }
    }
    if (self.defaultSelectedArr.count ==4) {
        NSString *year = self.defaultSelectedArr[0];
        NSString *month = self.defaultSelectedArr[1];
        NSString *day = self.defaultSelectedArr[2];
        for (NSInteger i=0; i<self.dateArr.count; i++) {
            NSDictionary *dict = self.dateArr[i];
            if ([year isEqualToString:dict[@"year"]]) {
                recordRowOfYear = i;
                NSArray *monthArray = dict[@"month"];
                for (NSInteger j=0; j<monthArray.count; j++) {
                    NSDictionary *monthDict = monthArray[j];
                    if ([month isEqualToString:monthDict[@"month"]]) {
                        recordRowOfMonth = j;
                        NSArray *dayArray = monthDict[@"day"];
                        for (NSInteger k=0; k<dayArray.count; k++) {
                            if ([day isEqualToString:dayArray[k]]) {
                                recordRowOfDay = k;
                                break;
                            }
                        }
                        
                    }
                }
            }
        }
        
        NSString *hours = self.defaultSelectedArr[3];
        for (NSInteger i=0; i<self.hourArray.count; i++) {
            if ([hours isEqualToString:self.hourArray[i]]) {
                recordRowOfHours = i;
                break;
            }
        }
        
    }
    if (self.defaultSelectedArr.count ==5) {
        NSString *year = self.defaultSelectedArr[0];
        NSString *month = self.defaultSelectedArr[1];
        NSString *day = self.defaultSelectedArr[2];
        for (NSInteger i=0; i<self.dateArr.count; i++) {
            NSDictionary *dict = self.dateArr[i];
            if ([year isEqualToString:dict[@"year"]]) {
                recordRowOfYear = i;
                NSArray *monthArray = dict[@"month"];
                for (NSInteger j=0; j<monthArray.count; j++) {
                    NSDictionary *monthDict = monthArray[j];
                    if ([month isEqualToString:monthDict[@"month"]]) {
                        recordRowOfMonth = j;
                        NSArray *dayArray = monthDict[@"day"];
                        for (NSInteger k=0; k<dayArray.count; k++) {
                            if ([day isEqualToString:dayArray[k]]) {
                                recordRowOfDay = k;
                                break;
                            }
                        }
                        
                    }
                }
            }
        }
        
        NSString *hours = self.defaultSelectedArr[3];
        for (NSInteger i=0; i<self.hourArray.count; i++) {
            if ([hours isEqualToString:self.hourArray[i]]) {
                recordRowOfHours = i;
                break;
            }
        }
        
        NSString *minute = self.defaultSelectedArr[4];
        for (NSInteger i=0; i<self.minuteArray.count; i++) {
            if ([minute isEqualToString:self.minuteArray[i]]) {
                recordRowOfMin = i;
                break;
            }
        }
        
        
    }
    
    
    [self scrollToRow:recordRowOfYear secondRow:recordRowOfMonth thirdRow:recordRowOfDay fourRow:recordRowOfHours fiveRow:recordRowOfMin];
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
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.pickerView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.pickerView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}


#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    NSLog(@"点击确定按钮后，执行block回调");
    [self dismissWithAnimation:YES];
    if(self.resultBlock) {
        //        NSArray *arr = [self getChooseCityArr];
        NSString *dateStr = [self getChooseCityArr];
        NSMutableArray *rowAry = [NSMutableArray array];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfYear]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfMonth]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfDay]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfHours]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfMin]];
        
        self.resultBlock(dateStr,rowAry);
    }
}

#pragma mark - 地址选择器
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.manager.kTopViewH + 0.5, SCR_WIDTH, self.manager.kPickerViewH)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.showsSelectionIndicator = NO;
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 5;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSDictionary *dict = self.dateArr[rowOfYear];
    NSArray *monthArray = dict[@"month"];
    NSArray *dayArray = monthArray[rowOfMonth][@"day"];
    
    if (component == 0) {
        //返回年个数
        return self.dateArr.count;
    }
    if (component == 1) {
        //返回月个数
        return monthArray.count;
    }
    if (component == 2) {
        //返回日个数
        return dayArray.count;
    }
    if (component == 3) {
        //返回日个数
        return self.hourArray.count;
    }
    if (component == 4) {
        //返回日个数
        return self.minuteArray.count;
    }
    return 0;
    
}

#pragma mark - PickerView的代理方法
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *showTitleValue = @"";
    if (component == 0) {//年
        NSDictionary *dict = self.dateArr[row];
        showTitleValue = dict[@"year"];
    }
    if (component == 1) {//月
        NSDictionary *dict = self.dateArr[rowOfYear];
        NSDictionary *monthDict = dict[@"month"][row];
        showTitleValue = monthDict[@"month"];
    }
    if (component == 2) {//日
        NSDictionary *dict = self.dateArr[rowOfYear];
        NSDictionary *monthDict = dict[@"month"][rowOfMonth];
        //        NSDictionary *dayDict = monthDict[@"day"][row];
        showTitleValue = monthDict[@"day"][row];
    }
    if (component == 3) {//时
        //        CGXProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
        //        CGXCityModel *cityModel = provinceModel.city[rowOfCity];
        //        CGXTownModel *townModel = cityModel.town[row];
        showTitleValue = self.hourArray[row];
    }
    if (component == 4) {//分
        //        CGXProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
        //        CGXCityModel *cityModel = provinceModel.city[rowOfCity];
        //        CGXTownModel *townModel = cityModel.town[row];
        showTitleValue = self.minuteArray[row];
    }
    return showTitleValue;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1 )
        {
            singleLine.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        }
        
        //        if (singleLine.frame.size.height == self.manager.rowHeight )
        //        {
        //            singleLine.backgroundColor = [UIColor whiteColor];
        //        }
        
    }
    //可以通过自定义label达到自定义pickerview展示数据的方式
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ceil(SCR_WIDTH / 5), self.manager.rowHeight)];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:self.manager.pickerTitleSize]];
        [pickerLabel setTextColor:self.manager.pickerTitleColor];
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];//调用上一个委托方法，获得要展示的title
    return pickerLabel;
    
}
//设置单元格的高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.manager.rowHeight;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSDictionary *beforeDict = self.dateArr[rowOfYear];
        NSArray *beforeMonthArray = beforeDict[@"month"];
        NSString *beforemonth = beforeMonthArray[rowOfMonth][@"month"];
        NSString *beforeDay = beforeMonthArray[rowOfMonth][@"day"][rowOfDay];
        
        rowOfYear = row;
        NSDictionary *dict = self.dateArr[row];
        NSArray *monthArray = dict[@"month"];
        for (NSInteger i = 0; i<monthArray.count; i++) {
            NSString *month = monthArray[i][@"month"];
            if ([beforemonth isEqualToString:month]) {
                rowOfMonth = i;
                break;
            }else{
                rowOfMonth = monthArray.count - 1;
            }
        }
        
        NSArray *dayArray = monthArray[rowOfMonth][@"day"];
        for (NSInteger i = 0; i<dayArray.count; i++) {
            NSString *day = dayArray[i];
            if ([beforeDay isEqualToString:day]) {
                rowOfDay = i;
                break;
            }else{
                rowOfDay = dayArray.count - 1;
            }
        }
        
    } else if (component == 1) {
        rowOfMonth = row;
        NSDictionary *dict = self.dateArr[rowOfYear];
        NSArray *monthArray = dict[@"month"];
        NSArray *dayArray = monthArray[row][@"day"];
        if (rowOfDay >= dayArray.count) {
            rowOfDay = dayArray.count - 1;
        }
        
    } else if (component == 2) {
        rowOfDay = row;
    } else if (component == 3) {
        rowOfHours = row;
    } else if (component == 4) {
        rowOfMin = row;
    }
    // 滚动到指定行
    [self scrollToRow:rowOfYear secondRow:rowOfMonth thirdRow:rowOfDay fourRow:rowOfHours fiveRow:rowOfMin];
    
    // 自动获取数据，滚动完就回调
    if (self.isAutoSelect) {
        NSString *dateStr = [self getChooseCityArr];
        NSMutableArray *rowAry = [NSMutableArray array];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfYear]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfMonth]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfDay]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfHours]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfMin]];
        
        if (self.resultBlock) {
            self.resultBlock(dateStr,rowAry);
        }
    }
}

#pragma mark - Tool
- (NSString *)getChooseCityArr {
    NSString *dateString;
    if (rowOfYear < self.dateArr.count) {
        NSDictionary *dict = self.dateArr[rowOfYear];
        NSArray *monthArray = dict[@"month"];
        if (rowOfMonth < monthArray.count) {
            NSDictionary *monthDict = monthArray[rowOfMonth];
            NSArray *dayArray = monthDict[@"day"];
            NSString *day;
            NSString *hours;
            NSString *minth;
            if (rowOfDay < dayArray.count) {
                day = dayArray[rowOfDay];
            }
            if (rowOfHours < self.hourArray.count) {
                hours = self.hourArray[rowOfHours];
            }
            if (rowOfMin < self.minuteArray.count) {
                minth = self.minuteArray[rowOfMin];
            }
            
            dateString = [NSString stringWithFormat:@"%@/%@/%@ %@:%@",dict[@"year"], monthDict[@"month"], day,hours,minth];
            dateString = [dateString stringByReplacingOccurrencesOfString:@"年" withString:@""];
            dateString = [dateString stringByReplacingOccurrencesOfString:@"月" withString:@""];
            dateString = [dateString stringByReplacingOccurrencesOfString:@"日" withString:@""];
            dateString = [dateString stringByReplacingOccurrencesOfString:@"时" withString:@""];
            dateString = [dateString stringByReplacingOccurrencesOfString:@"分" withString:@""];
        }
    }
    return dateString;
}

#pragma mark - 滚动到指定行
- (void)scrollToRow:(NSInteger)firstRow secondRow:(NSInteger)secondRow thirdRow:(NSInteger)thirdRow fourRow:(NSInteger)fourRow fiveRow:(NSInteger)fiveRow{
    if (firstRow < self.dateArr.count) {
        rowOfYear = firstRow;
        NSDictionary *dict = self.dateArr[firstRow];
        if (self.defaultSelectedArr.count == 2) {
            NSArray *monthArray = dict[@"month"];
            if (secondRow < monthArray.count) {
                rowOfMonth = secondRow;
                [self.pickerView reloadComponent:1];
            }
        }
        if (self.defaultSelectedArr.count == 3) {
            NSArray *monthArray = dict[@"month"];
            if (secondRow < monthArray.count) {
                rowOfMonth = secondRow;
                [self.pickerView reloadComponent:1];
                NSArray *dayArray = monthArray[secondRow];
                if (thirdRow < dayArray.count) {
                    rowOfDay = thirdRow;
                    [self.pickerView selectRow:firstRow inComponent:0 animated:YES];
                    [self.pickerView selectRow:secondRow inComponent:1 animated:YES];
                    [self.pickerView reloadComponent:2];
                    [self.pickerView selectRow:thirdRow inComponent:2 animated:YES];
                }
            }
        }
        if (self.defaultSelectedArr.count == 4) {
            NSArray *monthArray = dict[@"month"];
            if (secondRow < monthArray.count) {
                rowOfMonth = secondRow;
                [self.pickerView reloadComponent:1];
                NSArray *dayArray = monthArray[secondRow];
                if (thirdRow < dayArray.count) {
                    rowOfDay = thirdRow;
                    [self.pickerView reloadComponent:2];
                    if (fourRow < self.hourArray.count) {
                        rowOfHours = fourRow;
                        [self.pickerView selectRow:firstRow inComponent:0 animated:YES];
                        [self.pickerView selectRow:secondRow inComponent:1 animated:YES];
                        [self.pickerView selectRow:thirdRow inComponent:2 animated:YES];
                        [self.pickerView reloadComponent:3];
                        [self.pickerView selectRow:fourRow inComponent:3 animated:YES];
                    }
                }
            }
        }
        if (self.defaultSelectedArr.count == 5) {
            NSArray *monthArray = dict[@"month"];
            if (secondRow < monthArray.count) {
                rowOfMonth = secondRow;
                [self.pickerView reloadComponent:1];
                NSArray *dayArray = monthArray[secondRow][@"day"];
                if (thirdRow < dayArray.count) {
                    rowOfDay = thirdRow;
                    [self.pickerView reloadComponent:2];
                    if (fourRow < self.hourArray.count) {
                        rowOfHours = fourRow;
                        [self.pickerView reloadComponent:3];
                        if (fiveRow < self.minuteArray.count) {
                            rowOfMin = fiveRow;
                            [self.pickerView selectRow:firstRow inComponent:0 animated:YES];
                            [self.pickerView selectRow:secondRow inComponent:1 animated:YES];
                            [self.pickerView selectRow:thirdRow inComponent:2 animated:YES];
                            [self.pickerView selectRow:fourRow inComponent:3 animated:YES];
                            [self.pickerView reloadComponent:4];
                            [self.pickerView selectRow:fiveRow inComponent:4 animated:YES];
                        }
                    }
                    
                }
            }
        }
        
    }
    
    // 是否自动滚动回调
    if (/* DISABLES CODE */ (false)) {
        //        NSArray *arr = [self getChooseCityArr];
        NSString *dateStr = [self getChooseCityArr];
        NSMutableArray *rowAry = [NSMutableArray array];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfYear]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfMonth]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfDay]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfHours]];
        [rowAry addObject:[NSString stringWithFormat:@"%ld",rowOfMin]];
        if (self.resultBlock != nil) {
            self.resultBlock(dateStr,rowAry);
        }
    }
}


- (NSMutableArray *)dateArr {
    if (!_dateArr) {
        _dateArr = [[NSMutableArray alloc]init];
    }
    return _dateArr;
}

- (NSMutableArray *)hourArray {
    if (!_hourArray) {
        _hourArray = [[NSMutableArray alloc]init];
    }
    return _hourArray;
}

- (NSMutableArray *)minuteArray {
    if (!_minuteArray) {
        _minuteArray = [[NSMutableArray alloc]init];
    }
    return _minuteArray;
}


@end
