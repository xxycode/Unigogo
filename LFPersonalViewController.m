//
//  LFPersonalViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-2.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LFPersonalViewController.h"
#import "Xxyhttprequest.h"
#import "LostItem.h"
#import "LostItemCell.h"
#import "KxMenu.h"
#import "LoginViewController.h"
#import "NewinfoViewController.h"
#import "MKNetworkEngine.h"
#import "XxyHttpRequest.h"

@interface LFPersonalViewController ()

@end

@implementation LFPersonalViewController


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
    [self setTitle:@"我发表的信息"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    currCellIndex = 0;
    currPage = 1;
    backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundView];
    [backgroundView setUserInteractionEnabled:YES];
    [backgroundView setImage:[UIImage imageNamed:@"loginbg.png"]];
    [self.view bringSubviewToFront:self.navView];
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3]];
    isLoadingMore = NO;
    CGFloat navH = kVersion >= 7.0? 64:44;
    lostItemTableView = [[XxyTableView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight - 64) ];
    refreshControl = [[ODRefreshControl alloc] initInScrollView:lostItemTableView];
    [refreshControl setTintColor:UIColorFromRGB(0x99cc00)];
    [refreshControl setActivityIndicatorViewColor:UIColorFromRGB(0x99cc00)];
    [refreshControl addTarget:self action:@selector(reAct) forControlEvents:UIControlEventValueChanged];
    [lostItemTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lostItemTableView];
    [self.view bringSubviewToFront:self.navView];
    if (kVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //[self performSelector:@selector(so) withObject:nil afterDelay:0.5];
    [lostItemTableView setMoreBtn:YES];
    [lostItemTableView setDelegate:self];
    [lostItemTableView setDataSource:self];
    
    [lostItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [lostItemTableView setBackgroundColor:[UIColor clearColor]];
    //[lostItemTableView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight - 20 - 50 - 25)];
    LFPersonalViewController *sV = self;
    [lostItemTableView setReBlock:^{
        [sV reAct];
    }];
    [lostItemTableView setMoreBtn:YES normalTitle:@"点击加载更多" loadingTitle:@"正在玩命加载" noMoreTit:@"已经加载完全部"];
    [lostItemTableView setLoBlock:^{
        [sV loadMoreAct];
    }];
    [self loadTableData];
}

- (void)dismissMorView
{
    [KxMenu dismissMenu];
}


- (void)loadMoreAct
{
    if (!isLoadingMore) {
        isLoadingMore = YES;
        XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        currPage ++;
        [postDic setObject:[NSString stringWithFormat:@"%ld",(long)currPage] forKey:@"page"];
        [req setPostDataDic:postDic];
        [req setFinishBlock:^(NSData *data){
            [self finishLoadMore:data];
        }];
        [req setFailedBlock:^(NSError *err){
            [self failedLoadMore];
        }];
        [req setProgressBlock:^(float curr){
            
        }];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/lostandfound/index.php/index/getpersonalitems?token=%@",token];
        [req startAsyncWithUrl:[NSURL URLWithString:url]];
    }else{
        return;
    }
    
}

- (void)finishLoadMore:(NSData *)data
{
    isLoadingMore = NO;
    NSMutableArray *oldArr = lostItemTableView.dataArr;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    if ([arr class] == [NSNull class]) {
        lostItemTableView.haveMore = NO;
        return;
    }
    if (arr.count == 0) {
        lostItemTableView.haveMore = NO;
        [lostItemTableView fininshedLoadMore];
        return;
    }
    if (arr.count < 10) {
        lostItemTableView.haveMore = NO;
    }
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in arr) {
        LostItem *item = [[LostItem alloc] init];
        [item setDic:itemDic];
        [tmpArr addObject:item];
    }
    [oldArr addObjectsFromArray:tmpArr];
    [lostItemTableView setDataArr:oldArr];
    [lostItemTableView reloadData];
    [lostItemTableView fininshedLoadMore];
}

- (void)failedLoadMore
{
    [MBProgressHUD showMsg:backgroundView title:@"网络出错，请检查网络" delay:2];
}


- (void)loadTableData
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:101];
    if (btn != nil) {
        [btn removeFromSuperview];
    }
    HUD = [[MBProgressHUD alloc] initWithView:backgroundView];
    [backgroundView addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    HUD.labelText = @"正在加载";
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self finishLoadData:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/lostandfound/index.php/index/getpersonalitems?token=%@",token];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishLoadData:(NSData *)data
{
    //    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@",str);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    if ([arr class] == [NSNull class]) {
        [self failedLoadData];
        return;
    }
    if ([arr count] == 0) {
        [HUD hide:YES];
        MBProgressHUD *infoH = [[MBProgressHUD alloc] initWithView:self.view];
        [backgroundView addSubview:infoH];
        infoH.labelText = @"你还没有发布信息哦~";
        infoH.mode = MBProgressHUDModeText;
        [infoH updateIndicators];
        [infoH show:YES];
        [infoH hide:YES afterDelay:2];
        return;
    }
    for (NSDictionary *itemDic in arr) {
        LostItem *item = [[LostItem alloc] init];
        [item setDic:itemDic];
        [tmpArr addObject:item];
    }
    if (lostItemTableView.finishedLoadData) {
        [refreshControl endRefreshing];
    }
    LostItem *item = [tmpArr objectAtIndex:0];
    topId = item.lid;
    [HUD hide:YES];
    [lostItemTableView setDataArr:tmpArr];
    [lostItemTableView reloadData];
    [lostItemTableView setFinishedLoadData:YES];
}

- (void)failedLoadData
{
    [HUD hide:YES];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [btn setTitle:@"加载失败，点击重试" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setTag:101];
    [btn setCenter:lostItemTableView.center];
    [btn addTarget:self action:@selector(loadTableData) forControlEvents:UIControlEventTouchUpInside];
}



- (void)reAct
{
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/lostandfound/index.php/index/refreshitems?id=%@&token=%@",topId,token];
    [req setFinishBlock:^(NSData *data){
        [self finishRefresh:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedRefresh];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishRefresh:(NSData *)data
{
    NSMutableArray *oldArr = lostItemTableView.dataArr;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    if ([arr class] == [NSNull class]) {
        [refreshControl endRefreshing];
        return;
    }
    if (arr.count == 0) {
        [refreshControl endRefreshing];
        return;
    }
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in arr) {
        LostItem *item = [[LostItem alloc] init];
        [item setDic:itemDic];
        [tmpArr addObject:item];
    }
    LostItem *item = [tmpArr objectAtIndex:0];
    topId = [NSString stringWithString:item.lid];
    [tmpArr addObjectsFromArray:oldArr];
    [lostItemTableView setDataArr:tmpArr];
    [lostItemTableView reloadData];
    [refreshControl endRefreshing];
    
}
- (void)failedRefresh
{
    [self failedLoadMore];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return lostItemTableView.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfy = @"cell";
    LostItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
    if (cell == nil) {
        cell = [[LostItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy personal:YES deleteAble:YES];
    }
    LostItem *item = [lostItemTableView.dataArr objectAtIndex:indexPath.row];
    [cell setIndexPath:indexPath];
    [cell setDelPreActionBlock:^(NSIndexPath *indexPath,NSString *lid){
        [self delAct:indexPath lid:lid];
    }];
    [cell setItem:item];
    return cell;
}

- (void)delAct:(NSIndexPath *)indexPath lid:(NSString *)lid
{

    MBProgressHUD *myHud = [[MBProgressHUD alloc] initWithView:backgroundView];
    [backgroundView addSubview:myHud];
    [myHud setTag:245];
    [myHud show:YES];
    myHud.labelText = @"正在加载";
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/lostandfound/index.php/index/deleteItem?token=%@&id=%@",kHost,token,lid];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self finishDelete:data cellPath:indexPath lid:lid];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedRefresh];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishDelete:(NSData *)data cellPath:(NSIndexPath *)indexPath lid:(NSString *)lid
{
    MBProgressHUD *myHud = (MBProgressHUD *)[backgroundView viewWithTag:245];
    [myHud setHidden:YES];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if ([dic isKindOfClass:[NSNull class]]) {
        [self failedLoadMore];
    }
    NSString *status = [dic objectForKey:@"status"];
    if ([status isEqualToString:@"1"]) {
        MBProgressHUD *tmpH = [[MBProgressHUD alloc] initWithView:backgroundView];
        [backgroundView addSubview:tmpH];
        [tmpH setAnimationType:MBProgressHUDAnimationZoom];
        tmpH.labelText = @"删除成功";
        [tmpH setMode:MBProgressHUDModeText];
        [tmpH updateIndicators];
        [tmpH show:YES];
        [tmpH hide:YES afterDelay:2];
        NSMutableArray *arr = [NSMutableArray arrayWithArray:lostItemTableView.dataArr];
        for (LostItem *item in arr) {
            if ([item.lid isEqualToString:lid]) {
                [arr removeObject:item];
                break;
            }
        }
        NSArray *newArr = [NSArray arrayWithArray:arr];
        [lostItemTableView beginUpdates];
        [lostItemTableView setDataArr:[NSMutableArray arrayWithArray:newArr]];
        if (newArr.count == 0) {
            lostItemTableView.haveMore = NO;
        }
        NSArray *delArr = [NSArray arrayWithObject:indexPath];
        [lostItemTableView deleteRowsAtIndexPaths:delArr withRowAnimation:UITableViewRowAnimationMiddle];
        [lostItemTableView endUpdates];
        [self performSelector:@selector(reloadLostTable) withObject:nil afterDelay:0.35f];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)reloadLostTable
{
    [lostItemTableView reloadData];
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row > currCellIndex) {
//        cell.alpha = 0.3;
//
//        CGAffineTransform transformScale = CGAffineTransformMakeScale(1.5, 1.5);
//        CGAffineTransform transformTranslate = CGAffineTransformMakeTranslation(0, 0);
//
//        cell.transform = CGAffineTransformConcat(transformScale, transformTranslate);
//
//        [tableView bringSubviewToFront:cell];
//        [UIView animateWithDuration:0.35 animations:^{
//            cell.alpha = 1;
//            //clear the transform
//            cell.transform = CGAffineTransformIdentity;
//        } completion:nil];
//    }
//    currCellIndex = indexPath.row;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LostItem *item = [lostItemTableView.dataArr objectAtIndex:indexPath.row];
    CGFloat h = [LostItemCell cellHeightForItem:item isPer:YES];
    return h;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [lostItemTableView didScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [lostItemTableView didEndDraging:scrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)newInfo
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (access_token == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [loginViewController setDisBlock:^{
            NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
            if (access_token != nil) {
                NewinfoViewController *newInfo = [[NewinfoViewController alloc] init];
                [self presentViewController:newInfo animated:YES completion:nil];
            }
        }];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }else{
        NewinfoViewController *newInfo = [[NewinfoViewController alloc] init];
        
        [self presentViewController:newInfo animated:YES completion:nil];
    }
}

- (void)pushMenuItem:(id)sender
{
    NSLog(@"%@",sender);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"失物个人"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"失物个人"];
}

@end
