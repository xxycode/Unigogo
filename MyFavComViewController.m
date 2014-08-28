//
//  MyFavComViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-10.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MyFavComViewController.h"
#import "TopicCell.h"
#import "CommentViewController.h"
#import "TopicDetailViewController.h"

@interface MyFavComViewController ()

@end

@implementation MyFavComViewController

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
    [self setTitle:@"我的收藏"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    
    backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundView];
    [backgroundView setUserInteractionEnabled:YES];
    [backgroundView setImage:[UIImage imageNamed:@"loginbg.png"]];
    [self.view bringSubviewToFront:self.navView];
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.3]];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favt"];
    if (arr.count == 0) {
        [MBProgressHUD showMsg:backgroundView title:@"你还没有收藏任何消息哦" delay:2];
        return;
    }
    isLoadingMore = NO;
    CGFloat navH = kVersion >= 7.0? 64:44;
    topicItemTableView = [[XxyTableView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight - 64) ];
    [topicItemTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:topicItemTableView];
    
    [self.view bringSubviewToFront:self.navView];
    if (kVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [topicItemTableView setDelegate:self];
    [topicItemTableView setDataSource:self];
    
    [topicItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [topicItemTableView setBackgroundColor:[UIColor clearColor]];
    [self loadTableData];
}



- (void)loadTableData
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favt"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in arr) {
        TopicItem *item = [[TopicItem alloc] init];
        [item setDic:itemDic];
        [tmpArr addObject:item];
    }
    [topicItemTableView setDataArr:tmpArr];
    [topicItemTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return topicItemTableView.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identfy = @"cell";
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:identfy];
    if (cell == nil) {
        cell = [[TopicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy personal:NO deleteAble:YES];
    }
    TopicItem *item = [topicItemTableView.dataArr objectAtIndex:indexPath.row];
    [cell setIndexPath:indexPath];
    [cell setDelActionBlock:^(NSIndexPath *indexPath){
        [self delAct:indexPath];
    }];
    [cell setItem:item];
    return cell;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (_popBlock) {
        _popBlock();
    }
    [super viewDidDisappear:animated];
}

- (void)delAct:(NSIndexPath *)indexPath
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favt"];
    NSArray *idArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favtid"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:arr];
    [tmpArr removeObjectAtIndex:indexPath.row];
    NSMutableArray *tmpIdArr = [[NSMutableArray alloc] initWithArray:idArr];
    [tmpIdArr removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:tmpArr forKey:@"favt"];
    [[NSUserDefaults standardUserDefaults] setObject:tmpIdArr forKey:@"favtid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableArray *newArr = [[NSMutableArray alloc] init];
    NSArray *delArr = [NSArray arrayWithObject:indexPath];
    for (NSDictionary *itemDic in tmpArr) {
        TopicItem *item = [[TopicItem alloc] init];
        [item setDic:itemDic];
        [newArr addObject:item];
    }
    [topicItemTableView beginUpdates];
    [topicItemTableView setDataArr:newArr];
    [topicItemTableView deleteRowsAtIndexPaths:delArr withRowAnimation:UITableViewRowAnimationLeft];
    [topicItemTableView endUpdates];
    [self performSelector:@selector(reloadLostTable) withObject:nil afterDelay:0.35f];
}

- (void)reloadLostTable
{
    [topicItemTableView reloadData];
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
    TopicItem *item = [topicItemTableView.dataArr objectAtIndex:indexPath.row];
    CGFloat h = [TopicCell cellHeightForItem:item isPer:NO];
    return h;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"社区收藏"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"社区收藏"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end