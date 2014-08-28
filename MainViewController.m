//
//  MainViewController.m
//  Unigogo
//
//  Created by Apple on 14-6-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MainViewController.h"
#import "MainButton.h"
#import "LessonViewController.h"
#import "LibraryViewController.h"
#import "ScoreViewController.h"
#import "GoPhotoViewController.h"
#import "NewstdViewController.h"
#import "UsedViewController.h"
#import "LostandfoundViewController.h"
#import "MoreViewController.h"
#import "SDImageCache.h"
#import "LoginViewController.h"
#import "UIView+MWParallax.h"
#import "XxyHttprequest.h"

@interface MainViewController ()

@end

@implementation MainViewController

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
    [self checkUpdate];
    //LoginViewController *loginViewController = [[LoginViewController alloc] init];
    
    //[self presentViewController:loginViewController animated:YES completion:nil];
    // Do any additional setup after loading the view.
}

- (void)checkUpdate
{
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/update/index.php/index?ver=1.0",kHost];
    [req setFinishBlock:^(NSData *data){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSString *status = [dic objectForKey:@"status"];
        if (![status isEqualToString:@"0"]) {
            NSString *dec = [dic objectForKey:@"dec"];
            uurl = [dic objectForKey:@"url"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"检测到新版本" message:dec delegate:self cancelButtonTitle:@"忽略此版本" otherButtonTitles:@"前往更新", nil];
            [alert show];
        }
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:uurl]];
    }
}

- (void)initViews
{
    backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(-20, -20, kScreenWidth + 40, kScreenHeight + 40)];
    [backgroundView setImage:[UIImage imageNamed:@"main.png"]];
    [backgroundView setUserInteractionEnabled:YES];
    [self.view addSubview:backgroundView];
    countOfCurrentButton = 0;
    mainView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:mainView];
    [mainView setContentSize:CGSizeMake(kScreenWidth * 2, kScreenHeight)];
    [mainView setDelegate:self];
    [mainView setPagingEnabled:YES];
    [mainView setShowsHorizontalScrollIndicator:NO];
    pageControl = [[UIPageControl alloc] init];
    CGFloat pageDelt = 40.0f;
    if (kVersion >= 7.0) {
        pageDelt = 20.0f;
    }
    [pageControl setCenter:CGPointMake(kScreenWidth/2, kScreenHeight - pageDelt)];
    [pageControl setNumberOfPages:2];
    [self.view addSubview:pageControl];
    btnArr = [[NSMutableArray alloc] init];
    [self getMainLayoutData];
    if (kVersion >= 7.0) {
        if (kScreenHeight > 480) {
            marginTop = 55;
        }else{
            marginTop = 35;
        }
    }else{
        if (kScreenHeight > 480) {
            marginTop = 35;
        }else{
            marginTop = 15;
        }
    }
    if (kScreenHeight > 480) {
        iconHeight = 175;
    }else{
        iconHeight = 150;
    }
    myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(addView) userInfo:nil repeats:YES];
}

- (void)getMainLayoutData
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"MainLayout.plist"];
    NSMutableDictionary *dic= [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
    if (dic == nil) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MainLayout" ofType:@"plist"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        mainIconArr = [dic objectForKey:@"icon"];
        mainTitleArr = [dic objectForKey:@"title"];
        NSDictionary *tmpDic = [NSDictionary dictionaryWithObjects:@[mainIconArr,mainTitleArr] forKeys:@[@"icon",@"title"]];
        [tmpDic writeToFile:path atomically:YES];
    }else{
        mainIconArr = [dic objectForKey:@"icon"];
        mainTitleArr = [dic objectForKey:@"title"];
    }

}

- (void)addView
{
    if (countOfCurrentButton > 5) {
        [myTimer invalidate];
    }
    countOfCurrentButton ++;
    [self addNewView:countOfCurrentButton];
}

- (void)addNewView:(NSInteger) n
{
    
    CGFloat x = n%2==0? 175:30;
    if (n > 6) {
        x += kScreenWidth;
    }
    CGFloat y = ((n-1)/2)*iconHeight + marginTop;//35( 7 3.5) 55(7 4.0)  175(6 4.0)
    if (n > 6) {
        y = ((n-7)/2)*iconHeight + marginTop;
    }
    MainButton *button = [[MainButton alloc] initWithFrame:CGRectMake(x, y, 115, 115)];
    [button setBackgroundImage:[UIImage imageNamed:[mainIconArr objectAtIndex:n-1]] forState:UIControlStateNormal];
    [button setTag:100+n];
    [button setX_id:n];
    [button addTarget:self action:@selector(buttonAct:) forControlEvents:UIControlEventTouchUpInside];
    [button.layer setCornerRadius:57.5f];
    
    [button setBottomTitle:[mainTitleArr objectAtIndex:n-1]];
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
    [button addGestureRecognizer:longGesture];
    [mainView addSubview:button];
    [btnArr addObject:button];
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 0.35;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    //[values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    
    //animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [button.layer addAnimation:animation forKey:nil];
    
}

- (void)buttonAct:(MainButton *)button
{
    NSString *btnTit = button.btnTitle;
    NSDictionary *actDic = [[NSDictionary alloc] initWithObjects:@[@1,@2,@3,@4,@5,@6,@7,@8,@9] forKeys:@[@"课表查询",@"移动图书馆",@"成绩查询",@"GO社区",@"GO爆照",@"新生频道",@"二手市场",@"失物招领",@"更多精彩"]];
    NSNumber *cId = [actDic objectForKey:btnTit];
    switch ([cId integerValue]) {
        case 1:
            {
                LessonViewController *lessonVC = [[LessonViewController alloc] init];
                [self.navigationController pushViewController:lessonVC animated:YES];
            }
            break;
        case 2:
            {
                LibraryViewController *libraryVC = [[LibraryViewController alloc] init];
                [self.navigationController pushViewController:libraryVC animated:YES];
            }
            break;
        case 3:
            {
                ScoreViewController *scoreVC = [[ScoreViewController alloc] init];
                [self.navigationController pushViewController:scoreVC animated:YES];
            }
            break;
        case 4:
            {
                if (communityVC == nil) {
                    communityVC = [[CommunityViewController alloc] init];
                }
                [self.navigationController pushViewController:communityVC animated:YES];
            }
            break;
        case 5:
            {
                GoPhotoViewController *goPhotoVC = [[GoPhotoViewController alloc] init];
                [self.navigationController pushViewController:goPhotoVC animated:YES];
            }
            break;
        case 6:
            {
                NewstdViewController *newstdVC = [[NewstdViewController alloc] init];
                [self.navigationController pushViewController:newstdVC animated:YES];
            }
            break;
        case 7:
            {
                UsedViewController *usedVC = [[UsedViewController alloc] init];
                [self.navigationController pushViewController:usedVC animated:YES];
            }
            break;
        case 8:
            {
//                [[SDImageCache sharedImageCache] clearDisk];
//                [[SDImageCache sharedImageCache] clearMemory];
//                float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
//                NSString *clearCacheName = tmpSize >= 1?[NSString stringWithFormat:@"清理缓存(%.2fM)",tmpSize]:[NSString stringWithFormat:@"清理缓存(%.2fK)",tmpSize * 1024];
//                NSLog(@"%@",clearCacheName);
                LostandfoundViewController *lostandfoundVC = [[LostandfoundViewController alloc] init];
                [self.navigationController pushViewController:lostandfoundVC animated:YES];
            }
            break;
        case 9:
            {
                MoreViewController *moreVC = [[MoreViewController alloc] init];
                [self.navigationController pushViewController:moreVC animated:YES];
            }
            break;
        default:
            break;
    }
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    
    MainButton *btn = (MainButton *)sender.view;
    [mainView bringSubviewToFront:btn];
    currBtn = btn.x_id - 1;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        [UIView animateWithDuration:0.2 animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
        [btn startShake];
//        for (MainButton *button in btnArr) {
//            [button startShake]
//        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (btn.x_id <=6 && btn.center.x >= kScreenWidth - 40 && btn.center.x <= kScreenWidth + 40){
            [self timerAct1];
        }
        if (btn.x_id > 6 && btn.center.x <= kScreenWidth + 40 && pageControl.currentPage == 1) {
            [self timerAct2];
        }
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        //NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            contain = NO;
        }
        else
        {
            [UIView animateWithDuration:0.2 animations:^{
                //[mainView addSubview:btn];
                CGPoint temp = CGPointZero;
                MainButton *button = btnArr[index];
                [mainIconArr exchangeObjectAtIndex:index withObjectAtIndex:btn.x_id-1];
                [mainTitleArr exchangeObjectAtIndex:index withObjectAtIndex:btn.x_id-1];
                [btnArr exchangeObjectAtIndex:index withObjectAtIndex:btn.x_id-1];
                NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingPathComponent:@"MainLayout.plist"];
                NSMutableDictionary *dic= [[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy];
                [dic setObject:mainTitleArr forKey:@"title"];
                [dic setObject:mainIconArr forKey:@"icon"];
                [dic writeToFile:path atomically:YES];
                NSInteger tmp = index + 1;
                button.x_id = btn.x_id;
                btn.x_id = tmp;
                temp = button.center;
                button.center = originPoint;
                btn.center = temp;
                originPoint = btn.center;
                contain = YES;
                //[mainView addSubview:btn];
            }];
        }
        
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        if (!contain) {
            originPoint.x += kScreenWidth;
        }
        [UIView animateWithDuration:0.2 animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                originPoint.x -= kScreenWidth;
                btn.center = originPoint;
            }
            [btn stopShake];
//            [mainView addSubview:btn];
        }];
    }
}

- (void)timerAct1
{
    [UIView animateWithDuration:0.35 animations:^{
        CGPoint offset = mainView.contentOffset;
        offset.x = kScreenWidth;
        mainView.contentOffset = offset;
        MainButton *btn = [btnArr objectAtIndex:currBtn];
        CGPoint center = btn.center;
        center.x += kScreenWidth;
        btn.center = center;
    }];
}

- (void)timerAct2
{
    [UIView animateWithDuration:0.35 animations:^{
        CGPoint offset = mainView.contentOffset;
        offset.x = 0;
        mainView.contentOffset = offset;
        MainButton *btn = [btnArr objectAtIndex:currBtn];
        CGPoint center = btn.center;
        center.x -= kScreenWidth;
        btn.center = center;
    }];
}

- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<btnArr.count;i++)
    {
        UIButton *button = btnArr[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

#pragma mark scrollerView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGPoint offset = scrollView.contentOffset;
//    if (offset.x >= kScreenWidth - 40 && currBtn < 6) {
//        MainButton *btn = [btnArr objectAtIndex:currBtn];
//        [mainView addSubview:btn];
//    }
    if (offset.x >= kScreenWidth/2) {
        [pageControl setCurrentPage:1];
    }else if(offset.x <= kScreenWidth/2){
        [pageControl setCurrentPage:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
