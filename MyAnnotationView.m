//
//  MyAnnotationView.m
//  Unigogo
//
//  Created by xxy on 14-7-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MyAnnotationView.h"
#import "UIButton+setFrame.h"
#define  Arror_height 6

@implementation MyAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        //self.centerOffset = CGPointMake(0, -55);
        self.frame = CGRectMake(0, 0, 120, 35);
        titView = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, self.frame.size.width - 10, 20)];
        [titView setText:annotation.title];
        [titView setTextColor:[UIColor blackColor]];
        [titView setFont:[UIFont systemFontOfSize:12.f]];
        deBtn = [[UIButton alloc] initWithFrame:CGRectMake([titView getRight] + 5, 7, 27.0/2, 27.0/2)];
        [deBtn addTarget:self action:@selector(btnAct) forControlEvents:UIControlEventTouchUpInside];
        [deBtn setImage:[UIImage imageNamed:@"ndet.png"] forState:UIControlStateNormal];
        [self addSubview:deBtn];
        [self addSubview:titView];
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnAct)];
        [self addGestureRecognizer:tapGR];
    }
    return self;
    
}

- (void)btnAct
{
    NSLog(@"!!!!");
    if (_showNdet) {
        _showNdet();
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    NSInteger l = _title.length;
    CGFloat w = l * 12 + 30;
    CGRect f = self.frame;
    f.size.width = w;
    [self setFrame:f];
    [titView setFrame:CGRectMake(5, 4, f.size.width - 10, 20)];
    [titView setText:_title];
    [deBtn setX: w - 27.0/2 - 8];
}

- (void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 0.35;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    // midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
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
