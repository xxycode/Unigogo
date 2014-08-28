//
//  NewstdViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BaseViewController.h"
#import "NewStdButton.h"
#import "NewTopicViewController.h"
#import "XxyHttpRequest.h"
#import "XxyTableView.h"
#import "MBProgressHUD.h"
#import "ODRefreshControl.h"
#import "ProfileViewController.h"

@interface NewstdViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIButton *backBtn;
    ODRefreshControl *refreshControl;
    MBProgressHUD *HUD;
    XxyTableView *topicItemTableView;
    NSInteger currPage;
    UIView *navMoreView;
    BOOL isLoadingMore;
    NSArray *moreBtnArr;
    NSArray *itemArr;
    UIView *headView;
    UIButton *moreBtn;
}

@end
