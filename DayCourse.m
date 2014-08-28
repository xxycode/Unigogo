//
//  DayCourse.m
//  Unigogo
//
//  Created by xxy on 14-6-25.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "DayCourse.h"
#import "Course.h"
#import "DayCourseCell.h"

@implementation DayCourse

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        frame.size.width = kScreenWidth;
        frame.size.height = kScreenHeight - 64 - 40;
        [self setFrame:frame];
        UIImageView * backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:backgroundView];
        [backgroundView setUserInteractionEnabled:YES];
        [backgroundView setImage:[UIImage imageNamed:@"loginbg.png"]];
        //[self setBackgroundColor:UIColorFromRGB(0xdddddd)];
    }
    return self;
}

- (void)drawCourseWithCourseArr:(NSArray *)arr
{
    NSMutableArray *arr1 = [[NSMutableArray alloc] init];
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    NSMutableArray *arr3 = [[NSMutableArray alloc] init];
    NSMutableArray *arr4 = [[NSMutableArray alloc] init];
    NSMutableArray *arr5 = [[NSMutableArray alloc] init];
    NSMutableArray *arr6 = [[NSMutableArray alloc] init];
    NSMutableArray *arr7 = [[NSMutableArray alloc] init];
    for (Course *course in arr) {
        int week = course.week.intValue;
        switch (week) {
            case 1:
                [arr1 addObject:course];
                break;
            case 2:
                [arr2 addObject:course];
                break;
            case 3:
                [arr3 addObject:course];
                break;
            case 4:
                [arr4 addObject:course];
                break;
            case 5:
                [arr5 addObject:course];
                break;
            case 6:
                [arr6 addObject:course];
                break;
            case 7:
                [arr7 addObject:course];
                break;
            default:
                break;
        }
    }
    [dayData removeAllObjects];
    dayData = [NSMutableArray arrayWithObjects:arr1,arr2,arr3,arr4,arr5,arr6,arr7,nil];
    [self initViews];
}


- (void)initViews
{
    //CGRect
    if (dayView == nil) {
        dayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    }
    CGFloat pWidth = kScreenWidth/7.0;
    CGFloat x = 0;
    NSArray *dayArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"日"];
    if (topBgView == nil) {
        topBgView = [[UIView alloc] initWithFrame:CGRectMake((pWidth/2 - 14) + (_weekDay - 1) * pWidth, 3, 26, 26)];
        [topBgView.layer setCornerRadius:13.0f];
        [dayView addSubview:topBgView];
        [topBgView setBackgroundColor:UIColorFromRGB(0x99cc00)];
        for (int i = 0; i < 7; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 7, pWidth, 18)];
            x += pWidth;
            if (i == _weekDay - 1) {
                [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
            }
            [btn setTitle:[dayArr objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTag:100+i];
            [btn addTarget:self action:@selector(topBtnsAct:) forControlEvents:UIControlEventTouchUpInside];
            [dayView addSubview:btn];
            
        }
        [self addSubview:dayView];
    }if (coursePain == nil) {
        coursePain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, kScreenHeight - 30 - 64 - 40)];
        [coursePain setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.7]];
        CGFloat tx = 0;
        for (int i = 0; i < 7; i ++) {
            UITableView *courseList = [[UITableView alloc] initWithFrame:CGRectMake(tx, 5, kScreenWidth, coursePain.bounds.size.height)];
            [courseList setDelegate:self];
            [courseList setDataSource:self];
            [courseList setTag:2014 + i];
            tx += kScreenWidth;
            [coursePain addSubview:courseList];
            [courseList setBackgroundColor:[UIColor clearColor]];
        }
        [coursePain setShowsHorizontalScrollIndicator:NO];
        [coursePain setContentOffset:CGPointMake(kScreenWidth * (_weekDay - 1), 0)];
        [coursePain setContentSize:CGSizeMake(kScreenWidth * 7, coursePain.bounds.size.height)];
        [coursePain setPagingEnabled:YES];
        [coursePain setDelegate:self];
        [self addSubview:coursePain];
    }
    for (UIView *view in coursePain.subviews) {
        if ([view isKindOfClass:[UITableView class]]) {
            UITableView *list = (UITableView *)view;
            [list reloadData];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView class] != [UITableView class]) {
        CGFloat f = scrollView.contentOffset.x/kScreenWidth;
        if (f - (int)f == 0) {
            for (int i = 0; i < 7; i ++) {
                UIButton *btn = (UIButton *)[dayView viewWithTag:100+i];
                [btn setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
            }
            CGFloat pWidth = kScreenWidth/7.0;
            CGRect frame = topBgView.frame;
            frame.origin.x = (pWidth/2 - 14) + f * pWidth;
            [UIView animateWithDuration:0.35 animations:^{
                [topBgView setFrame:frame];
            } completion:^(BOOL finished){
                UIButton *btn = (UIButton *)[dayView viewWithTag:100+(int)f];
                [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            }];
        }
    }
}

- (NSString *)getTitNumWithIndex:(NSInteger)tableIndex cellIndex:(NSInteger)cellIndex
{
    NSArray *currData = [dayData objectAtIndex:tableIndex];
    NSArray *arr = [self getCellData:currData];
    NSString *str = [arr objectAtIndex:cellIndex];
    return str;
}


- (Course *)getCourseWithIndex:(NSInteger)tableIndex cellIndex:(NSInteger)cellIndex
{
    NSArray *currData = [dayData objectAtIndex:tableIndex];
    NSArray *tmp = [self getCellCourse:currData];
    id item = [tmp objectAtIndex:cellIndex];
    if ([item class] == [Course class]) {
        return item;
    }else{
        return nil;
    }
}

- (void)topBtnsAct:(UIButton *)button
{
    long f = button.tag - 100;
    for (int i = 0; i < 7; i ++) {
        UIButton *btn = (UIButton *)[dayView viewWithTag:100+i];
        [btn setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    }
    CGFloat pWidth = kScreenWidth/7.0;
    CGRect frame = topBgView.frame;
    frame.origin.x = (pWidth/2 - 14) + f * pWidth;
    [UIView animateWithDuration:0.35 animations:^{
        [topBgView setFrame:frame];
    } completion:^(BOOL finished){
        UIButton *btn = (UIButton *)[dayView viewWithTag:100+(int)f];
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    }];
    [coursePain setContentOffset:CGPointMake(f * kScreenWidth, 0) animated:YES];
}

- (NSArray *)getCellCourse:(NSArray *)arr
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:arr];
    int flag = 0;
    int i = 1;
    while (i <= 11) {
        flag = 0;
        for (int j = 0; j < tmpArr.count ; j++) {
            Course *course = [tmpArr objectAtIndex:j];
            if (course.sequence.integerValue * 2 - 1 == i) {
                if (course.length == 3) {
                    [res addObject:course];
                    i += 3;
                    flag = 1;
                } else {
                    [res addObject:course];
                    i += 2;
                    flag = 1;
                }
            }
        }
        if (flag == 0) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [res addObject:str];
            i ++;
        }
    }
    return res;
}



- (NSArray *)getCellData:(NSArray *)arr
{
    NSMutableArray *res = [[NSMutableArray alloc] init];
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:arr];
    int flag = 0;
    int i = 1;
    while (i <= 11) {
        flag = 0;
        for (int j = 0; j < tmpArr.count ; j++) {
            Course *course = [tmpArr objectAtIndex:j];
            if (course.sequence.integerValue * 2 - 1 == i) {
                if (course.length == 3) {
                    NSString *str = [NSString stringWithFormat:@"%d-%d",i,i+2];
                    [res addObject:str];
                    i += 3;
                    flag = 1;
                } else {
                    NSString *str = [NSString stringWithFormat:@"%d-%d",i,i+1];
                    [res addObject:str];
                    i += 2;
                    flag = 1;
                }
            }
        }
        if (flag == 0) {
            NSString *str = [NSString stringWithFormat:@"%d",i];
            [res addObject:str];
            i ++;
        }
    }
    //NSLog(@"%d",res.count);
    return res;
}

- (CGFloat)getCellHeightWithIndex:(NSInteger)tableIndex cellIndex:(NSInteger) cellIndex
{
    NSArray *currData = [dayData objectAtIndex:tableIndex];
    NSArray *tmp = [self getCellCourse:currData];
    id item = [tmp objectAtIndex:cellIndex];
    if ([item class] == [Course class]) {
        return 65;
    }else{
        return 40;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = 11;
    NSInteger index = tableView.tag - 2014;
    NSArray *currData = [dayData objectAtIndex:index];
    for (Course *course in currData) {
        count --;
        if (course.length == 3) {
            count --;
        }
    }
    return count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = tableView.tag - 2014;
    CGFloat height = [self getCellHeightWithIndex:index cellIndex:indexPath.row];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = tableView.tag - 2014;
    static NSString *identify = @"cell";
    DayCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[DayCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    NSString *titNum = [self getTitNumWithIndex:index cellIndex:indexPath.row];
    Course *course = [self getCourseWithIndex:index cellIndex:indexPath.row];
    [cell setTitleTime:titNum course:course];
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
