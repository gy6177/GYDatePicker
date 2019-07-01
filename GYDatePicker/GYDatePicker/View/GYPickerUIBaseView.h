//
//  GYPickerUIBaseView.h
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYPickerViewManager.h"

@interface GYPickerUIBaseView : UIView

@property (nonatomic, strong) GYPickerViewManager *manager;
// 背景视图
@property (nonatomic, strong) UIView *backgroundView;
// 弹出视图
@property (nonatomic, strong) UIView *alertView;
// 顶部视图
@property (nonatomic, strong) UIView *topView;

// 右边取消按钮
@property (nonatomic, strong) UIButton *rightBtn;
// 左边标题
@property (nonatomic, strong) UILabel *titleLabel;
// 头部分割线视图
@property (nonatomic, strong) UIView *lineView;

/** 初始化子视图 */
- (void)initUI;

/** 点击背景遮罩图层事件 */
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender;

/** 确定按钮的点击事件 */
- (void)clickRightBtn;

@end
