//
//  BookBorrowViewCell.m
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BookBorrowViewCell.h"

@implementation BookBorrowViewCell

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
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth - 10, 20)];
    [nameLabel setFont:[UIFont systemFontOfSize:16.f]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:nameLabel];
    
    backTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 33, 200, 20)];
    [backTimeLabel setFont:[UIFont systemFontOfSize:15.f]];
    [backTimeLabel setBackgroundColor:[UIColor clearColor]];
    [backTimeLabel setTextColor:UIColorFromRGB(0x99cc00)];
    [self.contentView addSubview:backTimeLabel];
    
    noticeButton = [[UIButton alloc] initWithFrame:CGRectMake(250 , 34, 60, 20)];
    [noticeButton setBackgroundColor:UIColorFromRGB(0x99cc00)];
    [noticeButton.layer setCornerRadius:10.f];
    [noticeButton setTitle:@"设置提醒" forState:UIControlStateNormal];
    [noticeButton.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [noticeButton addTarget:self action:@selector(registerNotice) forControlEvents:UIControlEventTouchUpInside];
    [noticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.contentView addSubview:noticeButton];
}

- (void)registerNotice
{
    if (_noticationBlock) {
        _noticationBlock(_item.backtime,_item.name);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    nameLabel.text = _item.name;
    backTimeLabel.text = [NSString stringWithFormat:@"应还日期:%@",_item.backtime];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
