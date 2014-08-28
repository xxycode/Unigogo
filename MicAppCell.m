//
//  MicAppCell.m
//  Unigogo
//
//  Created by xxy on 14-8-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MicAppCell.h"

@implementation MicAppCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_iconView sd_setImageWithURL:[NSURL URLWithString:[_dic objectForKey:@"icon"]] placeholderImage:[UIImage imageNamed:@"micplace.png"]];
    [_titLabel setText:[_dic objectForKey:@"name"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
