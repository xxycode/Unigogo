//
//  PubNavView.m
//  Unigogo
//
//  Created by xxy on 14-6-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubNavView.h"

@implementation PubNavView

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
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取当前ctx
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(ctx, 1.0);  //线宽
    CGContextSetAllowsAntialiasing(ctx, YES);
    CGContextSetRGBStrokeColor(ctx, 172.0/255.0, 172.0/255.0, 172.0/255.0, 1.0);  //颜色
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, 0, rect.size.height);  //起点坐标
    CGContextAddLineToPoint(ctx, kScreenWidth, rect.size.height);   //终点坐标
    CGContextStrokePath(ctx);
}



@end
