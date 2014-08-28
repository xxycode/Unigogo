//
//  CourseView.m
//  Unigogo
//
//  Created by xxy on 14-6-24.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "CourseView.h"
#import "Course.h"

@implementation CourseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        frame.size.width = kScreenWidth;
        frame.size.height = kScreenHeight - 64 - 40;
        [self setFrame:frame];
        [self setBackgroundColor:UIColorFromRGB(0xdddddd)];
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIImageView * backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:backgroundView];
    [backgroundView setUserInteractionEnabled:YES];
    [backgroundView setImage:[UIImage imageNamed:@"loginbg.png"]];
    CGFloat x = 19.0f;
    NSArray *dayArr = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    for (int i = 0; i < 7; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, 43, 19)];
        [self addSubview:label];
        [label setFont:[UIFont systemFontOfSize:14.0f]];
        x +=43;
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:[dayArr objectAtIndex:i]];
        [label setTextColor:UIColorFromRGB(0x0e0e0e)];
    }
    coursePain = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 19, kScreenWidth, self.bounds.size.height - 19)];
    [coursePain setContentSize:CGSizeMake(kScreenWidth, 11*43)];
    [coursePain setBounces:NO];
    [coursePain setShowsVerticalScrollIndicator:NO];
    [self addSubview:coursePain];
}

- (void)drawCourseWithCourseArr:(NSArray *)arr
{
    for (UIView *view in coursePain.subviews) {
        [view removeFromSuperview];
    }
    CGFloat y = 22.5;
    CGFloat x2 = 9.5;
    for (int i = 0; i < 11; i ++) {
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
        [time setCenter:CGPointMake(x2, y)];
        y += 43;
        [time setText:[NSString stringWithFormat:@"%d",i + 1]];
        [time setBackgroundColor:[UIColor clearColor]];
        [time setTextAlignment:NSTextAlignmentCenter];
        [time setFont:[UIFont systemFontOfSize:14.0f]];
        //[time setTextColor:UIColorFromRGB(0x99cc00)];
        [coursePain addSubview:time];
    }
    for (Course *course in arr) {
        CGFloat x = (course.week.intValue - 1) * 44 + 19;
        CGFloat y = (course.sequence.intValue - 1) * 86;
        CGFloat height = course.length * 43 - 2;
        CGFloat width = 43 - 2;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [coursePain addSubview:view];
        [view setBackgroundColor:[UIColor colorWithRed:153/255.0 green:204/255.0 blue:0 alpha:0.5]];
        [view.layer setCornerRadius:5];
        CGRect frame = view.frame;
        UILabel *textView = [[UILabel alloc] initWithFrame:frame];
        [textView setBackgroundColor:[UIColor clearColor]];
        [textView setNumberOfLines:0];
        [textView setLineBreakMode:NSLineBreakByWordWrapping];
        [textView setTextColor:[UIColor whiteColor]];
        [textView setFont:[UIFont systemFontOfSize:11.0f]];
        [textView setTextAlignment:NSTextAlignmentCenter];
        [textView setText:[NSString stringWithFormat:@"%@@%@",course.name,course.address]];
        //[textView setCenter:view.center];
        [coursePain addSubview:textView];
    }
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
