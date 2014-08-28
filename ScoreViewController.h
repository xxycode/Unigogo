//
//  ScoreViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "ODRefreshControl.h"
#import "DXAlertView.h"
#import "MBProgressHUD.h"

@interface ScoreViewController : PubViewController<UITableViewDataSource,UITableViewDelegate>
{
    MBProgressHUD *HUD;
    ODRefreshControl *refreshControl;
    DXAlertView *alert;
    NSMutableArray *gradeItems;
    NSMutableArray *gradeSeItems;
    UITableView *gradeTableView;
    NSInteger maxSemester;
    UIButton *refreshButton;
    UIButton *changeIdButton;
    UIView *toolView;
}

@property(nonatomic, strong) NSString *studentId;
@property(nonatomic, strong) NSString *password;

@end
