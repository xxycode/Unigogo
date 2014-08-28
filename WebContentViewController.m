//
//  WebContentViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "WebContentViewController.h"

@interface WebContentViewController ()

@end

@implementation WebContentViewController

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
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)initView
{
    contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, (navBarH - 44), kScreenWidth, kScreenHeight - 20)];
    [self.view addSubview:contentView];
    [contentView setDelegate:self];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [contentView loadRequest:request];
    [contentView.scrollView setShowsVerticalScrollIndicator:NO];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, kScreenHeight - 20 - (64 - navBarH) - 34, 34, 34)];
    [self.view addSubview:backButton];
    [backButton setImage:[UIImage imageNamed:@"webViewBack.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popAct) forControlEvents:UIControlEventTouchUpInside];
}

- (void)popAct
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:HUD];
        [HUD setLabelText:@"正在加载"];
    }
    [HUD show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD hide:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"webView页面"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"webView页面"];
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
