//
//  LessonViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "CourseView.h"
#import "DayCourse.h"
#import "DXAlertView.h"
#import "MBProgressHUD.h"
#import "NYSegmentedControl.h"

@interface LessonViewController : PubViewController
{
    CourseView *courseView;
    UIView *bottomView;
    UIView *contentView;
    DayCourse *dayCourseView;
    MBProgressHUD *HUD;
    DXAlertView *alert;
    NYSegmentedControl *instagramSegmentedControl;
}

@property(nonatomic, strong) NSString *studentId;
@property(nonatomic, strong) NSString *password;

@end
