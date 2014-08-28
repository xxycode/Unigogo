//
//  ProfileViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-10.
//  Copyright (c) 2014年 xxy. All rights reserved.
//gettopicpre
//getuserinfo

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    currPage = 1;
    [self.view setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    topicTableView = [[XxyTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - (64 - navBarH))];
    [topicTableView setDelegate:self];
    [topicTableView setDataSource:self];
    [topicTableView setBackgroundColor:[UIColor clearColor]];
    [topicTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 180)];
    [headView setBackgroundColor:[UIColor clearColor]];
    proHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 30, 60, 60, 60)];
    [proHeadImage setBackgroundColor:[UIColor whiteColor]];
    [headView addSubview:proHeadImage];
    zheView = [[UIView alloc] initWithFrame:CGRectMake(0, 180, kScreenWidth, 110)];
    [zheView setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 145, kScreenWidth, 20)];
    [usernameLabel setTextAlignment:NSTextAlignmentCenter];
    [usernameLabel setBackgroundColor:[UIColor clearColor]];
    //[usernameLabel setText:@"我是叉叉歪"];
    [usernameLabel setTextColor:UIColorFromRGB(0xcfcfcf)];
    [headView addSubview:usernameLabel];
    [topicTableView setTableHeaderView:headView];
    headBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 280 - 450, kScreenWidth, 450)];
    [headBackgroundView setImage:[UIImage imageNamed:@"profilebg.png"]];
    [self.view addSubview:headBackgroundView];
    [self.view addSubview:zheView];
    [self.view addSubview:topicTableView];
    [self loadTableView:NO];
    refreshControl = [[ODRefreshControl alloc] initInScrollView:topicTableView];
    [refreshControl setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
    [refreshControl setActivityIndicatorViewColor:UIColorFromRGB(0x99cc00)];
    [refreshControl addTarget:self action:@selector(reAct) forControlEvents:UIControlEventValueChanged];
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (navBarH - 44) + 7, 32, 30)];
    [backBtn setImage:[UIImage imageNamed:@"proback.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popAct) forControlEvents:UIControlEventTouchUpInside];
    
    editBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 32, (navBarH - 44) + 7, 32, 30)];
    [editBtn setImage:[UIImage imageNamed:@"proset.png"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(toSetViewController) forControlEvents:UIControlEventTouchUpInside];
    
    if (_editAble) {
        [self.view addSubview:editBtn];
    }
    [self.view addSubview:backBtn];
    ProfileViewController *sV = self;
    [topicTableView setMoreBtn:YES normalTitle:@"点击加载更多" loadingTitle:@"正在玩命加载" noMoreTit:@"已经加载完全部"];
    [topicTableView setLoBlock:^{
        [sV loadMoreAct];
    }];
    [self getUserInfo];
}

- (void)toSetViewController
{
    if (perViewController == nil) {
        perViewController= [[PersonSetViewController alloc] init];
    }
    perViewController.userImage = proHeadImage.image;
    perViewController.nickName = usernameLabel.text;
    perViewController.sex = sex;
    __block ProfileViewController *sV = self;
    [perViewController setFinishBlock:^{
        [sV reAct];
    }];
    [self.navigationController pushViewController:perViewController animated:YES];
}

- (void)loadMoreAct
{
    NSInteger tmpPage = currPage + 1;
    if (_uid != nil) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/gettopicpre?token=%@&page=%@",kHost,token,[NSString stringWithFormat:@"%d",tmpPage]];
        [req setFinishBlock:^(NSData *data){
            [self finishLoadMore:data];
        }];
        [req setFailedBlock:^(NSError *err){
            [self failedLoadData];
        }];
        [req startAsyncWithUrl:[NSURL URLWithString:url]];
    }else{
        XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/gettopicpre?uid=%@&page=%@",kHost,_uid,[NSString stringWithFormat:@"%d",tmpPage]];
        [req setFinishBlock:^(NSData *data){
            [self finishLoadMore:data];
        }];
        [req setFailedBlock:^(NSError *err){
            [self failedLoadData];
        }];
        [req startAsyncWithUrl:[NSURL URLWithString:url]];
    }

}

- (void)finishLoadMore:(NSData *)data
{
    currPage ++;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    if ([arr isKindOfClass:[NSNull class]]) {
        [topicTableView setHaveMore:NO];
        [topicTableView fininshedLoadMore];
        return;
    }
    for (NSDictionary *dic in arr) {
        TopicItem *item = [[TopicItem alloc] init];
        [item setDic:dic];
        [tmpArr addObject:item];
    }
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:topicTableView.dataArr];
    [newArr addObjectsFromArray:tmpArr];
    [topicTableView setDataArr:newArr];
    [topicTableView reloadData];
    [topicTableView fininshedLoadMore];
}

- (void)loadTableView:(BOOL)reAct
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在加载";
    }
    if (!reAct) {
        [HUD show:YES];
    }
    if (_uid == nil) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
        XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/gettopicpre?token=%@",kHost,token];
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        [postDic setObject:token forKey:@"token"];
        [req setPostDataDic:postDic];
        [req setFinishBlock:^(NSData *data){
            [self finishLoadData:data];
        }];
        [req setFailedBlock:^(NSError *err){
            [self failedLoadData];
        }];
        [req startAsyncWithUrl:[NSURL URLWithString:url]];
    }else{
        XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
        NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/gettopicpre?uid=%@",kHost,_uid];
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        [req setPostDataDic:postDic];
        [req setFinishBlock:^(NSData *data){
            [self finishLoadData:data];
        }];
        [req setFailedBlock:^(NSError *err){
            [self failedLoadData];
        }];
        [req startAsyncWithUrl:[NSURL URLWithString:url]];
    }
}

- (void)finishLoadData:(NSData *)data
{
    [HUD setHidden:YES];
    [topicTableView setHaveMore:YES];
    currPage = 1;
    [refreshControl endRefreshing];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    if ([arr isKindOfClass:[NSNull class]]) {
        //[MBProgressHUD showMsg:self.view title:@"你还没有发表帖子" delay:1];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [topicTableView setDataArr:arr];
        [topicTableView setHaveMore:NO];
        [topicTableView reloadData];
        [topicTableView setFinishedLoadData:YES];
        return;
    }
    for (NSDictionary *dic in arr) {
        TopicItem *item = [[TopicItem alloc] init];
        [item setDic:dic];
        [tmpArr addObject:item];
    }
    if (arr.count < 15) {
        [topicTableView setHaveMore:NO];
    }
    [topicTableView setFinishedLoadData:YES];
    [topicTableView setDataArr:tmpArr];
    [topicTableView reloadData];
    [topicTableView setFinishedLoadData:YES];
}

- (void)getUserInfo
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *url;
    if (_uid == nil) {
        url = [NSString stringWithFormat:@"%@/community/index.php/index/getuserinfo?token=%@",kHost,token];
    }else{
        url = [NSString stringWithFormat:@"%@/community/index.php/index/getuserinfo?uid=%@",kHost,_uid];
    }
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self getInfoFinish:data];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)getInfoFinish:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *info = [dic objectForKey:@"info"];
    NSString *pic_url = [info objectForKey:@"pic_url"];
    NSString *nickname = [info objectForKey:@"nickname"];
    NSString *sexStr = [info objectForKey:@"sex"];
    sex = sexStr.integerValue;
    if ([pic_url isEqualToString:@"empty"]) {
        [proHeadImage setImage:[UIImage imageNamed:@"defuser.png"]];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/community/Public/Uploads/%@", pic_url];
        [proHeadImage sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    [usernameLabel setText:nickname];
}

- (void)reAct
{
    [self loadTableView:YES];
}

- (void)failedLoadData
{
    if ([refreshControl refreshing]) {
        [refreshControl endRefreshing];
    }
    [topicTableView fininshedLoadMore];
    [HUD hide:YES];
    [MBProgressHUD showMsg:self.view title:@"加载失败，请检查网络" delay:1];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topicTableView.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat h = kVersion >= 7.0? 65:45;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, h)];
    [view setBackgroundColor:[UIColor whiteColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10 + (navBarH - 44), kScreenWidth, 25)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:[NSString stringWithFormat:@"帖子 %d",topicTableView.dataArr.count]];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" personal:NO deleteAble:_editAble];
    }
    TopicItem *item = [topicTableView.dataArr objectAtIndex:indexPath.row];
    [cell setDelPreActionBlock:^(NSIndexPath *indexPath,NSString *tid){
        delTid = tid;
        [self deleteTopic:indexPath tid:tid];
    }];
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
            TopicItem *item = [topicTableView.dataArr objectAtIndex:indexPath.row];
            TopicDetailViewController *detailView = [[TopicDetailViewController alloc] init];
            [detailView setItem:item];
            [self.navigationController pushViewController:detailView animated:YES];
        }
    }];
    [cell setIndexPath:indexPath];
    [cell setItem:item];
    [cell setBackgroundColor:UIColorFromRGB(0xcfcfcf)];
    return cell;
}

- (void)deleteTopic:(NSIndexPath *)indexPath tid:(NSString *)tid
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在加载";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"你确定要删除吗？"
                                                       delegate:self cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定",nil];
    [alertView show];
    [HUD show:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        if (_uid == nil || [_uid isEqualToString:str]) {
            NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
            XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
            NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/deletetopic",kHost];
            NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
            [postDic setObject:token forKey:@"access_token"];
            [postDic setObject:delTid forKey:@"tid"];
            [req setPostDataDic:postDic];
            [req setFinishBlock:^(NSData *data){
                [self reAct];
            }];
            [req setFailedBlock:^(NSError *err){
                [self failedLoadData];
            }];
            [req startAsyncWithUrl:[NSURL URLWithString:url]];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicItem *item = [topicTableView.dataArr objectAtIndex:indexPath.row];
    return [TopicCell cellHeightForItem:item isPer:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TopicItem *item = [topicTableView.dataArr objectAtIndex:indexPath.row];
    TopicDetailViewController *detailView = [[TopicDetailViewController alloc] init];
    [detailView setItem:item];
    [self.navigationController pushViewController:detailView animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    if (point.y <= 0) {
        //NSLog(@"%f",point.y);
        CGRect f = headBackgroundView.frame;
        f.origin.y = 280 - 450 - point.y/1.5;
        [headBackgroundView setFrame:f];
    }else{
        CGRect f = headBackgroundView.frame;
        f.origin.y = 280 - 450 - point.y;
        [headBackgroundView setFrame:f];
    }
    if (point.y < 180) {
        [backBtn setImage:[UIImage imageNamed:@"proback.png"] forState:UIControlStateNormal];
        if (_editAble) {
            [editBtn setImage:[UIImage imageNamed:@"proset.png"] forState:UIControlStateNormal];
        }
    }else{
        [backBtn setImage:[UIImage imageNamed:@"probackk.png"] forState:UIControlStateNormal];
        if (_editAble) {
            [editBtn setImage:[UIImage imageNamed:@"prosett.png"] forState:UIControlStateNormal];
        }
    }
    CGRect fr = zheView.frame;
    fr.origin.y = 180 - point.y;
    [zheView setFrame:fr];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (kVersion >= 7.0) {
        return 65;
    }else{
        return 45;
    }
}

- (void)popAct
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"社区个人中心"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"社区个人中心"];
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
