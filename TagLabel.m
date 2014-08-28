//
//  TagLabel.m
//  Unigogo
//
//  Created by xxy on 14-6-30.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "TagLabel.h"

@implementation TagLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 3, 0, 3);
    return[super drawTextInRect:UIEdgeInsetsInsetRect(rect,inset)];
}

@end
