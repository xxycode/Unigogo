//
//  FaceContentView.m
//  Unigogo
//
//  Created by xxy on 14-7-6.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "FaceContentView.h"

@implementation FaceContentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    _faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 165)];
    [_faceView setDelegate:self];
    [self addSubview:_faceView];
    [_faceView setShowsHorizontalScrollIndicator:NO];
    _pageCotrol = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 140, kScreenWidth, 15)];
    //[pageCotrol setBackgroundColor:[UIColor purpleColor]];
    [self addSubview:_pageCotrol];
    [_pageCotrol setCurrentPageIndicatorTintColor:UIColorFromRGB(0x99cc00)];
    [_pageCotrol setPageIndicatorTintColor:UIColorFromRGB(0xbfbfbf)];
    [_pageCotrol setHidden:NO];
    [_pageCotrol setNumberOfPages:4];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint p = scrollView.contentOffset;
    [_pageCotrol setCurrentPage:(p.x/kScreenWidth)];
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
