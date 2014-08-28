//
//  MoreViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-16.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MoreViewController.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "FeedBackViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "APService.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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
    [self setTitle:@"设置"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    UIScrollView *conView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:conView];
    [conView setContentInset:UIEdgeInsetsMake(-navBarH, 0, 0, 0)];
    [conView setContentSize:CGSizeMake(kScreenWidth, kScreenHeight + 0.5f - (64 - navBarH))];
    [conView setPagingEnabled:YES];
    [conView setBackgroundColor:[UIColor clearColor]];
    float tmpSize = [[SDImageCache sharedImageCache] checkTmpSize];
    NSString *clearCacheName = tmpSize >= 1?[NSString stringWithFormat:@"缓存(%.2fM)",tmpSize]:[NSString stringWithFormat:@"缓存(%.2fK)",tmpSize * 1024];
    UIButton *cacheButton = [[UIButton alloc] init];
    [cacheButton setBackgroundColor:[UIColor whiteColor]];
    [cacheButton setFrame:CGRectMake(10, navBarH + 10, kScreenWidth - 20, 40)];
    [cacheButton setTitle:[NSString stringWithFormat:@"清理%@",clearCacheName] forState:UIControlStateNormal];
    [cacheButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cacheButton addTarget:self action:@selector(cleanCache:) forControlEvents:UIControlEventTouchUpInside];
    [conView addSubview:cacheButton];
    UIButton *aboutButton = [[UIButton alloc] init];
    [aboutButton setBackgroundColor:[UIColor whiteColor]];
    [aboutButton setFrame:CGRectMake(10, navBarH + 10 + 50, kScreenWidth - 20, 40)];
    [aboutButton setTitle:@"关于Go校园" forState:UIControlStateNormal];
    [aboutButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [aboutButton addTarget:self action:@selector(aboutUs) forControlEvents:UIControlEventTouchUpInside];
    [conView addSubview:aboutButton];
    UIButton *feedbackButton = [[UIButton alloc] init];
    [feedbackButton setBackgroundColor:[UIColor whiteColor]];
    [feedbackButton setFrame:CGRectMake(10, navBarH + 10 + 50 + 50, kScreenWidth - 20, 40)];
    [feedbackButton setTitle:@"投诉与建议" forState:UIControlStateNormal];
    [feedbackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [feedbackButton addTarget:self action:@selector(feedBack) forControlEvents:UIControlEventTouchUpInside];
    [conView addSubview:feedbackButton];
    
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setBackgroundColor:[UIColor whiteColor]];
    [shareButton setFrame:CGRectMake(10, navBarH + 10 + 50 + 50 + 50, kScreenWidth - 20, 40)];
    [shareButton setTitle:@"分享给其他小伙伴" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [conView addSubview:shareButton];
    
    UIButton *userButton = [[UIButton alloc] init];
    [userButton setFrame:CGRectMake(10, navBarH + 10 + 50 + 50 + 50 + 50, kScreenWidth - 20, 40)];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] != nil) {
        [userButton setTitle:@"注销" forState:UIControlStateNormal];
        [userButton setBackgroundColor:UIColorFromRGB(0xfc5332)];
        [userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [userButton addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [userButton setTitle:@"登录" forState:UIControlStateNormal];
        [userButton setBackgroundColor:UIColorFromRGB(0x6699cc)];
        [userButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [userButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    }
    [conView addSubview:userButton];
}

- (void)share
{

    id<ISSContent> publishContent = [ShareSDK content:@"我正在使用Go校园，湘大学子都在用，你也快来下载吧 http://218.244.137.199"
                                       defaultContent:@"欢迎下载Go校园"
                                                image:nil
                                                title:@"我分享了一条来自湘潭大学失物招领的帖子，快来看看吧"
                                                  url:@"http://218.244.137.199"
                                          description:@"这是一条来自Go校园的信息"
                                            mediaType:SSPublishContentMediaTypeText];
    
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)feedBack
{
    FeedBackViewController *fedVC = [[FeedBackViewController alloc] init];
    [self presentViewController:fedVC animated:YES completion:nil];
}

- (void)aboutUs
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"关于Go校园"
                          message:@"Go校园是由湘潭大学在校学生GoGo团队开发，致力于为湘大学子打造一个高效快捷的移动服务平台，作者邮箱：xxyc15@icloud.com 微博@我是叉叉歪"
                          delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
}

- (void)cleanCache:(UIButton *)button
{
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    [MBProgressHUD showMsg:self.view title:@"清理成功" delay:1.5];
    [button setTitle:@"清理缓存" forState:UIControlStateNormal];
    [button.titleLabel setTextColor:[UIColor blackColor]];
}

- (void)logOut:(UIButton *)button
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"nowUser"];
    [APService setAlias:@"nil" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button setBackgroundColor:UIColorFromRGB(0x6699cc)];
    [button removeTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)login:(UIButton *)button
{
    LoginViewController *logVC = [[LoginViewController alloc] init];
    [logVC setDisBlock:^{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] != nil) {
            [button setTitle:@"注销" forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0xfc5332)];
            [button.titleLabel setTextColor:[UIColor whiteColor]];
            [button addTarget:self action:@selector(logOut:) forControlEvents:UIControlEventTouchUpInside];
            [button removeTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [button setTitle:@"登录" forState:UIControlStateNormal];
            [button setBackgroundColor:UIColorFromRGB(0x6699cc)];
        }
    }];
    [self presentViewController:logVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"更多"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"更多"];
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
