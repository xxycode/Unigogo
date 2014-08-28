//
//  MainViewController.h
//  Unigogo
//
//  Created by Apple on 14-6-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BaseViewController.h"
#import "CommunityViewController.h"

@interface MainViewController : BaseViewController<UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *mainIconArr;
    NSMutableArray *mainTitleArr;
    NSInteger countOfCurrentButton;
    NSTimer *myTimer;
    CGFloat marginTop;
    CGFloat iconHeight;
    UIScrollView *mainView;
    NSMutableArray *btnArr;
    BOOL contain;
    NSInteger currBtn;
    CGPoint startPoint;
    CGPoint originPoint;
    UIPageControl *pageControl;
    NSTimer *timer;
    CommunityViewController *communityVC;
    NSString *uurl;
}
@end
