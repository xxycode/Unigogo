//
//  TopicDetailViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-8.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "TopicDetailViewController.h"

#import "CommentViewCell.h"
#import "CommentViewController.h"
#import "LoginViewController.h"

@interface TopicDetailViewController ()

@end

@implementation TopicDetailViewController

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
    [self setTitle:@"正文"];
    [self initViews];
    // Do any additional setup after loading the view.
}
//{"data":[]}
- (void)initViews
{
    commentTableView = [[XxyTableView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64 - 45)];
    [self.view addSubview:commentTableView];
    [commentTableView setDataSource:self];
    [commentTableView setDelegate:self];
    [commentTableView setBackgroundColor:[UIColor clearColor]];
    
    refreshControl = [[ODRefreshControl alloc] initInScrollView:commentTableView];
    [refreshControl setTintColor:UIColorFromRGB(0x99cc00)];
    [refreshControl setActivityIndicatorViewColor:UIColorFromRGB(0x99cc00)];
    [refreshControl addTarget:self action:@selector(reAct) forControlEvents:UIControlEventValueChanged];
    headView = [[TopicView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    
    if (_item != nil) {
        [headView setItem:_item];
        [self loadToolView];
    }else{
        [self loadItemWithTid:_tid];
    }
}

- (void)loadItemWithTid:(NSString *)tid
{
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/getitem?tid=%@",kHost,tid];
    [req setFinishBlock:^(NSData *data){
        [self finisheLoadItem:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finisheLoadItem:(NSData *)data
{
    TopicItem *item = [[TopicItem alloc] init];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [item setDic:dic];
    _item = item;
    [headView setItem:_item];
    [self loadToolView];
}

- (void)failedLoadItem
{
    [self failedLoadData];
}

- (void)loadToolView
{
    [commentTableView setTableHeaderView:headView];
    UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - (64 - navBarH) - 40, kScreenWidth, 40)];
    [toolView setBackgroundColor:UIColorFromRGB(0x24292c)];
    shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (100 - 27)/2, 8, 27, 24)];
    [shareBtn setImage:[UIImage imageNamed:@"tshare.png"] forState:UIControlStateNormal];
    
    commentBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (100 - 27)/2 + 100, 8, 27, 24)];
    [commentBtn setImage:[UIImage imageNamed:@"tcomment.png"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(commentAct) forControlEvents:UIControlEventTouchUpInside];
    
    zanBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 + (100 - 27)/2 + 200, 8, 27, 24)];
    if (_item.zanAble) {
        [zanBtn setImage:[UIImage imageNamed:@"tzan.png"] forState:UIControlStateNormal];
    }else{
        [zanBtn setImage:[UIImage imageNamed:@"tzaned.png"] forState:UIControlStateNormal];
    }
    [zanBtn addTarget:self action:@selector(zanAct) forControlEvents:UIControlEventTouchUpInside];
    
    [toolView addSubview:shareBtn];
    [toolView addSubview:commentBtn];
    [toolView addSubview:zanBtn];
    [self.view addSubview:toolView];
    [self loadCommentData];
}

- (void)loadCommentData
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    [HUD show:YES];
    HUD.labelText = @"正在加载";
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    
    if (token != nil) {
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        [postDic setObject:token forKey:@"access_token"];
        [req setPostDataDic:postDic];
    }
    NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/getcommentlist?tid=%@",kHost,_item.tid];
    [req setFinishBlock:^(NSData *data){
        [self finishLoadData:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)commentAct
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    [commentVC setTid:_item.tid];
    [self presentViewController:commentVC animated:YES completion:nil];
}

- (void)reAct
{
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token != nil) {
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        [postDic setObject:token forKey:@"access_token"];
        [req setPostDataDic:postDic];
    }
    NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/getcommentlist?tid=%@",kHost,_item.tid];
    [req setFinishBlock:^(NSData *data){
        [self reFinish:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];

}

- (void)zanAct
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    if (!_item.zanAble) {
        XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        [postDic setObject:token forKey:@"access_token"];
        [postDic setObject:_item.tid forKey:@"tid"];
        [req setPostDataDic:postDic];
        [req setFinishBlock:^(NSData *data){
            [self delZanFinish:data];
        }];
        [req setFailedBlock:^(NSError *err){
            [self failedLoadData];
        }];
        [req setProgressBlock:^(float curr){
            
        }];
        [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/community/index.php/index/delzan"]];
        return;
    }
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:token forKey:@"access_token"];
    [postDic setObject:_item.tid forKey:@"tid"];
    [req setPostDataDic:postDic];
    [req setFinishBlock:^(NSData *data){
        [self zanFinish:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/community/index.php/index/addzan"]];
    if (handView == nil) {
        handView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 27, 24)];
    }
    [handView setCenter:zanBtn.center];
    [handView setImage:[UIImage imageNamed:@"tzaned.png"]];
    [zanBtn.superview addSubview:handView];
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	handView.layer.opacity = 1.0;
	[CATransaction commit];
	CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.fromValue = [NSValue valueWithCGPoint:handView.layer.position];
	positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(200, -120)];
	CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	boundsAnimation.fromValue = [NSValue valueWithCGRect:handView.layer.bounds];
	boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	opacityAnimation.toValue = [NSNumber numberWithFloat:0.f];
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
	rotateAnimation.toValue = [NSNumber numberWithFloat:-0.25 * M_PI];
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.beginTime = CACurrentMediaTime() + 0.5;
	group.duration = 1;
	group.animations = [NSArray arrayWithObjects:positionAnimation, boundsAnimation, opacityAnimation, rotateAnimation, nil];
	group.delegate = self;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	[handView.layer addAnimation:group forKey:@"moveh"];
    [self performSelector:@selector(removeHand) withObject:nil afterDelay:1.5];
}

- (void)removeHand
{
    [handView removeFromSuperview];
}

- (void)zanFinish:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [dic objectForKey:@"status"];
    if ([status isEqual:@"1"]) {
        _item.zanAble = NO;
        [zanBtn setImage:[UIImage imageNamed:@"tzaned.png"] forState:UIControlStateNormal];
    }
}

- (void)delZanFinish:(NSData *)data
{
    [zanBtn setImage:[UIImage imageNamed:@"tzan.png"] forState:UIControlStateNormal];
    _item.zanAble = YES;
}

- (void)reFinish:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([str isEqualToString:@"{\"data\":[]}"]) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [commentTableView setDataArr:arr];
        [commentTableView reloadData];
        [refreshControl endRefreshing];
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    NSArray *arr = [dic objectForKey:@"data"];
    for (NSDictionary *dic in arr) {
        CommentItem *item = [[CommentItem alloc] init];
        [item setDic:dic];
        [tmpArr addObject:item];
    }
    [commentTableView setDataArr:tmpArr];
    [commentTableView reloadData];
    [refreshControl endRefreshing];

}

- (void)finishLoadData:(NSData *)data
{
    [HUD setHidden:YES];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([str isEqualToString:@"{\"data\":[]}"]) {
        //NSLog(@"no");
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    NSArray *arr = [dic objectForKey:@"data"];
    for (NSDictionary *dic in arr) {
        CommentItem *item = [[CommentItem alloc] init];
        [item setDic:dic];
        [tmpArr addObject:item];
    }
    [commentTableView setDataArr:tmpArr];
    [commentTableView reloadData];
}

- (void)failedLoadData
{
    [MBProgressHUD showMsg:self.view title:@"加载失败，请检查网络" delay:1.5];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return commentTableView.dataArr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    [imgView setImage:[UIImage imageNamed:@"comh.png"]];
    [imgView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 100, 15)];
    [label setBackgroundColor:[UIColor clearColor]];
    [imgView addSubview:label];
    [label setText:[NSString stringWithFormat:@"评论:%d",commentTableView.dataArr.count]];
    return imgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CommentItem *item = [commentTableView.dataArr objectAtIndex:indexPath.row];
    [cell setItem:item];
    [cell setRepBlock:^(NSString *rid){
        [self repWithTid:rid];
    }];
    [cell setDelBock:^(NSString *cid){
        [self delWithCid:cid];
    }];
    return cell;
}

- (void)delWithCid:(NSString *)cid
{
    
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:token forKey:@"access_token"];
    [postDic setObject:cid forKey:@"cid"];
    [req setPostDataDic:postDic];
    [req setFinishBlock:^(NSData *data){
        [self delComFinish:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/community/index.php/index/deletecomment"]];
}

- (void)delComFinish:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *msg = [dic objectForKey:@"message"];
    [MBProgressHUD showMsg:self.view title:msg delay:1];
    [self reAct];
}

- (void)repWithTid:(NSString *)rid
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
        return;
    }
    CommentViewController *commentVC = [[CommentViewController alloc] init];
    [commentVC setTid:_item.tid];
    [commentVC setRid:rid];
    [self presentViewController:commentVC animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentItem *item = [commentTableView.dataArr objectAtIndex:indexPath.row];
    return [CommentViewCell getHeighWithItem:item];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"帖子详情"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"帖子详情"];
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
