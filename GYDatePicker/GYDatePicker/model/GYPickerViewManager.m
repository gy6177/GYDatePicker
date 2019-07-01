//
//  GYPickerViewManager.m
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import "GYPickerViewManager.h"

@implementation GYPickerViewManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _kPickerViewH = 290;
        _kTopViewH = 50;
        _pickerTitleSize  = 14;
        _pickerTitleColor = RGB_COLOR(34, 34, 34);
        _lineViewColor = RGB_COLOR(232,232,232);
        
        _titleLabelColor = RGB_COLOR(40, 124, 223);
        _titleSize = 14;
        _rowHeight = 50;
        
        _rightBtnTitleSize = 14;
        _rightBtnTitleColor = RGB_COLOR(34, 34, 34);
        _rightBtnBGColor = [UIColor whiteColor];
        
    }
    return self;
}

@end
