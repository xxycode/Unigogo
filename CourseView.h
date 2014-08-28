//
//  CourseView.h
//  Unigogo
//
//  Created by xxy on 14-6-24.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseView : UIView
{
    UIScrollView *coursePain;
}

@property (nonatomic, assign) NSInteger weekDay;
- (void)drawCourseWithCourseArr:(NSArray *)arr;

@end
