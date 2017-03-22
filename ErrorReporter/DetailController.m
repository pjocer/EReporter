//
//  DetailController.m
//  ErrorReporter
//
//  Created by Jocer on 2017/3/21.
//  Copyright © 2017年 Jocer. All rights reserved.
//

#import "DetailController.h"
#import <AFNetworking.h>
#import <Masonry.h>
#import "DetailCell.h"
#import <MJRefresh.h>
#import <MJExtension.h>

#define LISTS @"http://172.20.40.133:9091/code/lists"
@interface DetailController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *source;
@end

@implementation DetailController

- (instancetype)initWithParams:(NSDictionary *)param {
    self = [super init];
    if (self) {
        self.param = param;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.source = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailCell" bundle:nil] forCellReuseIdentifier:@"DetailCellIdentifier"];
    static NSInteger page = 0;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 0;
        [self requestData:page];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        page++;
        [self requestData:page];
    }];
    self.title = [NSString stringWithFormat:@"%@",self.param[@"code"]];
    [self.tableView.mj_header beginRefreshing];
}

- (void)requestData:(NSInteger)page {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(page) forKey:@"page"];
    [params setValue:@(20) forKey:@"rows"];
    [params addEntriesFromDictionary:self.param];
    page==0?[self.source removeAllObjects]:nil;
    [[AFHTTPSessionManager manager] POST:LISTS parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.source addObjectsFromArray:[NSMutableArray mj_objectArrayWithKeyValuesArray:responseObject]];
        NSLog(@"%@",responseObject);
        [self.tableView reloadData];
        [self hiddenMJRefresh];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [self hiddenMJRefresh];
    }];
}

- (void)hiddenMJRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.source objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"※※※Device※※※\n%@",dic[@"deviceid"]];
    NSString *message = [NSString stringWithFormat:@"※※※app_msg※※※\n%@",dic[@"app_msg"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    for (NSString *key in dic.allKeys) {
        if ([key isEqualToString:@"app_msg"] || [key isEqualToString:@"deviceid"]) {
            continue;
        }
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            NSString *orgin = [NSString stringWithFormat:@"%@:%@",key,dic[key]];
            NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:orgin];
            [attrText addAttributes:@{ NSForegroundColorAttributeName : [UIColor brownColor] } range:NSMakeRange(0, key.length)];
            textField.attributedText = attrText;
            textField.adjustsFontSizeToFitWidth = YES;
            textField.enabled = NO;
        }];
    }
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.source.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCellIdentifier"];
    NSDictionary *dic = [self.source objectAtIndex:indexPath.row];
    [cell configureCell:dic];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
