//
//  DayCourseCell.h
//  Unigogo
//
//  Created by xxy on 14-6-25.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface DayCourseCell : UITableViewCell
{
    UILabel *titLabel;
    UILabel *courseLabel;
    UILabel *locationLabel;
    UILabel *teacherLabel;
    UIImageView *loIcon;
    UIImageView *tecIcon;
}
@property (nonatomic, strong) NSString *titleTime;
@property (nonatomic, strong) Course *course;

- (void)setTitleTime:(NSString *)titleTime course:(Course *)course;

@end
