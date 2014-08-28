//
//  MyFavViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-3.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "XxyTableView.h"
#import "MBProgressHUD.h"

@interface MyFavViewController : PubViewController<UITableViewDataSource,MBProgressHUDDelegate,UITableViewDelegate>

{
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
