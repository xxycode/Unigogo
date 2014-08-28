//
//  UIButton+setFrame.m
//  Unigogo
//
//  Created by xxy on 14-6-27.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "UIButton+setFrame.h"

@implementation UIView (setFrame)

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    [self setFrame:frame];
}
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    [self setFrame:frame];
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    [self setFrame:frame];
}

- (void)setShadow
{
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.layer setShadowOpacity:0.7f];
    [self.layer setShadowRadius:1.0f];
}

- (CGFloat)getBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)getRight
{
    return self.frame.origin.x + self.frame.size.width;
}

@end
