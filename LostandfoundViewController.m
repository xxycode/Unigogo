//
//  LostandfoundViewController.m
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LostandfoundViewController.h"
#import "Xxyhttprequest.h"
#import "LostItem.h"
#import "LostItemCell.h"
#import "KxMenu.h"
#import "LoginViewController.h"
#import "NewinfoViewController.h"
#import "MKNetworkEngine.h"
#import "LFPersonalViewController.h"
#import "MyFavViewController.h"
#import "APService.h"

@interface LostandfoundViewController ()

@end

@implementation LostandfoundViewController


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
    [self setTitle:@"失物招领"];
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
    UIButton *navMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 43, 5+(navBarH - 44), 43, 34)];
    [navMoreButton setBackgroundImage:[UIImage imageNamed:@"nav_more_nor.png"] forState:UIControlStateNormal];
    [navMoreButton setBackgroundImage:[UIImage imageNamed:@"nav_more_f.png"] forState:UIControlStateHighlighted];
    [navMoreButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:navMoreButton];
    lostItemTableView = [[XxyTableView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64)];
    refreshControl = [[ODRefreshControl alloc] initInScrollView:lostItemTableView];
    [refreshControl setTintColor:UIColorFromRGB(0x99cc00)];
    [refreshControl setActivityIndicatorViewColor:UIColorFromRGB(0x99cc00)];
    [refreshControl addTarget:self action:@selector(reAct) forControlEvents:UIControlEventValueChanged];
    [lostItemTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lostItemTableView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMorView)];
    [self.view addGestureRecognizer:tapGR];
    
    [self.view bringSubviewToFront:self.navView];
    //[self performSelector:@selector(so) withObject:nil afterDelay:0.5];
    [lostItemTableView setMoreBtn:YES];
    [lostItemTableView setDelegate:self];
    [lostItemTableView setDataSource:self];
    [lostItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [lostItemTableView setBackgroundColor:[UIColor clearColor]];
    //[lostItemTableView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight - 20 - 50 - 25)];
    LostandfoundViewController *sV = self;
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
        [postDic setObject:[NSString stringWithFormat:@"%d",currPage] forKey:@"page"];
        [req setPostDataDic:postDic];
        [req setFinishBlock:^(NSData *data){
            [self finishLoadMore:data];
        }];
        [req setFailedBlock:^(NSError *err){
            [self failedLoadMore];
        }];
        [req setProgressBlock:^(float curr){
            
        }];
        [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/lostandfound/index.php/api/getitems"]];
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
    NSData *cacheData = [[NSUserDefaults standardUserDefaults] objectForKey:kLCache];
    if (cacheData != nil) {
        [self finishLoadData:cacheData];
        return;
    }
    UIButton *btn = (UIButton *)[self.view viewWithTag:101];
    if (btn != nil) {
        [btn removeFromSuperview];
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
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
    [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/lostandfound/index.php/api/getitems"]];
}

- (void)finishLoadData:(NSData *)data
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    if ([arr class] == [NSNull class]|[arr count] <= 0) {
        [self failedLoadData];
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
    NSString *url = [NSString stringWithFormat:@"%@/lostandfound/index.php/api/getitems",kHost];
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
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        cell = [[LostItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy];
    }
    LostItem *item = [lostItemTableView.dataArr objectAtIndex:indexPath.row];
    [cell setItem:item];
    return cell;
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
    CGFloat h = [LostItemCell cellHeightForItem:item isPer:NO];
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

- (void)showMenu:(UIButton *)sender
{
    NSMutableArray *menuItems = [NSMutableArray arrayWithArray:
                                 @[
                                   
                                   [KxMenuItem menuItem:@"发布信息"
                                                  image:[UIImage imageNamed:@"newInfo.png"]
                                                 target:self
                                                 action:@selector(newInfo)],
                                   
                                   [KxMenuItem menuItem:@"我的收藏"
                                                  image:[UIImage imageNamed:@"favItem.png"]
                                                 target:self
                                                 action:@selector(showMyFav)],
                                   [KxMenuItem menuItem:@"我发表的"
                                                  image:[UIImage imageNamed:@"mysItem.png"]
                                                 target:self
                                                 action:@selector(showPersonalItems)],
                                   ]];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
       KxMenuItem *item =  [KxMenuItem menuItem:@"登录"
                                          image:[UIImage imageNamed:@"userSet.png"]
                                         target:self
                                         action:@selector(logIn)];
        [menuItems addObject:item];
    }else{
        KxMenuItem *item =  [KxMenuItem menuItem:@"注销"
                                           image:[UIImage imageNamed:@"userSet.png"]
                                          target:self
                                          action:@selector(logOut)];
        [menuItems addObject:item];
    }
    //[KxMenu setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)showMyFav
{
    MyFavViewController *myFavVC = [[MyFavViewController alloc] init];
    [self.navigationController pushViewController:myFavVC animated:YES];
}

- (void)showPersonalItems
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (access_token == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [loginViewController setDisBlock:^{
            NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
            if (access_token != nil) {
                LFPersonalViewController *lfVC = [[LFPersonalViewController alloc] init];
                [self.navigationController pushViewController:lfVC animated:YES];
            }
        }];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }else{
        //NSLog(@"%@",access_token);
        LFPersonalViewController *lfVC = [[LFPersonalViewController alloc] init];
        [self.navigationController pushViewController:lfVC animated:YES];
    }
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

- (void)logIn
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)logOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nowUser"];
    [APService setAlias:@"nil" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self logIn];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)pushMenuItem:(id)sender
{
    NSLog(@"%@",sender);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"失物招领"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"失物招领"];
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
