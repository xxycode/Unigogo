//
//  CommunityViewController.m
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "CommunityViewController.h"
#import "MBProgressHUD.h"
#import "UIImage+ImageEffects.h"
#import "KxMenu.h"
#import "TopicItem.h"
#import "TopicCell.h"
#import "LoginViewController.h"
#import "CommentViewController.h"
#import "TopicDetailViewController.h"
#import "MyFavComViewController.h"

@interface CommunityViewController ()

@end

@implementation CommunityViewController

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
    [self setTitle:@"Go社区"];
    [self initViews];
    // Do any additional setup after loading the view.
}


#pragma mark - 界面布局
- (void)initViews
{
    isLoadingMore = NO;
    currPage = 1;
    backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //[self.view addSubview:backgroundView];
    [backgroundView setUserInteractionEnabled:YES];
    [backgroundView setImage:[UIImage imageNamed:@"community.png"]];
    [self.view bringSubviewToFront:self.navView];
    //[self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    UIButton *navMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 43, 5+(navBarH - 44), 43, 34)];
    [navMoreButton setBackgroundImage:[UIImage imageNamed:@"nav_more_nor.png"] forState:UIControlStateNormal];
    [navMoreButton setBackgroundImage:[UIImage imageNamed:@"nav_more_f.png"] forState:UIControlStateHighlighted];
    [navMoreButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:navMoreButton];
    
    topicItemTableView = [[XxyTableView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64)];
    refreshControl = [[ODRefreshControl alloc] initInScrollView:topicItemTableView];
    [refreshControl setTintColor:UIColorFromRGB(0x99cc00)];
    [refreshControl setActivityIndicatorViewColor:UIColorFromRGB(0x99cc00)];
    [refreshControl addTarget:self action:@selector(reAct) forControlEvents:UIControlEventValueChanged];
    [topicItemTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topicItemTableView];
    
    [self.view bringSubviewToFront:self.navView];
    //[self performSelector:@selector(so) withObject:nil afterDelay:0.5];
    [topicItemTableView setMoreBtn:YES];
    [topicItemTableView setDelegate:self];
    [topicItemTableView setDataSource:self];
    [topicItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [topicItemTableView setBackgroundColor:[UIColor clearColor]];
    //[lostItemTableView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight - 20 - 50 - 25)];
    CommunityViewController *sV = self;
    [topicItemTableView setReBlock:^{
        //[sV reAct];
    }];
    [topicItemTableView setMoreBtn:YES normalTitle:@"点击加载更多" loadingTitle:@"正在玩命加载" noMoreTit:@"已经加载完全部"];
    [topicItemTableView setLoBlock:^{
        [sV loadMoreAct];
    }];
    [self loadTableData];
}

- (void)reAct
{
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self finishRefreshData:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedRe];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/community/index.php/index/gettopiclist"]];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/community/index.php/index/gettopiclist?token=%@",token];
        [req startAsyncWithUrl:[NSURL URLWithString:url]];
    }
}

- (void)failedRe
{
    [MBProgressHUD showMsg:topicItemTableView title:@"加载失败，请检查网络" delay:2];
    [refreshControl endRefreshing];
}

- (void)loadTableData
{
    NSData *cacheData = [[NSUserDefaults standardUserDefaults] objectForKey:kCCache];
    if (cacheData != nil) {
        [self finishLoadData:cacheData];
        return;
    }
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    HUD.labelText = @"正在加载";
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [HUD hide:YES];
        [self finishLoadData:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/community/index.php/index/gettopiclist"]];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/community/index.php/index/gettopiclist?token=%@",token];
        [req startAsyncWithUrl:[NSURL URLWithString:url]];
    }
}

- (void)loadMoreAct
{
    if (isLoadingMore) {
        return;
    }
    isLoadingMore = YES;
    NSInteger tmpPage = currPage + 1;
    NSString *url;
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        url = [NSString stringWithFormat:@"%@/community/index.php/index/gettopiclist?page=%ld",kHost,(long)tmpPage];
    }else{
        url = [NSString stringWithFormat:@"%@/community/index.php/index/gettopiclist?page=%ld&token=%@",kHost,(long)tmpPage,token];
    }
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self finishLoadMore:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [MBProgressHUD showMsg:topicItemTableView title:@"加载失败，请检查网络" delay:2];
        [topicItemTableView fininshedLoadMore];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishLoadMore:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    if (![arr isKindOfClass:[NSNull class]]) {
        if (arr.count > 0) {
            currPage ++;
            NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:topicItemTableView.dataArr];
            for (NSDictionary *dic in arr) {
                TopicItem *item = [[TopicItem alloc] init];
                [item setDic:dic];
                [tmpArr addObject:item];
            }
            [topicItemTableView setDataArr:tmpArr];
            [topicItemTableView reloadData];
            [topicItemTableView fininshedLoadMore];
        }
    }else{
        topicItemTableView.haveMore = NO;
        [topicItemTableView fininshedLoadMore];
    }
    isLoadingMore = NO;
}

- (void)finishLoadData:(NSData *)data
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in arr) {
        TopicItem *item = [[TopicItem alloc] init];
        [item setDic:dic];
        [tmpArr addObject:item];
    }
    [topicItemTableView setFinishedLoadData:YES];
    [topicItemTableView setDataArr:tmpArr];
    [topicItemTableView reloadData];
}

- (void)finishRefreshData:(NSData *)data
{
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCCache];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in arr) {
        TopicItem *item = [[TopicItem alloc] init];
        
        [item setDic:dic];
        [tmpArr addObject:item];
    }
    [topicItemTableView setDataArr:tmpArr];
    [topicItemTableView reloadData];
    [refreshControl endRefreshing];
}

- (void)failedLoadData
{
    [HUD hide:YES];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    [btn setTitle:@"加载失败，点击重试" forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn setTag:101];
    [btn setCenter:topicItemTableView.center];
    [btn addTarget:self action:@selector(loadTableData) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topicItemTableView.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    TopicItem *item = [topicItemTableView.dataArr objectAtIndex:indexPath.row];
    [cell setNoToken:^{
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }];
    [cell setComBlock:^(BOOL hasOne,NSString *tid){
        if (!hasOne) {
            CommentViewController *commentVC = [[CommentViewController alloc] init];
            [commentVC setTid:tid];
            [self presentViewController:commentVC animated:YES completion:nil];
        }else{
            TopicItem *item = [topicItemTableView.dataArr objectAtIndex:indexPath.row];
            TopicDetailViewController *detailView = [[TopicDetailViewController alloc] init];
            [detailView setItem:item];
            [self.navigationController pushViewController:detailView animated:YES];
        }
    }];
    [cell setShowProfileBlock:^(NSString *uid){
        ProfileViewController *profiVC = [[ProfileViewController alloc] init];
        NSString *suid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        if (suid == nil || ![suid isEqualToString:uid]) {
            [profiVC setEditAble:NO];
        }else{
            [profiVC setEditAble:YES];
        }
        [profiVC setUid:uid];
        [self.navigationController pushViewController:profiVC animated:YES];
    }];
    [cell setItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicItem *item = [topicItemTableView.dataArr objectAtIndex:indexPath.row];
    return [TopicCell cellHeightForItem:item isPer:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicItem *item = [topicItemTableView.dataArr objectAtIndex:indexPath.row];
    TopicDetailViewController *detailView = [[TopicDetailViewController alloc] init];
    [detailView setItem:item];
    [self.navigationController pushViewController:detailView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
                                                 action:@selector(showMyFav)]
                                   ]];
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        KxMenuItem *item =  [KxMenuItem menuItem:@"登录"
                                           image:[UIImage imageNamed:@"userSet.png"]
                                          target:self
                                          action:@selector(logIn)];
        [menuItems addObject:item];
    }else{
        KxMenuItem *item =  [KxMenuItem menuItem:@"个人中心"
                                           image:[UIImage imageNamed:@"userSet.png"]
                                          target:self
                                          action:@selector(showProf)];
        [menuItems addObject:item];
    }
    //[KxMenu setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.25]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)newInfo
{
    
    NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (access_token == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [loginViewController setDisBlock:^{
            NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
            if (access_token != nil) {
                NewTopicViewController *newInfo = [[NewTopicViewController alloc] init];
                [self presentViewController:newInfo animated:YES completion:nil];
            }
        }];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }else{
        NewTopicViewController *newInfo = [[NewTopicViewController alloc] init];
        [self presentViewController:newInfo animated:YES completion:nil];
    }
}


- (void)showMyFav
{
    MyFavComViewController *favVc = [[MyFavComViewController alloc] init];
    [favVc setPopBlock:^{
        [self reAct];
    }];
    [self.navigationController pushViewController:favVc animated:YES];
}

- (void)logIn
{
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)showProf
{
    ProfileViewController *profiVC = [[ProfileViewController alloc] init];
    [profiVC setEditAble:YES];
    [self.navigationController pushViewController:profiVC animated:YES];
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [topicItemTableView didScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [topicItemTableView didEndDraging:scrollView];
}

//- (void)showMenu
//{
//    UIView *bView = [[UIView alloc] initWithFrame:self.view.bounds];
//    [bView setTag:245];
//    [bView setBackgroundColor:[UIColor clearColor]];
//    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBview)];
//    [bView addGestureRecognizer:tapGR];
//    CGRect rect =self.view.frame;
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self.view.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    UIImageView *imagView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    [imagView setBackgroundColor:[UIColor clearColor]];
//    [imagView setUserInteractionEnabled:YES];
//    [bView addSubview:imagView];
//    [self.view addSubview:bView];
//    [bView setAlpha:0.0f];
//    if (kVersion >= 7.0) {
//        UIImage *bimg = [img applyBlurWithRadius:4.0 tintColor:[UIColor colorWithWhite:1.0 alpha:0.3] saturationDeltaFactor:0.8 maskImage:img];
//        [imagView setImage:bimg];
//        [UIView animateWithDuration:0.35 animations:^{
//            [bView setAlpha:1.0f];
//        }];
//    }else{
//        [imagView removeFromSuperview];
//        [bView setBackgroundColor:[UIColor whiteColor]];
//        [UIView animateWithDuration:0.35 animations:^{
//            [bView setAlpha:0.7f];
//        }];
//    }
//    
//}
//- (void)dismissBview
//{
//    UIView *view = (UIView *)[self.view viewWithTag:245];
//    [UIView animateWithDuration:0.35 animations:^{
//        [view setAlpha:0.0f];
//    } completion:^(BOOL com){
//        [view removeFromSuperview];
//    }];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"社区"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"社区"];
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
