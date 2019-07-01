//
//  ViewController.m
//  GYDatePicker
//
//  Created by IMAC on 2019/7/1.
//  Copyright © 2019 IMAC. All rights reserved.
//

#import "ViewController.h"
#import "GYDatePickerView.h"
#import "GYSystemDateView.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) NSMutableArray *dataArray;

@property (nonatomic , strong) NSMutableArray *vcArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView reloadData];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:
                      @"系统DatePicker-年月日时分",
                      @"自定义DatePicker-年月日时分",
                      nil];
    }
    return _dataArray;
}

-(NSMutableArray *)vcArray
{
    if (_vcArray == nil) {
        _vcArray = [NSMutableArray arrayWithObjects:
                      @"GYSystemDatePickerViewController",
                      @"GYDatePickerViewController",
                      nil];
    }
    
    return _vcArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView  =[[UITableView alloc] initWithFrame:CGRectMake(0, StatuesH, self.view.frame.size.width, self.view.frame.size.height-StatuesH) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Class class = NSClassFromString(self.vcArray[indexPath.row]);
//    UIViewController *viewcontroller = [[class alloc]init];
//    [self.navigationController pushViewController:viewcontroller animated:YES];
    __weak typeof(self) weakSelf = self;
    if (indexPath.row == 0) {
        
        [GYSystemDateView showDatePickerWithTitle:[Utility getCurrentDateSecond] DateType:UIDatePickerModeDateAndTime DefaultSelValue:[Utility getCurrentDateSecond] MinDateStr:[Utility getDateSixMonthsFromNow] MaxDateStr:[Utility getDateSixMonthsToNow] IsAutoSelect:NO ResultBlock:^(NSString *selectValue) {
            weakSelf.navigationItem.title = selectValue;;
        }];
        
    }else{
        NSArray *defaultSelValueArr = @[[NSString stringWithFormat:@"%ld年",[Utility getCurrentYear:[NSDate date]]],[NSString stringWithFormat:@"%ld月",[Utility getCurrentMonth:[NSDate date]]],[NSString stringWithFormat:@"%ld日",[Utility getCurrentDay:[NSDate date]]],[NSString stringWithFormat:@"%ld时",[Utility getCurrentHour]],[NSString stringWithFormat:@"%.2ld分",[Utility getCurrentMinute]]];

        [GYDatePickerView showDatePickerWithTitle:[Utility getCurrentDateSecond] DefaultSelected:defaultSelValueArr IsAutoSelect:NO Manager:nil ResultBlock:^(NSString *selectValue, NSArray *selectRow) {
            weakSelf.navigationItem.title = selectValue;;
        }];
    }
}

@end
