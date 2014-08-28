//
//  LostandfoundViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "XxyTableView.h"
#import "MBProgressHUD.h"
#import "ODRefreshControl.h"

@interface LostandfoundViewController : PubViewController<UITableViewDataSource,MBProgressHUDDelegate,UITableViewDelegate>

{
    ODRefreshControl *refreshControl;
    MBProgressHUD *HUD;
    XxyTableView *lostItemTableView;
    NSMutableArray *lostData;
    NSString *topId;
    NSInteger currCellIndex;
    NSInteger currPage;
    UIView *navMoreView;
    BOOL isLoadingMore;
    NSArray *moreBtnArr;
}


@end
