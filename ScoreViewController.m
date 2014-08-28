//
//  ScoreViewController.m
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "ScoreViewController.h"
#import "XxyHttpRequest.h"
#import "GradeItem.h"
#import "GradeTableViewCell.h"

@interface ScoreViewController ()

@end

@implementation ScoreViewController

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
    [self setTitle:@"成绩查询"];
    //http://218.244.137.199:8080/webgogo/queryAllGradeAction?xh=2011550719&password=666666
    // Do any additional setup after loading the view.
    [self initViews];
}

- (void)initViews
{
    backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundView];
    [backgroundView setUserInteractionEnabled:YES];
    [backgroundView setImage:[UIImage imageNamed:@"grade.png"]];
    [self.view bringSubviewToFront:self.navView];
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    _studentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentId"];
    _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (_studentId == nil || _password == nil) {
        [self showInputStdInfo];
    }else{
        if ([_studentId isEqualToString:@""]||[_password isEqualToString:@""]) {
            [self showInputStdInfo];
            return;
        }
        [self loadSoccerData];
    }
}

#pragma mark Act
- (void)showInputStdInfo
{
    alert = [[DXAlertView alloc] initWithTitle:@"请输入学号和密码" contentText:@"你的学号和密码只会被保存在本地" leftButtonTitle:@"确认" rightButtonTitle:@"取消"];
    [alert show];
    __block DXAlertView *tmpAlert = alert;
    __block ScoreViewController *scV = self;
    __block DXAlertView *al = alert;
    alert.leftBlock = ^() {
        NSString *tmpid = [tmpAlert.studentIdField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *tmppwd = [tmpAlert.passwordField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (tmpid.length == 0 || tmppwd.length == 0) {
            [MBProgressHUD showMsg:al title:@"用户名或密码不能为空" delay:2];
            return ;
        }
        scV.studentId = tmpAlert.studentIdField.text;
        scV.password = tmpAlert.passwordField.text;
        [scV inputViewOKAction];
    };
    alert.rightBlock = ^() {
        NSLog(@"right button clicked");
    };
}

- (void)inputViewOKAction
{
    [alert dismissAlert];
    [self loadSoccerData];
}

- (void)loadSoccerData
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.view addSubview:HUD];
    }
    [HUD show:YES];
    HUD.labelText = @"正在加载";
    NSString *url = [NSString stringWithFormat:@"%@:8080/webgogo/queryAllGradeAction?xh=%@&password=%@",kHost,_studentId,_password];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self finishLoadData:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishLoadData:(NSData *)data
{
    [HUD hide:YES];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if ([str isEqualToString:@"{\"data\":[{\"status\":\"password_error\"}]}"]) {
        [MBProgressHUD showMsg:backgroundView title:@"获取失败，用户名或密码错误" delay:3];
        _studentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentId"];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        [self performSelector:@selector(showInputStdInfo) withObject:nil afterDelay:3];
        return;
    }
//    if ([str isEqualToString:@"{\"data\":[]}"]) {
//        [MBProgressHUD showMsg:backgroundView title:@"你暂时还没有成绩" delay:2];
//        return;
//    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *gradeArr = [dic objectForKey:@"data"];
    if ([gradeArr isKindOfClass:[NSNull class]]) {
        [MBProgressHUD showMsg:backgroundView title:@"获取失败，教务管理系统抽风了" delay:3];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:_studentId forKey:@"studentId"];
    [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (gradeItems == nil) {
        gradeItems = [[NSMutableArray alloc] init];
    }
    [gradeItems removeAllObjects];
    maxSemester = 0;
    for (NSDictionary *dic in gradeArr) {
        GradeItem *item = [[GradeItem alloc] init];
        [item setDic:dic];
        if (maxSemester < item.semester) {
            maxSemester = item.semester;
        }
        [gradeItems addObject:item];
    }
    if (gradeSeItems == nil) {
        gradeSeItems = [[NSMutableArray alloc] init];
    }
    [gradeSeItems removeAllObjects];
    for (int i = 0; i < maxSemester; i++) {
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (GradeItem *item in gradeItems) {
            if (item.semester == i+1) {
                [tmpArr addObject:item];
            }
        }
        [gradeSeItems addObject:tmpArr];
    }
    if (gradeTableView == nil) {
        gradeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64 - 40)];
        [gradeTableView setDelegate:self];
        [gradeTableView setDataSource:self];
        [backgroundView addSubview:gradeTableView];
        [gradeTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [gradeTableView setBackgroundColor:[UIColor clearColor]];
    }
    if (toolView == nil) {
        toolView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 60 + (navBarH - 44), kScreenWidth, 40)];
        [toolView setBackgroundColor:UIColorFromRGB(0x24292c)];
    }
    if (refreshButton == nil) {
        refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 80 - 5 , 5, 80, 30)];
        [refreshButton setBackgroundColor:UIColorFromRGB(0x99cc00)];
        [refreshButton.layer setCornerRadius:15.0f];
        [refreshButton setTitle:@"更新成绩" forState:UIControlStateNormal];
        [refreshButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [refreshButton addTarget:self action:@selector(loadSoccerData) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:refreshButton];
    }
    //[loginButton setShadow];
    if (changeIdButton == nil) {
        [changeIdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        changeIdButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth/2 + 5, 5, 80, 30)];
        [changeIdButton setBackgroundColor:UIColorFromRGB(0x01a2ff)];
        [changeIdButton.layer setCornerRadius:15.0f];
        [changeIdButton setTitle:@"更换学号" forState:UIControlStateNormal];
        [changeIdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changeIdButton.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
        [changeIdButton addTarget:self action:@selector(showInputStdInfo) forControlEvents:UIControlEventTouchUpInside];
        [toolView addSubview:changeIdButton];
    }
    [backgroundView addSubview:toolView];
    
    [gradeTableView reloadData];
    NSInteger nn = gradeTableView.numberOfSections;
    if (nn == 0) {
        [MBProgressHUD showMsg:backgroundView title:@"你暂时还没有成绩" delay:2];
        return;
    }
    NSInteger nr = [gradeTableView numberOfRowsInSection:nn - 1];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:nr - 1 inSection:nn - 1];
    [gradeTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = [gradeSeItems objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[GradeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSArray *arr = [gradeSeItems objectAtIndex:indexPath.section];
    GradeItem *item = [arr objectAtIndex:indexPath.row];
    [cell setItem:item];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return gradeSeItems.count;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, kScreenWidth, 50)];
    [view setImage:[UIImage imageNamed:@"headView.png"]];
    [view setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 200, 20)];
    [view addSubview:label];
    [label setBackgroundColor:[UIColor grayColor]];
    [label setText:[NSString stringWithFormat:@"第%d学期",section+1]];
    [label setFont:[UIFont systemFontOfSize:14.0f]];
    [label setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (void)failedLoadData
{
    [HUD hide:YES];
    [MBProgressHUD showMsg:backgroundView title:@"加载失败，请检查网络" delay:3];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"成绩查询"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"成绩查询"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
