//
//  CommunityViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "NewTopicViewController.h"
#import "XxyHttpRequest.h"
#import "XxyTableView.h"
#import "MBProgressHUD.h"
#import "ODRefreshControl.h"
#import "ProfileViewController.h"

@interface CommunityViewController : PubViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    ODRefreshControl *refreshControl;
    MBProgressHUD *HUD;
    XxyTableView *topicItemTableView;
    NSInteger currPage;
    UIView *navMoreView;
    BOOL isLoadingMore;
    NSArray *moreBtnArr;
    NSArray *itemArr;
}

@end
