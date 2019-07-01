//
//  GYPickerViewManager.h
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYPickerViewManager : NSObject

@property (nonatomic , assign) CGFloat kPickerViewH;
@property (nonatomic , assign) CGFloat kTopViewH;

@property (nonatomic , strong) UIColor *pickerTitleColor;//字体颜色
@property (nonatomic , assign) CGFloat pickerTitleSize;//字体大小


@property (nonatomic , strong) UIColor *lineViewColor;//分割线颜色
@property (nonatomic , strong) UIColor *titleLabelColor;//头部标题颜色
@property (nonatomic , assign) CGFloat titleSize;//头部字体大小
@property (nonatomic , assign) CGFloat rowHeight; //单元格高度 默认50

@property (nonatomic , strong) UIColor *rightBtnTitleColor;//右侧标题颜色
@property (nonatomic , strong) UIColor *rightBtnBGColor;//右侧标题背景颜色
@property (nonatomic , assign) CGFloat rightBtnTitleSize;//字体大小

@end

NS_ASSUME_NONNULL_END
