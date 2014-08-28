//
//  OpenTimeViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-13.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "OpenTimeViewController.h"

@interface OpenTimeViewController ()

@end

@implementation OpenTimeViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7 + (navBarH - 44), 32, 30)];
    [backBtn setImage:[UIImage imageNamed:@"proback.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popAct) forControlEvents:UIControlEventTouchUpInside];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"loac" ofType:@"html"];
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    conView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - (64 - navBarH))];
    [conView setContentMode:UIViewContentModeCenter];
    [conView loadHTMLString:str baseURL:nil];
    [conView setScalesPageToFit:NO];
    [self.view addSubview:conView];
    [self.view addSubview:backBtn];
    // Do any additional setup after loading the view.
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
    [MobClick beginLogPageView:@"开放时间"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"开放时间"];
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
