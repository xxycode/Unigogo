//
//  DayCourse.h
//  Unigogo
//
//  Created by xxy on 14-6-25.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayCourse : UIView<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *dayData;
    UIView *topBgView;
    UIView *dayView;
    UIScrollView *coursePain;
}
@property (nonatomic, assign) NSInteger weekDay;
- (void)drawCourseWithCourseArr:(NSArray *)arr;
@end
