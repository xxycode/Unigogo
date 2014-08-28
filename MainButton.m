//
//  MainButton.m
//  Unigogo
//
//  Created by Apple on 14-6-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MainButton.h"

@implementation MainButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect myFrame = frame;
        //myFrame.size.width = 115;
        //myFrame.size.height = 115;
        [self.layer setCornerRadius:myFrame.size.width/2];
    }
    return self;
}

- (void)setBottomTitle:(NSString *)title
{
    _btnTitle = title;
    CGSize size = self.frame.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width + 20.f, 30)];
    [label setCenter:CGPointMake(size.width/2, size.height/2+size.height/2+10.5)];
    [label setText:title];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    if (_font != nil) {
        [label setFont:_font];
    }
    [self addSubview:label];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTag:238];
}

- (void)setTitleColor:(UIColor *)color
{
    UILabel *label = (UILabel *)[self viewWithTag:238];
    [label setTextColor:color];
}


- (void)startShake
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, -0.1, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(self.layer.transform, 0.1, 0, 0, 1)];
    
    [self.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}
- (void)stopShake
{
    [self.layer removeAnimationForKey:@"shakeAnimation"];
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
