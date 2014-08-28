//
//  LessonViewController.m
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LessonViewController.h"
#import "Course.h"
#import "XxyHttprequest.h"
#import "KxMenu.h"

@interface LessonViewController ()

@end

@implementation LessonViewController

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
    [self setTitle:@"课表查询"];
    
    [self initCourseView];
    [self loadCorse];
    //[self readFile];
    // Do any additional setup after loading the view.
}

- (void)initCourseView
{
//
//    [self.view bringSubviewToFront:self.navView];
//    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];

    
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8]];
    CGFloat navH = kVersion >= 7.0? 64:44;
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight - 64 - 40)];
    //[contentView setBackgroundColor:UIColorFromRGB(0xdddddd)];
    dayCourseView = [[DayCourse alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40)];
    [dayCourseView setWeekDay:[self getWeekDay]];
    [contentView addSubview:dayCourseView];
    [dayCourseView setTag:852];
    [self.view addSubview:contentView];
    courseView = [[CourseView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [contentView addSubview:courseView];
    [courseView setTag:851];
    CGFloat delt = kVersion >= 7.0? 40:60;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - delt, kScreenWidth, 40)];
    [bottomView setBackgroundColor:UIColorFromRGB(0x24292c)];
    instagramSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"整周", @"单日"]];
    instagramSegmentedControl.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    instagramSegmentedControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    instagramSegmentedControl.segmentIndicatorInset = 0.0f;
    instagramSegmentedControl.titleTextColor = [UIColor lightGrayColor];
    instagramSegmentedControl.selectedTitleTextColor = [UIColor darkGrayColor];
    [instagramSegmentedControl sizeToFit];
    instagramSegmentedControl.center = CGPointMake(bottomView.center.x, 20.0f);
    [instagramSegmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    [bottomView addSubview:instagramSegmentedControl];
    UIButton *navMoreButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 43, 5+(navH - 44), 43, 34)];
    [navMoreButton setBackgroundImage:[UIImage imageNamed:@"nav_more_nor.png"] forState:UIControlStateNormal];
    [navMoreButton setBackgroundImage:[UIImage imageNamed:@"nav_more_f.png"] forState:UIControlStateHighlighted];
    [navMoreButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:navMoreButton];
    [self.view addSubview:bottomView];
}

- (void)loadCorse
{
    NSData *course = [[NSUserDefaults standardUserDefaults] objectForKey:@"course"];
    if (course == nil) {
        _studentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentIdc"];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordc"];
        if (_studentId == nil || _password == nil) {
            [self showInputStdInfo];
        }else{
            [self loadSoccerData];
        }
    } else{
        [self loadCourseByData:course];
    }
}

#pragma mark Act
- (void)showInputStdInfo
{
    alert = [[DXAlertView alloc] initWithTitle:@"请输入学号和密码" contentText:@"你的学号和密码只会被保存在本地" leftButtonTitle:@"确认" rightButtonTitle:@"取消"];
    [alert show];
    __block DXAlertView *tmpAlert = alert;
    __block LessonViewController *scV = self;
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
    NSString *url = [NSString stringWithFormat:@"%@:8080/webgogo/queryScheduleAction?studentId=%@&password=%@",kHost,_studentId,_password];
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
    if ([str isEqualToString:@"{\"map\":{\"status\":[{\"name\":\"user_error\"}]}}"]) {
        [MBProgressHUD showMsg:self.view title:@"加载失败，用户名或密码错误" delay:3];
        _studentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentIdc"];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordc"];
        [self performSelector:@selector(showInputStdInfo) withObject:nil afterDelay:3];
        return;
    }
    if ([str isEqualToString:@"{\"map\":{\"status\":[{\"name\":\"error\"}]}}"]) {
        [MBProgressHUD showMsg:self.view title:@"加载失败，教务管理系统抽风了" delay:3];
        _studentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentIdc"];
        _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordc"];
        [self performSelector:@selector(showInputStdInfo) withObject:nil afterDelay:3];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:_studentId forKey:@"studentIdc"];
    [[NSUserDefaults standardUserDefaults] setObject:_password forKey:@"passwordc"];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"course"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self loadCourseByData:data];
}

- (void)loadCourseByData:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *map = [dic objectForKey:@"map"];
    
    NSArray *courseArr = [map objectForKey:@"curse"];
    
    NSMutableArray *cArr = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in courseArr) {
        Course *course = [[Course alloc] init];
        [course setDic:dic];
        [cArr addObject:course];
    }
    [courseView drawCourseWithCourseArr:cArr];
    [dayCourseView drawCourseWithCourseArr:cArr];
    [self initPage];
}

- (void)failedLoadData
{
    [MBProgressHUD showMsg:backgroundView title:@"加载失败，网络错误" delay:3];
}

- (void)showMenu:(UIButton *)sender
{
    NSMutableArray *menuItems = [NSMutableArray arrayWithArray:
                                 @[
                                   
                                   [KxMenuItem menuItem:@"更换学号"
                                                  image:[UIImage imageNamed:@"newInfo.png"]
                                                 target:self
                                                 action:@selector(showInputStdInfo)],
                                   
                                   [KxMenuItem menuItem:@"更新课表"
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
    _studentId = [[NSUserDefaults standardUserDefaults] objectForKey:@"studentIdc"];
    _password = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordc"];
    [self loadSoccerData];
}

- (void)segmentSelected:(NYSegmentedControl *)control
{
    
    NSInteger selectedIndex = control.selectedSegmentIndex;
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    NSInteger purple = [[contentView subviews] indexOfObject:[contentView viewWithTag:852]];
    NSInteger maroon = [[contentView subviews] indexOfObject:[contentView viewWithTag:851]];
    if (selectedIndex == 1) {
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromLeft forView:contentView cache:YES];
        [contentView exchangeSubviewAtIndex:purple withSubviewAtIndex:maroon];
    }else{
        [UIView setAnimationTransition: UIViewAnimationTransitionFlipFromRight forView:contentView cache:YES];
        [contentView exchangeSubviewAtIndex:maroon withSubviewAtIndex:purple];
    }
    [UIView commitAnimations];
    NSString *pag = [NSString stringWithFormat:@"%d",selectedIndex];
    [[NSUserDefaults standardUserDefaults] setObject:pag forKey:@"courseP"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)initPage
{
    
    NSString *pag = [[NSUserDefaults standardUserDefaults] objectForKey:@"courseP"];
    NSInteger selectedIndex;
    if (pag == nil) {
        selectedIndex = 0;
    }else{
        selectedIndex = pag.integerValue;
    }
    [instagramSegmentedControl setSelectedSegmentIndex:selectedIndex];
//    NSInteger purple = [[contentView subviews] indexOfObject:[contentView viewWithTag:852]];
//    NSInteger maroon = [[contentView subviews] indexOfObject:[contentView viewWithTag:851]];
//    NSLog(@"dsss %d",selectedIndex);
    if (selectedIndex == 1) {
        [contentView insertSubview:courseView belowSubview:dayCourseView];
    }else{
        [contentView insertSubview:courseView aboveSubview:dayCourseView];
    }
}

- (NSInteger)getWeekDay
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week = [comps weekday];
    if (week == 1) {
        return 7;
    }
    return week - 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"课表查询"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"课表查询"];
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
