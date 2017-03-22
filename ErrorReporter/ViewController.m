//
//  ViewController.m
//  ErrorReporter
//
//  Created by Jocer on 2017/3/21.
//  Copyright © 2017年 Jocer. All rights reserved.
//

#import "ViewController.h"
#import "OptionCell.h"
#import <AFNetworking.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "NSDate+Extension.h"
#import <MJExtension/MJExtension.h>
#import "DetailController.h"

#define COUNTLISTS @"http://172.20.40.133:9091/code/countlists"


@interface ViewController () 
@property (weak, nonatomic) IBOutlet UIButton *platform;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *source;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (assign, nonatomic) NSInteger type; //1 platform 2 start 3 end 4 code
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.source = [NSMutableArray array];
    self.params = [NSMutableDictionary dictionary];
    [self.tableView registerNib:[UINib nibWithNibName:@"OptionCell" bundle:nil] forCellReuseIdentifier:@"OptionCellIdentifier"];
    
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSince1970:[NSDate timeIntervalFromString:@"2015-01-01 00:00" Formate:DEFAULT_TIME_FORMATE2]];
    self.datePicker.maximumDate = [NSDate date];
    self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [[_datePicker rac_signalForControlEvents:UIControlEventAllEvents] subscribeNext:^(UIDatePicker *datePicker) {
        NSString *time = [datePicker.date stringFromFormate:DEFAULT_TIME_FORMATE2];
        if (self.type == 2) {
            [self.startButton setTitle:time forState:UIControlStateNormal];
        }
        if (self.type == 3) {
            [self.endButton setTitle:time forState:UIControlStateNormal];
        }
    }];
    UIBarButtonItem *cancleItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancle)];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [self.toolBar setItems:@[cancleItem,space, saveItem]];
    [[RACObserve(self, params) filter:^BOOL(NSDictionary *value) {
        return value.count==3;
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
        [self.source removeAllObjects];
        [self.tableView reloadData];
        [[AFHTTPSessionManager manager] POST:COUNTLISTS parameters:x progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.source = [NSMutableArray mj_objectArrayWithKeyValuesArray:responseObject];
            NSLog(@"%@",self.source);
            self.type = 4;
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }];
}
- (void)cancle {
    [self showTableView:YES showDatePicker:NO];
    if (self.type==2) {
        self.params[@"start_time"]?:[self.startButton setTitle:@"请选择" forState:UIControlStateNormal];
    } else if (self.type==3) {
        self.params[@"end_time"]?:[self.endButton setTitle:@"请选择" forState:UIControlStateNormal];
    }
}
- (void)save {
    [self showTableView:YES showDatePicker:NO];
    if (self.type==2) {
        int interval = [NSDate timeIntervalFromString:self.startButton.titleLabel.text Formate:DEFAULT_TIME_FORMATE2];
        
        if (interval==0) {
            [self.startButton setTitle:[[NSDate date] stringFromFormate:DEFAULT_TIME_FORMATE2] forState:UIControlStateNormal];
            interval = [[NSDate date] timeIntervalSince1970];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.params];
        [dic setObject:@(interval) forKey:@"start_time"];
        self.params = dic;
    }
    if (self.type==3) {
        int interval = [NSDate timeIntervalFromString:self.endButton.titleLabel.text Formate:DEFAULT_TIME_FORMATE2];
        if (interval==0) {
            [self.endButton setTitle:[[NSDate date] stringFromFormate:DEFAULT_TIME_FORMATE2] forState:UIControlStateNormal];
            interval = [[NSDate date] timeIntervalSince1970];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.params];
        [dic setObject:@(interval) forKey:@"end_time"];
        self.params = dic;
    }
}
- (IBAction)platformAction:(UIButton *)sender {
    self.type = 1;
    [self showTableView:YES showDatePicker:NO];
    self.source = [NSMutableArray arrayWithArray:@[@{@"code":@"iOS"},@{@"code":@"android"}, @{@"code":@"全部"}]];
    [self.tableView reloadData];
}
- (IBAction)startTimeAction:(UIButton *)sender {
    self.type = 2;
    self.datePicker.date = self.params[@"start_time"]?[NSDate dateWithTimeIntervalSince1970:[self.params[@"start_time"] integerValue]]:[NSDate date];
    [self showTableView:NO showDatePicker:YES];
}
- (IBAction)endTimeAction:(UIButton *)sender {
    self.type = 3;
    self.datePicker.date = self.params[@"end_time"]?[NSDate dateWithTimeIntervalSince1970:[self.params[@"end_time"] integerValue]]:[NSDate date];
    [self showTableView:NO showDatePicker:YES];
}

- (void)showTableView:(BOOL)tableView showDatePicker:(BOOL)datePicker {
    self.tableView.hidden = !tableView;
    self.toolBar.hidden = !datePicker;
    self.datePicker.hidden = !datePicker;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type==1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.source[indexPath.row][@"code"];
        return cell;
    } else {
        OptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCellIdentifier"];
        [cell setData:self.source[indexPath.row]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type==1) {
        NSString *text = [self.source[indexPath.row] objectForKey:@"code"];
        [self.platform setTitle:text forState:UIControlStateNormal];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:self.params];
        [dic setObject:[text isEqualToString:@"全部"]?@"":text forKey:@"platform"];
        self.params = dic;
    } else {
        NSDictionary *dic = [self.source objectAtIndex:indexPath.row];
        NSMutableDictionary *dicx = [NSMutableDictionary dictionaryWithDictionary:self.params];
        [dicx setObject:dic[@"code"] forKey:@"code"];
        [dicx setObject:dic[@"app_tag"]?:@"Tag" forKey:@"app_tag"];
        DetailController *detail = [[DetailController alloc] initWithParams:dicx];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
