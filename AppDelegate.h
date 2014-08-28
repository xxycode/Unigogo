//
//  AppDelegate.h
//  Unigogo
//
//  Created by Apple on 14-6-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    RootViewController *rootViewController;
}

@property (strong, nonatomic) UIWindow *window;

- (void)showMsg:(NSString *)title delay:(NSTimeInterval)delay;

@end
