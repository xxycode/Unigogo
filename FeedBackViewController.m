//
//  FeedBackViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-16.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "FeedBackViewController.h"

#import "XxyHttpRequest.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController

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
    [self setTitle:@"发表你的意见或投诉"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    contentView = [[UITextView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:contentView];
    [contentView becomeFirstResponder];
    [contentView setFont:[UIFont systemFontOfSize:16.f]];
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 5 + (navBarH - 44), 30, 30)];
    [sendButton addTarget:self action:@selector(sendAct:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"fedsend.png"] forState:UIControlStateNormal];
    [self.navView addSubview:sendButton];
}

- (void)sendAct:(UIButton *)sender
{
    [contentView resignFirstResponder];
    NSString *str = [contentView text];
    NSString *tmp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tmp.length == 0) {
        [MBProgressHUD showMsg:self.view title:@"内容不能为空" delay:1.f];
    }else if(tmp.length >140){
        [MBProgressHUD showMsg:self.view title:@"内容不能超过140个字" delay:1.f];
    }else {
        [self sendToService];
    }
}

- (void)sendToService
{
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/campus/index.php/index/feedback",kHost];
    NSDictionary *postDic = [NSDictionary dictionaryWithObject:contentView.text forKey:@"content"];
    [req setPostDataDic:postDic];
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD setLabelText:@"正在发送"];
    }
    [HUD show:YES];
    //__block FeedBackViewController *sV = self;
    [req setFinishBlock:^(NSData *data){
        [HUD hide:YES];
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        [MBProgressHUD showMsg:self.view title:@"反馈成功" delay:1.f];
        [self performSelector:@selector(dismissSv) withObject:nil afterDelay:1.1f];
    }];
    [req setFailedBlock:^(NSError *err){
        [HUD hide:YES];
        [MBProgressHUD showMsg:self.view title:@"反馈失败，请检查你的网络" delay:1.f];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)dismissSv
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"反馈"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"反馈"];
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
