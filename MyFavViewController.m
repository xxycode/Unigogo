//
//  MyFavViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-3.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MyFavViewController.h"
#import "Xxyhttprequest.h"
#import "LostItem.h"
#import "LostItemCell.h"
#import "KxMenu.h"
#import "LoginViewController.h"
#import "NewinfoViewController.h"
#import "MKNetworkEngine.h"
#import "MBProgressHUD.h"

@interface MyFavViewController ()

@end

@implementation MyFavViewController

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
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favl"];
    if (arr.count == 0) {
        [MBProgressHUD showMsg:backgroundView title:@"你还没有收藏任何消息哦" delay:2];
        return;
    }
    isLoadingMore = NO;
    CGFloat navH = kVersion >= 7.0? 64:44;
    lostItemTableView = [[XxyTableView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight - 64) ];
    [lostItemTableView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lostItemTableView];
    
    [self.view bringSubviewToFront:self.navView];
    if (kVersion >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [lostItemTableView setDelegate:self];
    [lostItemTableView setDataSource:self];
    
    [lostItemTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [lostItemTableView setBackgroundColor:[UIColor clearColor]];
    [self loadTableData];
}

- (void)dismissMorView
{
    [KxMenu dismissMenu];
}


- (void)loadTableData
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favl"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    for (NSDictionary *itemDic in arr) {
        LostItem *item = [[LostItem alloc] init];
        [item setDic:itemDic];
        [tmpArr addObject:item];
    }
    [lostItemTableView setDataArr:tmpArr];
    [lostItemTableView reloadData];
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
        cell = [[LostItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfy personal:NO deleteAble:YES];
    }
    LostItem *item = [lostItemTableView.dataArr objectAtIndex:indexPath.row];
    [cell setIndexPath:indexPath];
    [cell setDelActionBlock:^(NSIndexPath *indexPath){
        [self delAct:indexPath];
    }];
    [cell setItem:item];
    return cell;
}

- (void)delAct:(NSIndexPath *)indexPath
{
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favl"];
    NSArray *idArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favlid"];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:arr];
    [tmpArr removeObjectAtIndex:indexPath.row];
    NSMutableArray *tmpIdArr = [[NSMutableArray alloc] initWithArray:idArr];
    [tmpIdArr removeObjectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:tmpArr forKey:@"favl"];
    [[NSUserDefaults standardUserDefaults] setObject:tmpIdArr forKey:@"favlid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSMutableArray *newArr = [[NSMutableArray alloc] init];
    NSArray *delArr = [NSArray arrayWithObject:indexPath];
    for (NSDictionary *itemDic in tmpArr) {
        LostItem *item = [[LostItem alloc] init];
        [item setDic:itemDic];
        [newArr addObject:item];
    }
    [lostItemTableView beginUpdates];
    [lostItemTableView setDataArr:newArr];
    [lostItemTableView deleteRowsAtIndexPaths:delArr withRowAnimation:UITableViewRowAnimationLeft];
    [lostItemTableView endUpdates];
    [self performSelector:@selector(reloadLostTable) withObject:nil afterDelay:0.35f];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"失物收藏"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"失物收藏"];
}


@end
