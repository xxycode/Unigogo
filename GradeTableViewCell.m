//
//  GradeTableViewCell.m
//  Unigogo
//
//  Created by xxy on 14-7-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "GradeTableViewCell.h"

@implementation GradeTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}
- (void)initViews
{
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(7, 3, kScreenWidth - 14, 55)];
    [bgView setBackgroundColor:[UIColor colorWithRed:222/255.0 green:222/255.0 blue:222/255.0 alpha:0.9]];
    [self addSubview:bgView];
    slideView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, 55)];
    [slideView setBackgroundColor:UIColorFromRGB(0x99cc00)];
    [bgView addSubview:slideView];
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 5, kScreenWidth - 14 - 10, 18)];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [nameLabel setTextColor:UIColorFromRGB(0x88b501)];
    ksTit = [[UILabel alloc] initWithFrame:CGRectMake(5, 22, 60, 16)];
    [ksTit setBackgroundColor:[UIColor clearColor]];
    [ksTit setFont:[UIFont systemFontOfSize:14.0f]];
    [ksTit setTextAlignment:NSTextAlignmentCenter];
    [ksTit setText:@"考试成绩"];
    ksScore = [[UILabel alloc] initWithFrame:CGRectMake(5, 38, 60, 16)];
    [ksScore setBackgroundColor:[UIColor clearColor]];
    [ksScore setFont:[UIFont systemFontOfSize:14.0f]];
    [ksScore setTextAlignment:NSTextAlignmentCenter];
    psTit = [[UILabel alloc] initWithFrame:CGRectMake(65, 22, 60, 16)];
    [psTit setBackgroundColor:[UIColor clearColor]];
    [psTit setFont:[UIFont systemFontOfSize:14.0f]];
    [psTit setTextAlignment:NSTextAlignmentCenter];
    [psTit setText:@"平时成绩"];
    psScore = [[UILabel alloc] initWithFrame:CGRectMake(65, 38, 60, 16)];
    [psScore setBackgroundColor:[UIColor clearColor]];
    [psScore setFont:[UIFont systemFontOfSize:14.0f]];
    [psScore setTextAlignment:NSTextAlignmentCenter];
    qpTit = [[UILabel alloc] initWithFrame:CGRectMake(125, 22, 60, 16)];
    [qpTit setBackgroundColor:[UIColor clearColor]];
    [qpTit setFont:[UIFont systemFontOfSize:14.0f]];
    [qpTit setTextAlignment:NSTextAlignmentCenter];
    [qpTit setText:@"期评成绩"];
    qpScore = [[UILabel alloc] initWithFrame:CGRectMake(125, 38, 60, 16)];
    [qpScore setBackgroundColor:[UIColor clearColor]];
    [qpScore setFont:[UIFont systemFontOfSize:14.0f]];
    [qpScore setTextAlignment:NSTextAlignmentCenter];
    creTit = [[UILabel alloc] initWithFrame:CGRectMake(185, 22, 60, 16)];
    [creTit setBackgroundColor:[UIColor clearColor]];
    [creTit setFont:[UIFont systemFontOfSize:14.0f]];
    [creTit setTextAlignment:NSTextAlignmentCenter];
    [creTit setText:@"学分"];
    credit = [[UILabel alloc] initWithFrame:CGRectMake(185, 38, 60, 16)];
    [credit setBackgroundColor:[UIColor clearColor]];
    [credit setFont:[UIFont systemFontOfSize:14.0f]];
    [credit setTextAlignment:NSTextAlignmentCenter];
    typeTit = [[UILabel alloc] initWithFrame:CGRectMake(235, 22, 70, 16)];
    [typeTit setBackgroundColor:[UIColor clearColor]];
    [typeTit setFont:[UIFont systemFontOfSize:14.0f]];
    [typeTit setTextAlignment:NSTextAlignmentCenter];
    [typeTit setText:@"考试类型"];
    type = [[UILabel alloc] initWithFrame:CGRectMake(235, 38, 70, 16)];
    [type setBackgroundColor:[UIColor clearColor]];
    [type setFont:[UIFont systemFontOfSize:14.0f]];
    [type setTextAlignment:NSTextAlignmentCenter];
    [bgView addSubview:nameLabel];
    [bgView addSubview:ksTit];
    [bgView addSubview:ksScore];
    [bgView addSubview:psTit];
    [bgView addSubview:psScore];
    [bgView addSubview:qpTit];
    [bgView addSubview:qpScore];
    [bgView addSubview:creTit];
    [bgView addSubview:credit];
    [bgView addSubview:typeTit];
    [bgView addSubview:type];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [nameLabel setText:_item.name];
    [ksScore setText:_item.ksScore];
    [psScore setText:[NSString stringWithFormat:@"%ld",(long)_item.psScore]];
    [qpScore setText:_item.qpScore];
    [credit setText:[NSString stringWithFormat:@"%ld",(long)_item.credit]];
    [type setText:_item.type];
    if (_item.qpScore.integerValue > 0&& _item.qpScore.integerValue < 60) {
        [slideView setBackgroundColor:UIColorFromRGB(0xfa2424)];
    }else if([_item.qpScore isEqualToString:@"不及格"]){
        [slideView setBackgroundColor:UIColorFromRGB(0xfa2424)];
    }else{
        [slideView setBackgroundColor:UIColorFromRGB(0x99cc00)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
