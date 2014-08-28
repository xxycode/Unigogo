//
//  AppDelegate.m
//  Unigogo
//
//  Created by Apple on 14-6-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SecretFactory.h"
#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "APService.h"
#import "MobClick.h"
#import "TopicDetailViewController.h"
#import "TopicItem.h"
#import "WebContentViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    application.applicationIconBadgeNumber = 0; 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *mainViewController = [[MainViewController alloc] init];
    rootViewController = [[RootViewController alloc] initWithRootViewController:mainViewController];
    [self.window setRootViewController:rootViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //[NSThread sleepForTimeInterval:3.5];
    [MobClick startWithAppkey:@"53e18a9ffd98c5e7e7027aa1" reportPolicy:BATCH   channelId:@"App Store"];
    [MobClick setLogEnabled:YES];
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    // Required
    [APService setupWithOption:launchOptions];
    
    [ShareSDK registerApp:@"223c1fda0b65"];
    [ShareSDK connectSinaWeiboWithAppKey:@"2831600487"
                               appSecret:@"ecae4ca0ab4c4f29aa2d53b7ae6889f9"
                             redirectUri:@"http://218.244.137.199"];
    
    [ShareSDK connectQZoneWithAppKey:@"101133798"
                           appSecret:@"cf97e5d1e3d501b5f54c3036d79a20e2"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    [ShareSDK connectWeChatWithAppId:@"wxcf9594ac69398857"
                           wechatCls:[WXApi class]];
    
    
    [ShareSDK connectQQWithAppId:@"101133798" qqApiCls:[QQApi class]];
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"];
    if (userName == nil) {
        userName = [NSString stringWithFormat:@"nil"];
    }
    [APService setAlias:userName callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    return YES;
}


- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // 取得 APNs 标准信息内容
//    NSDictionary *aps = [userInfo valueForKey:@"aps"];
//    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
//    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
//    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    NSString *notificationType = [userInfo objectForKey:@"type"];
    
    if ([notificationType isEqualToString:@"1"] || [notificationType isEqualToString:@"2"]) {
        NSString *tid = [userInfo objectForKey:@"tid"];
        TopicDetailViewController *tpVC = [[TopicDetailViewController alloc] init];
        [tpVC setTid:tid];
        [rootViewController pushViewController:tpVC animated:YES];
    }else{
        NSString *url = [userInfo objectForKey:@"url"];
        WebContentViewController *webVC = [[WebContentViewController alloc] init];
        [webVC setUrl:url];
        [rootViewController pushViewController:webVC animated:YES];
    }
    
    // 取得自定义字段内容
//    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
//    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);
    
    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)showMsg:(NSString *)title delay:(NSTimeInterval)delay
{
    [MBProgressHUD showMsg:self.window title:title delay:delay];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required

    [APService registerDeviceToken:deviceToken];
    
}



@end
