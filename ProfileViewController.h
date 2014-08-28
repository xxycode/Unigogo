//
//  ProfileViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-10.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BaseViewController.h"
#import "TopicItem.h"
#import "XxyTableView.h"
#import "XxyHttpRequest.h"
#import "MBProgressHUD.h"
#import "ODRefreshControl.h"
#import "UIImageView+WebCache.h"
#import "TopicCell.h"
#import "TopicItem.h"
#import "TopicDetailViewController.h"
#import "LoginViewController.h"
#import "CommentViewController.h"
#import "PersonSetViewController.h"

@interface ProfileViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    ODRefreshControl *refreshControl;
    MBProgressHUD *HUD;
    UIImageView *headBackgroundView;
    XxyTableView *topicTableView;
    UIImageView *proHeadImage;
    UILabel *usernameLabel;
    NSInteger currPage;
    UIView *zheView;
    UIButton *backBtn;
    NSString *delTid;
    UIButton *editBtn;
    NSInteger sex;
    PersonSetViewController *perViewController;
}

@property (nonatomic, assign) BOOL editAble;
@property (nonatomic, strong) NSString *uid;

@end
