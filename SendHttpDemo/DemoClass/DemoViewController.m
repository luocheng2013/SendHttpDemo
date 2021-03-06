//
//  DemoViewController.m
//  SendHttpDemo
//
//  Created by Luke on 2017/2/24.
//  Copyright © 2017年 okdeer. All rights reserved.
//

#import "DemoViewController.h"
#import "ListViewController.h"
#import "MyCollectionDataVC.h"
#import "OKRequestTipBgView.h"
//发送封装多功能请求用到
#import "OKHttpRequestTools+OKExtension.h"
//发送普通请求用到
#import "OKHttpRequestTools.h"
#import <OKAlertView.h>

//请求测试地址1
#define TestRequestUrl1      @"http://api.cnez.info/product/getProductList/1"
//请求测试地址2
#define TestRequestUrl2      @"http://lib3.wap.zol.com.cn/index.php?c=Advanced_List_V1&keyword=808.8GB%205400%E8%BD%AC%2032MB&noParam=1&priceId=noPrice&num=15"

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"多功能请求工具";
}

- (IBAction)sendListHttpRequestAction:(id)sender
{
    ListViewController *listVC = [[ListViewController alloc] init];
    listVC.title = @"UItableView测试";
    listVC.hidesBottomBarWhenPushed = YES;
    listVC.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController pushViewController:listVC animated:YES];
}

/**
 测试发送不同请求
 */
- (IBAction)sendNomalHttpRequestAction:(id)sender
{
    MyCollectionDataVC *listVC = [[MyCollectionDataVC alloc] init];
    listVC.title = @"UICollectionView测试";
    listVC.hidesBottomBarWhenPushed = YES;
    listVC.edgesForExtendedLayout = UIRectEdgeNone;
    [self.navigationController pushViewController:listVC animated:YES];
    return;
    
    //    //测试同时发送50个请求, 底层会自动管理
    //    for (int i=0; i<20; i++) {
    //
    //        //测试发送普通请求
    //        [self sendCommomReq];
    //
    //        //测试发送封装多功能请求
    //        //[self sendMultifunctionReq:i];
    //    }
    
    //    //测试发送普通请求
    //    [self sendCommomReq];
    
    //测试发送普通请求
//    [self sendMultifunctionReq:0];
}

/**
 * 发送封装多功能请求
 */
- (void)sendMultifunctionReq:(int)tag
{
    OKHttpRequestModel *model = [[OKHttpRequestModel alloc] init];
    model.requestType = OKHttpRequestTypeGET;
    model.parameters = nil;
    model.requestUrl = TestRequestUrl2;
    
    model.loadView = self.view;
    //model.dataTableView = self.tableView;//如果页面有表格可传入会自动处理很多事件
    //model.sessionDataTaskArr = self.sessionDataTaskArr; //传入,则自动管理取消请求的操作
    //model.requestCachePolicy = RequestStoreCacheData; //需要保存底层网络数据
    
    NSURLSessionDataTask *task = [OKHttpRequestTools sendExtensionRequest:model success:^(id returnValue) {
        NSLog(@"不错哦, 请求成功了");
        ShowAlertToast(@"请求成功,请查看打印日志");

    } failure:^(NSError *error) {
        NSLog(@"悲剧哦, 请求失败了");
        ShowAlertToast(@"悲剧哦, 请求失败了");
    }];
    
    NSLog(@"发送请求中===%zd===%@",tag,task);
    //    if (tag == 49) {
    //        NSLog(@"取消所有请求后, 底层不会回调成功或失败到页面上来");
    //        [self cancelRequestOperations];
    //    }
}

/**
 * 发送普通请求
 */
- (void)sendCommomReq
{
    OKHttpRequestModel *model = [[OKHttpRequestModel alloc] init];
    model.requestType = OKHttpRequestTypeGET;
    model.parameters = nil;
    model.requestUrl = TestRequestUrl1;
    
    NSURLSessionDataTask *task = [OKHttpRequestTools sendOKRequest:model success:^(id returnValue) {
        NSLog(@"发送普通请求, 不错哦, 请求成功了");
        ShowAlertToast(@"请求成功,请查看打印日志");

    } failure:^(NSError *error) {
        NSLog(@"发送普通请求, 悲剧哦, 请求失败了");
        ShowAlertToast(@"悲剧哦, 请求失败了");
    }];
    
    NSLog(@"测试发送普通请求===%@",task);
}

@end
