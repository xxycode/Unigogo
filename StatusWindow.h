//
//  StatusWindow.h
//  Unigogo
//
//  Created by xxy on 14-7-1.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusWindow : UIWindow
{
    UILabel *_messageLabel;
}

+ (StatusWindow *)sharedWindow;
- (void)showStatusMessage:(NSString *)message;
- (void)hide:(NSString *)message;

@end
