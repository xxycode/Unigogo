//
//  TopExButton.m
//  Unigogo
//
//  Created by xxy on 14-7-8.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "TopExButton.h"

@implementation TopExButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        titLabel = [[UILabel alloc] init];
        [titLabel setBackgroundColor:[UIColor clearColor]];
        [titLabel setTextAlignment:NSTextAlignmentCenter];
        [titLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [titLabel setTextColor:UIColorFromRGB(0x888888)];
        [titLabel setFrame:CGRectMake(0, 26, 49, 14)];
        [self addSubview:titLabel];
    }
    return self;
}

- (void)setBottomTitle:(NSString *)title
{
    [titLabel setText:title];
}

- (NSString *)getBottomTitle
{
    return titLabel.text;
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
