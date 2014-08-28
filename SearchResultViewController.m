//
//  SearchResultViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "SearchResultViewController.h"
#import "BookItemRes.h"
#import "BookResViewCell.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

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
    [self setTitle:@"搜索结果"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    resList = [[XxyTableView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 66)];
    [resList setMoreBtn:YES normalTitle:@"点击加载更多" loadingTitle:@"正在玩命加载" noMoreTit:@"已经加载完全部"];
    SearchResultViewController *sV = self;
    [resList setLoBlock:^{
        [sV loadMoreAct];
    }];
    [self.view addSubview:resList];
    [resList setDataSource:self];
    [resList setDelegate:self];
    [self loadData];
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD setLabelText:@"正在加载"];
    }
    [HUD show:YES];
}

- (void)loadData
{
    curr = 1;
    NSString *url = [NSString stringWithFormat:@"%@/library/index.php/index/searchbook/",kHost];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:_keyWord forKey:@"keyword"];
    [postDic setObject:_ktype forKey:@"ktype"];
    [postDic setObject:_mtype forKey:@"mtype"];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setPostDataDic:postDic];
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
    [HUD hide:YES];
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *count = [dic objectForKey:@"count"];
    if (count.integerValue == 0) {
        [MBProgressHUD showMsg:self.view title:@"没有找到你想要的书" delay:1.5];
        [resList setHaveMore:NO];
        return;
    }
    pages = count.integerValue;
    if (count.integerValue == 1) {
        [resList setHaveMore:NO];
    }
    [self setTitle:[NSString stringWithFormat:@"搜索结果(%@条)",count]];
    NSString *pag = [dic objectForKey:@"pages"];
    pages = pag.integerValue;
    NSArray *dataArr = [dic objectForKey:@"data"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in dataArr) {
        BookItemRes *item = [[BookItemRes alloc] init];
        [item setDic:itemDic];
        [tmpArr addObject:item];
    }
    resArr = tmpArr;
    [resList setFinishedLoadData:YES];
    [resList reloadData];
}

- (void)failedLoad
{
    [HUD setHidden:YES];
    [MBProgressHUD showMsg:self.view title:@"加载失败，请检查网络" delay:1.5];
}
#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return resArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookResViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[BookResViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    BookItemRes *item = [resArr objectAtIndex:indexPath.row];
    [cell setItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

#pragma mark 加载更多

- (void)loadMoreAct
{
    curr ++;
    NSString *url = [NSString stringWithFormat:@"%@/library/index.php/index/searchbook/",kHost];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:_keyWord forKey:@"keyword"];
    [postDic setObject:_ktype forKey:@"ktype"];
    [postDic setObject:_mtype forKey:@"mtype"];
    [postDic setObject:[NSString stringWithFormat:@"%d",curr] forKey:@"page"];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setPostDataDic:postDic];
    [req setFinishBlock:^(NSData *data){
        [self finishLoadMore:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoad];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishLoadMore:(NSData *)data
{
    if (curr >= pages) {
        [resList setHaveMore:NO];
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArr = [dic objectForKey:@"data"];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:resArr];
    for (NSDictionary *itemDic in dataArr) {
        BookItemRes *item = [[BookItemRes alloc] init];
        [item setDic:itemDic];
        [tmpArr addObject:item];
    }
    resArr = tmpArr;
    [resList fininshedLoadMore];
    [resList reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"图书搜索结果"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"图书搜索结果"];
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
