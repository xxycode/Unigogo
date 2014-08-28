//
//  BorrowedViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-13.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BorrowedViewController.h"
#import "BookItemBor.h"
#import "BookBorrowViewCell.h"


@interface BorrowedViewController ()

@end

@implementation BorrowedViewController

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
    [self setTitle:@"已借图书"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    bookList = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 66)];
    [self.view addSubview:bookList];
    [bookList setDelegate:self];
    [bookList setDataSource:self];
    UIButton *navMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 43, 5+(navBarH - 44), 43, 34)];
    [navMoreButton setBackgroundImage:[UIImage imageNamed:@"nav_more_nor.png"] forState:UIControlStateNormal];
    [navMoreButton setBackgroundImage:[UIImage imageNamed:@"nav_more_f.png"] forState:UIControlStateHighlighted];
    [navMoreButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:navMoreButton];
    NSString *borrId = [[NSUserDefaults standardUserDefaults] objectForKey:@"borrowID"];
    _borrowerId = borrId;
    if (borrId == nil) {
        [self showInputStdInfo];
        return;
    }
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"bpassword"];
    _password = pwd;
    [self loadData];
}

- (void)loadData
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在加载";
    }
    [HUD show:YES];
    NSString *url = [NSString stringWithFormat:@"%@/library/index.php/index/getborrowedbook",kHost];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:_borrowerId forKey:@"username"];
    if (_password == nil) {
        [postDic setObject:@"" forKey:@"password"];
    }else {
        [postDic setObject:_password forKey:@"password"];
    }
    [req setPostDataDic:postDic];
    [req setFinishBlock:^(NSData *data){
        [self finishLoadData:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishLoadData:(NSData *)data
{
    [HUD hide:YES];
    //NSString *strr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *arr = [dic objectForKey:@"data"];
    if ([arr isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)arr;
        if ([str isEqualToString:@"null"]) {
            [MBProgressHUD showMsg:self.view title:@"你还没有借书" delay:1.5];
        }else{
            [MBProgressHUD showMsg:self.view title:(NSString *)arr delay:1.5];
            [self performSelector:@selector(showInputStdInfo) withObject:nil afterDelay:1.6];
        }
    }else{
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (NSDictionary *itemDic in arr) {
            BookItemBor *item = [[BookItemBor alloc] init];
            [item setDic:itemDic];
            [tmpArr addObject:item];
        }
        listArr = tmpArr;
        [bookList reloadData];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[NSUserDefaults standardUserDefaults] setObject:_borrowerId forKey:@"borrowID"];
        if (_password != nil) {
            [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"password"];
        }
    }
}

- (void)failedLoadData
{
    [HUD setHidden:YES];
    [MBProgressHUD showMsg:self.view title:@"加载失败，请检查网络" delay:1.5];
}

- (void)showMenu:(UIButton *)sender
{
    NSMutableArray *menuItems = [NSMutableArray arrayWithArray:
                                 @[
                                   
                                   [KxMenuItem menuItem:@"更换学号"
                                                  image:[UIImage imageNamed:@"newInfo.png"]
                                                 target:self
                                                 action:@selector(showInputStdInfo)],
                                   
                                   [KxMenuItem menuItem:@"更新数据"
                                                  image:[UIImage imageNamed:@"refresh.png"]
                                                 target:self
                                                 action:@selector(refresh)]
                                   ]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:sender.frame
                 menuItems:menuItems];
}

- (void)refresh
{
    _borrowerId = [[NSUserDefaults standardUserDefaults] objectForKey:@"borrowID"];
    _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (_borrowerId == nil) {
        [self showInputStdInfo];
        return;
    }
    [self loadData];
}


- (void)showInputStdInfo
{
    alert = [[DXAlertView alloc] initWithTitle:@"请输入借阅号和密码" contentText:@"借阅号密码默认为空" leftButtonTitle:@"确认" rightButtonTitle:@"取消"];
    [alert show];
    __block DXAlertView *tmpAlert = alert;
    __block BorrowedViewController *scV = self;
    alert.leftBlock = ^() {
        NSString *tmpid = [tmpAlert.studentIdField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (tmpid.length == 0) {
            [MBProgressHUD showMsg:tmpAlert title:@"借阅号不能为空" delay:2];
            return ;
        }
        [tmpAlert dismissAlert];
        scV.borrowerId = tmpAlert.studentIdField.text;
        scV.password = tmpAlert.passwordField.text;
        [scV loadData];
    };
    alert.rightBlock = ^() {
        
    };
}

#pragma mark 本地通知
- (void)registerLoaclNotification:(NSString *)name time:(NSTimeInterval)time
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        NSDate *now = [NSDate date];
        NSString *str = [NSString stringWithFormat:@"你应该去图书馆还《%@》了",name];
        // 设置提醒时间，倒计时以秒为单位。以下是从现在开始55秒以后通知
        notification.fireDate = [now dateByAddingTimeInterval:time];
        // 设置时区，使用本地时区
        notification.timeZone = [NSTimeZone defaultTimeZone];
        // 设置提示的文字
        notification.alertBody = str;
        //设置提示音
        // 设置提示音，使用默认的
        notification.soundName = UILocalNotificationDefaultSoundName;
        // 锁屏后提示文字，一般来说，都会设置与alertBody一样
        notification.alertAction = NSLocalizedString(str, nil);
        // 这个通知到时间时，你的应用程序右上角显示的数字. 获取当前的数字+1
        notification.applicationIconBadgeNumber = [[[UIApplication sharedApplication] scheduledLocalNotifications] count]+1;
        //给这个通知增加key 便于半路取消
        NSString *borrId = [[NSUserDefaults standardUserDefaults] objectForKey:@"borrowID"];
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:borrId,@"nfkey",nil];
        [notification setUserInfo:dict];
        // 启用这个通知
        [[UIApplication sharedApplication]  scheduleLocalNotification:notification];
    }
}

#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookBorrowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[BookBorrowViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    BookItemBor *item = [listArr objectAtIndex:indexPath.row];
    [cell setNoticationBlock:^(NSString *backTime,NSString *bookName){
        [self setNotification:backTime bookName:bookName];
    }];
    [cell setItem:item];
    return cell;
}

#pragma mark 还书提醒
- (void)setNotification:(NSString *)backTime bookName:(NSString *)name
{
    NSTimeZone* GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    [dateFormatter setTimeZone:GTMzone];
    NSDate *bdate = [dateFormatter dateFromString:backTime];
    NSDate *backDate = [NSDate dateWithTimeInterval:-16*3600 sinceDate:bdate];
    NSTimeInterval backStmp = [backDate timeIntervalSince1970];
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval tdelt = backStmp - curTime;
    [self registerLoaclNotification:name time:tdelt];
    NSDateFormatter * dF = [[NSDateFormatter alloc] init];
    [dF setDateFormat:@"yyyy年MM月dd日"];
    NSString * s = [dF stringFromDate:backDate];
    [MBProgressHUD showMsg:self.view title:@"设置成功" detail:[NSString stringWithFormat:@"你将在%@8点收到提醒",s] delay:3.5];
}

#pragma mark UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65.f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"已借图书"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"已借图书"];
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
