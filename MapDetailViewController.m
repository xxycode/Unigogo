//
//  MapDetailViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MapDetailViewController.h"

@interface MapDetailViewController ()

@end

@implementation MapDetailViewController

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

- (void)setLName:(NSString *)lName
{
    _lName = lName;
}

- (void)initView
{
    contentView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64 - 40)];
    [self.view addSubview:contentView];
    [contentView setDelegate:self];
    NSString *url = [NSString stringWithFormat:@"%@/nmap/index.php/index/detail?lid=%@",kHost,_lid];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [contentView loadRequest:request];
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40 - (64 - navBarH), kScreenWidth, 40)];
    [toolBar setBackgroundColor:UIColorFromRGB(0x2e2e2e)];
    [self.view addSubview:toolBar];
    NSArray *icon = @[@"webViewBk.png",@"webViewFw.png",@"webViewRe.png"];
    CGFloat cX = 20.f;
    for (int i = 0; i < 3; i ++) {
        UIButton *btn = [[UIButton  alloc] initWithFrame:CGRectMake(cX, 40/2 - 23.0/2, 23, 23)];
        [btn setImage:[UIImage imageNamed:[icon objectAtIndex:i]] forState:UIControlStateNormal];
        [toolBar addSubview:btn];
        [btn addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i + 1007];
        cX += 48;
    }
    //[contentView.scrollView setShowsVerticalScrollIndicator:NO];
}

- (void)btnAct:(UIButton *)btn
{
    NSInteger n = btn.tag - 1007;
    switch (n) {
        case 0:
            [contentView goBack];
            break;
        case 1:
            [contentView goForward];
            break;
        case 2:
            [contentView reload];
            break;
        default:
            break;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (HUD == nil) {
        HUD = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.navView addSubview:HUD];
        [HUD setCenter:CGPointMake(94, titLabel.center.y)];
    }
    [HUD setHidden:NO];
    [HUD startAnimating];
    [self setTitle:@"正在加载..."];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HUD setHidden:YES];
    [self setTitle:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@地点详情",_lName]];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick beginLogPageView:[NSString stringWithFormat:@"%@地点详情",_lName]];
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
