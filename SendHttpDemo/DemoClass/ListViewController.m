//
//  ListViewController.m
//  SendHttpDemo
//
//  Created by Luke on 2017/2/24.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "ListViewController.h"
#import "OKHttpRequestTools+OKExtension.h"

#define WEAKSELF(weakSelf)  __weak __typeof(&*self)weakSelf = self;

static NSString *kTestRequestUrl = @"http://lib33.wap.zol.com.cn/index.php?c=Advanced_List_V1&keyword=808.8GB%205400%E8%BD%AC%2032MB&noParam=1&priceId=noPrice&num=15";

static NSString * cellID = @"CollectionCellID";

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSDictionary *params;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    WEAKSELF(weakSelf)
    [self.tableView addheaderRefresh:^{
        [weakSelf requestData:YES];
    } footerBlock:^{
        [weakSelf requestData:NO];
    }];
    
    //重新请求数据
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新数据" style:UIBarButtonItemStylePlain target:self action:@selector(refreshDataAction)];
}

/**
 * 刷新数据
 */
- (void)refreshDataAction
{
    kTestRequestUrl = @"http://lib3.wap.zol.com.cn/index.php?c=Advanced_List_V1&keyword=808.8GB%205400%E8%BD%AC%2032MB&noParam=1&priceId=noPrice&num=15";
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *dic = self.tableDataArr[indexPath.row];
    cell.textLabel.text = dic[@"name"];
    cell.textLabel.numberOfLines = 1;
    return cell;
}

/**
 * 发送请求
 */
- (void)requestData:(BOOL)firstPage
{
    if (firstPage) {
        self.pageNum = 1;
    } else {
        self.pageNum ++;
    }
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[@"page"] = @(self.pageNum);
    self.params = info;
    
    OKHttpRequestModel *model = [[OKHttpRequestModel alloc] init];
    model.requestType = OKHttpRequestTypeGET;
    model.parameters = info;
    model.requestUrl = kTestRequestUrl; //可以试着把地址写错,测试请求失败的场景
    
    model.loadView = self.view;
    model.dataTableView = self.tableView;
//    model.sessionDataTaskArr = self.sessionDataTaskArr;
//    model.requestCachePolicy = RequestStoreCacheData;
    
    NSLog(@"发送请求中====%zd",self.pageNum);
    [OKHttpRequestTools sendExtensionRequest:model success:^(id returnValue) {
        if (self.params != info) return;
        if (firstPage) {
            [self.tableDataArr removeAllObjects];
        }
        [self.tableDataArr addObjectsFromArray:returnValue[@"data"]];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        if (!firstPage) self.pageNum --;
    }];
}

- (void)dealloc
{
    NSLog(@"DemoVC dealloc");
}

@end
