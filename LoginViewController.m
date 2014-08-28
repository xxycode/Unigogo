//
//  LoginViewController.m
//  Unigogo
//
//  Created by xxy on 14-6-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LoginViewController.h"
#import "UIButton+setFrame.h"
#import "LRTextFeild.h"
#import "SecretFactory.h"
#import "XxyHttprequest.h"
#import "APService.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

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
    [self setTitle:@"登陆"];
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
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    UITapGestureRecognizer *tGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    [self.view addGestureRecognizer:tGR];
    CGFloat kNavH = kVersion >= 7.0 ? 64.0:44.0;
    LRTextFeild *userName = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, 40 + kNavH, kScreenWidth - 40, 40)];
    [userName setDelegate:self];
    [userName setPlaceholder:@"用户名"];
    [userName setTag:101];
    [userName setReturnKeyType:UIReturnKeyNext];
    [userName becomeFirstResponder];
    [self.view addSubview:userName];
    LRTextFeild *passWord = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, 90 + kNavH, kScreenWidth - 40, 40)];
    [passWord setPlaceholder:@"密码"];
    [passWord setDelegate:self];
    [passWord setTag:102];
    [passWord setReturnKeyType:UIReturnKeyDone];
    [passWord setSecureTextEntry:YES];
    [self.view addSubview:passWord];
    UIImageView *userImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 20, 20)];
    [userImg setImage:[UIImage imageNamed:@"userl.png"]];
    [userName addSubview:userImg];
    UIImageView *pwdImg = [[UIImageView alloc] initWithFrame:CGRectMake(6, 10, 20, 20)];
    [pwdImg setImage:[UIImage imageNamed:@"lockl.png"]];
    [passWord addSubview:pwdImg];
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20, kNavH+50+40+40+20, 130, 40)];
    [loginButton setBackgroundColor:UIColorFromRGB(0x99cc00)];
    [loginButton.layer setCornerRadius:20.0f];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginAct) forControlEvents:UIControlEventTouchUpInside];
    //[loginButton setShadow];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginButton];
    UIButton *registerButton = [[UIButton alloc] initWithFrame:CGRectMake(20+130+20, kNavH+50+40+40+20, 130, 40)];
    [registerButton setBackgroundColor:UIColorFromRGB(0x01a2ff)];
    [registerButton.layer setCornerRadius:20.0f];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(regAct) forControlEvents:UIControlEventTouchUpInside];
    //[registerButton setShadow];
    [self.view addSubview:registerButton];
}

- (void)hidenKeyboard
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:UITextField.class]) {
            [view resignFirstResponder];
        }
    }
}

- (void)regAct
{
    RegisterViewController *registerViewController = [[RegisterViewController alloc] init];
    [registerViewController setDB:^{
        [self regViewControllerDidDismiss];
    }];
    [self presentViewController:registerViewController animated:YES completion:nil];
}

- (void)loginAct
{

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    HUD.labelText = @"正在登录";
    LRTextFeild *uf = (LRTextFeild *)[self.view viewWithTag:101];
    LRTextFeild *pf = (LRTextFeild *)[self.view viewWithTag:102];
    NSString *username = [uf text];
    NSString *password = [SecretFactory md5:pf.text];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:username forKey:@"username"];
    [postDic setObject:password forKey:@"password"];
    
    [req setPostDataDic:postDic];
    [req setFinishBlock:^(NSData *data){
        [HUD hide:YES];
        [self finishLoginAct:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedReq];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/community/index.php/index/checklogin"]];
}

- (void)finishLoginAct:(NSData *)data
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([str isEqualToString:@"0"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败，无效的用户名和密码组合" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"token"] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"uid"] forKey:@"uid"];
        LRTextFeild *uf = (LRTextFeild *)[self.view viewWithTag:101];
        NSString *username = [uf text];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"nowUser"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [APService setAlias:username callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
        [self dismissViewControllerAnimated:YES completion:^{
            if(self.disBlock !=nil ){
                self.disBlock();
            }
        }];
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.secureTextEntry == NO) {
        LRTextFeild *pwd = (LRTextFeild *)[self.view viewWithTag:102];
        [pwd becomeFirstResponder];
        return YES;
    }
    [self loginAct];
    return true;
}

- (void)failedReq
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败，请检查您的网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)regViewControllerDidDismiss
{
    //NSString *access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"登陆"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"登陆"];
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
