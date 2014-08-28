//
//  LocationViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-13.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()

@end

@implementation LocationViewController

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
    contentSCView = [[MRZoomScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:contentSCView];
    [contentSCView setBackgroundColor:[UIColor blackColor]];
    [contentSCView.imageView setImage:[UIImage imageNamed:@"lib.jpg"]];
    [contentSCView.imageView setContentMode:UIViewContentModeScaleAspectFit];
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 7, 32, 30)];
    [backBtn setImage:[UIImage imageNamed:@"proback.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popAct) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
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
    [MobClick beginLogPageView:@"馆藏分布"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"馆藏分布"];
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
