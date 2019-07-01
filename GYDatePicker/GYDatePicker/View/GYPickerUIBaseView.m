//
//  GYPickerUIBaseView.m
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import "GYPickerUIBaseView.h"

@implementation GYPickerUIBaseView

#pragma mark - 初始化子视图
- (void)initUI {
    
    self.frame = SCR_BOUNDS;
    // 背景遮罩图层
    [self addSubview:self.backgroundView];
    // 弹出视图
    [self addSubview:self.alertView];
    // 设置弹出视图子视图
    // 添加顶部标题栏
    [self.alertView addSubview:self.topView];
    // 添加右边取消按钮
    [self.topView addSubview:self.rightBtn];
    // 添加标题
    [self.topView addSubview:self.titleLabel];
    // 添加分割线
    [self.topView addSubview:self.lineView];
    
}

- (GYPickerViewManager *)manager
{
    if (!_manager ) {
        _manager = [[GYPickerViewManager alloc]init];
    }
    return _manager;
}

#pragma mark - 背景遮罩图层
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        _backgroundView.backgroundColor = RGB_COLOR_OPACITY(26, 28, 35, 0.9);
        _backgroundView.userInteractionEnabled = YES;
        UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapBackgroundView:)];
        [_backgroundView addGestureRecognizer:myTap];
    }
    return _backgroundView;
}

#pragma mark - 弹出视图
- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - self.manager.kTopViewH - self.manager.kPickerViewH, SCR_WIDTH, self.manager.kTopViewH + self.manager.kPickerViewH)];
        _alertView.backgroundColor = [UIColor whiteColor];
    }
    return _alertView;
}

#pragma mark - 顶部标题栏视图
- (UIView *)topView {
    if (!_topView) {
        _topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCR_WIDTH, self.manager.kTopViewH + 1)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}


#pragma mark - 右边确定按钮
- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCR_WIDTH - self.manager.kTopViewH, 0, self.manager.kTopViewH, self.manager.kTopViewH);
        [_rightBtn setTitleColor:RGB_COLOR(34, 34, 34) forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _rightBtn;
}

#pragma mark - 左边标题按钮
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 0, SCR_WIDTH - self.manager.kTopViewH - 24, self.manager.kTopViewH)];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = RGB_COLOR(40, 124, 223);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

#pragma mark - 分割线
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.manager.kTopViewH, SCR_WIDTH, 1)];
        _lineView.backgroundColor  = self.manager.lineViewColor;
    }
    return _lineView;
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
}

@end
