//
//  UpdatePasswordViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-11.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "UpdatePasswordViewController.h"

@interface UpdatePasswordViewController ()

@end

@implementation UpdatePasswordViewController

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
    [self setTitle:@"修改密码"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    oldpassword = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, navBarH + 30, kScreenWidth - 40, 40 )];
    [oldpassword setPlaceholder:@"原密码"];
    [oldpassword setTag:246];
    [oldpassword setReturnKeyType:UIReturnKeyNext];
    [oldpassword setDelegate:self];
    [oldpassword setBackgroundColor:[UIColor whiteColor]];
    [oldpassword setSecureTextEntry:YES];
    
    newpassword = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, navBarH + 90, kScreenWidth - 40, 40 )];
    [newpassword setPlaceholder:@"新密码"];
    [newpassword setTag:246];
    [newpassword setReturnKeyType:UIReturnKeyNext];
    [newpassword setDelegate:self];
    [newpassword setBackgroundColor:[UIColor whiteColor]];
    [newpassword setSecureTextEntry:YES];
    
    newpassworded = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, navBarH + 150, kScreenWidth - 40, 40 )];
    [newpassworded setPlaceholder:@"确认新密码"];
    [newpassworded setTag:246];
    [newpassworded setReturnKeyType:UIReturnKeyDone];
    [newpassworded setDelegate:self];
    [newpassworded setBackgroundColor:[UIColor whiteColor]];
    [newpassworded setSecureTextEntry:YES];
    
    UIButton *comButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 7 + navBarH - 44, 80, 30)];
    [comButton setBackgroundColor:UIColorFromRGB(0x80b305)];
    [comButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [comButton.layer setCornerRadius:15.f];
    [comButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [comButton addTarget:self action:@selector(updatePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:comButton];
    
    [self.view addSubview:oldpassword];
    [self.view addSubview:newpassword];
    [self.view addSubview:newpassworded];
}

- (void)updatePassword
{
    NSString *oldPasswordStr = [oldpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newPasswordStr = [newpassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newPasswordedStr = [newpassworded.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (oldPasswordStr.length == 0 || newPasswordStr.length == 0 || newPasswordedStr.length == 0) {
        [MBProgressHUD showMsg:self.view title:@"必填内容不能为空" delay:1];
        return;
    }
    if (![newPasswordStr isEqualToString:newPasswordedStr]) {
        [MBProgressHUD showMsg:self.view title:@"两次密码输入不一致" delay:1];
        return;
    }
    
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在加载";
    }
    for (UITextField *view in self.view.subviews) {
        [view resignFirstResponder];
    }
    [HUD show:YES];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:token forKey:@"token"];
    [postDic setObject:oldPasswordStr forKey:@"opassword"];
    [postDic setObject:[SecretFactory md5:newPasswordStr] forKey:@"npassword"];
    NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/updatepassword",kHost];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setPostDataDic:postDic];
    UpdatePasswordViewController *sV = self;
    [req setFailedBlock:^(NSError *err){
        [HUD hide:YES];
        [MBProgressHUD showMsg:self.view title:@"修改失败，请检查网络" delay:1.25];
    }];
    [req setFinishBlock:^(NSData *data){
        [sV finishedUpdate:data];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishedUpdate:(NSData *)data
{
    [HUD hide:YES];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [dic objectForKey:@"status"];
    if ([status isEqualToString:@"1"]) {
        [self performSelector:@selector(dismissSelf) withObject:nil afterDelay:1.6];
    }
    NSString *message = [dic objectForKey:@"message"];
    [MBProgressHUD showMsg:self.view title:message delay:1.5];
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == oldpassword) {
        [newpassword becomeFirstResponder];
    }else if(textField == newpassword){
        [newpassworded becomeFirstResponder];
    }else{
        [self updatePassword];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"社区修改密码"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"社区修改密码"];
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
