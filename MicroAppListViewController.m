//
//  MicroAppListViewController.m
//  Unigogo
//
//  Created by xxy on 14-8-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MicroAppListViewController.h"
#import "XxyHttpRequest.h"
#import "WebContentViewController.h"
#import "MicAppCell.h"

@interface MicroAppListViewController ()

@end

@implementation MicroAppListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"轻应用列表"];
    [self initViews];
    [self loadData];
    // Do any additional setup after loading the view.
}

//http://218.244.137.199/campus/index.php/index/qapplist
- (void)initViews
{
    dataArr = [[NSArray alloc] init];
    dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64)];
    [dataTableView setDelegate:self];
    [dataTableView setDataSource:self];
    [dataTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:dataTableView];
}

- (void)loadData
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [HUD setLabelText:@"正在加载"];
        [self.view addSubview:HUD];
    }
    [HUD show:YES];
    NSString *url = [NSString stringWithFormat:@"%@/campus/index.php/index/qapplist",kHost];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self finishedLoad:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoad];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishedLoad:(NSData *)data
{
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    dataArr = arr;
    [dataTableView reloadData];
    [HUD hide:YES];
}

- (void)failedLoad
{
    [MBProgressHUD showMsg:self.view title:@"加载失败，网络出错" delay:1.5];
    [HUD hide:YES];
}

#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    MicAppCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
         cell = [[[NSBundle mainBundle] loadNibNamed:@"MicAppCell"  owner:self options:nil] lastObject];
    }
    [cell setDic:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [dataArr objectAtIndex:indexPath.row];
    NSString *url = [dic objectForKey:@"url"];
    WebContentViewController *webCVc = [[WebContentViewController alloc] init];
    [webCVc setUrl:url];
    [self.navigationController pushViewController:webCVc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"轻应用"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"轻应用"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
