//
//  TopicDetailViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-8.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "TopicItem.h"
#import "XxyTableView.h"
#import "XxyHttpRequest.h"
#import "MBProgressHUD.h"
#import "CommentItem.h"
#import "ODRefreshControl.h"
#import "TopicView.h"

@interface TopicDetailViewController : PubViewController<UITableViewDataSource,UITableViewDelegate>
{
    ODRefreshControl *refreshControl;
    MBProgressHUD *HUD;
    XxyTableView *commentTableView;
    UIImageView *xinView;
    UIImageView *handView;
    UIButton *shareBtn;
    UIButton *commentBtn;
    UIButton *zanBtn;
    TopicView *headView;
}
@property (nonatomic, strong) TopicItem *item;
@property (nonatomic, strong) NSString *tid;

@end
