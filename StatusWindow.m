//
//  StatusWindow.m
//  Unigogo
//
//  Created by xxy on 14-7-1.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "StatusWindow.h"

@implementation StatusWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = [UIApplication sharedApplication].statusBarFrame;
        self.backgroundColor = [UIColor blackColor];
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
    }
    return self;
}

+ (StatusWindow *)sharedWindow
{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] initWithFrame:CGRectMake(kScreenWidth - 100, 0, 100, 20)]; // or some other init method
    });
    return _sharedObject;
}

- (void)showStatusMessage:(NSString *)message
{
    self.hidden = NO;
    self.alpha = 1.0f;
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        [_messageLabel setBackgroundColor:[UIColor clearColor]];
        if (kVersion >= 7.0) {
            [self setBackgroundColor:[UIColor whiteColor]];
            [_messageLabel setTextColor:[UIColor blackColor]];
        }else{
            [self setBackgroundColor:[UIColor blackColor]];
            [_messageLabel setTextColor:[UIColor whiteColor]];
        }
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        [_messageLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self addSubview:_messageLabel];
    }
    _messageLabel.text = message;
    self.frame = CGRectMake(kScreenWidth - 100, -20, 100, 20);
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(kScreenWidth - 100, 0, 100, 20);
    }];
}

- (void)hiden
{
    self.alpha = 1.0f;
    [UIView animateWithDuration:0.5f animations:^{
        self.frame = CGRectMake(kScreenWidth - 100, -20, 100, 20);
    }];;
}

- (void)hide:(NSString *)message
{
    [_messageLabel setText:message];
    self.alpha = 1.0f;
    [UIView animateWithDuration:0.5f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished){
        _messageLabel.text = @"";
        self.hidden = YES;
    }];;
}

//- (void)hide
//{
//    self.alpha = 1.0f;
//    [UIView animateWithDuration:0.5f animations:^{
//        self.alpha = 0.0f;
//    } completion:^(BOOL finished){
//        _messageLabel.text = @"";
//        self.hidden = YES;
//    }];;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
