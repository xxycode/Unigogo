//
//  DayCourseCell.m
//  Unigogo
//
//  Created by xxy on 14-6-25.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "DayCourseCell.h"

@implementation DayCourseCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 50, 40)];
    [titLabel setBackgroundColor:[UIColor clearColor]];
    [titLabel setTextAlignment:NSTextAlignmentCenter];
    [titLabel setTextColor:UIColorFromRGB(0xef760b)];
    [titLabel setFont:[UIFont systemFontOfSize:16.0f]];
    courseLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 2, 250, 20)];
    [courseLabel setBackgroundColor:[UIColor clearColor]];
    [courseLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [courseLabel setTextColor:UIColorFromRGB(0x99cc00)];
    tecIcon = [[UIImageView alloc] initWithFrame:CGRectMake(47, 24, 15, 15)];
    [tecIcon setHidden:YES];
    [self addSubview:tecIcon];
    loIcon = [[UIImageView alloc] initWithFrame:CGRectMake(47, 44, 15, 15)];
    [loIcon setHidden:YES];
    [self addSubview:loIcon];
    teacherLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 22, 100, 20)];
    [teacherLabel setBackgroundColor:[UIColor clearColor]];
    [teacherLabel setFont:[UIFont systemFontOfSize:14.0f]];
    locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 42, 100, 20)];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    [locationLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self addSubview:titLabel];
    [self addSubview:courseLabel];
    [self addSubview:teacherLabel];
    [self addSubview:locationLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_course != nil) {
        CGRect frame = titLabel.frame;
        frame.origin.y = 12;
        [titLabel setFrame:frame];
        [tecIcon setHidden:NO];
        [tecIcon setImage:[UIImage imageNamed:@"teacher.png"]];
        [loIcon setHidden:NO];
        [loIcon setImage:[UIImage imageNamed:@"loca.png"]];
    }else{
        CGRect frame = titLabel.frame;
        frame.origin.y = 3;
        [titLabel setFrame:frame];
        [tecIcon setHidden:YES];
        [loIcon setHidden:YES];
    }
    [titLabel setText:_titleTime];
    [courseLabel setText:_course.name];
    [teacherLabel setText:_course.teacher];
    [locationLabel setText:_course.address];
}

- (void)setTitleTime:(NSString *)titleTime course:(Course *)course
{
    _titleTime = titleTime;
    _course = course;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
