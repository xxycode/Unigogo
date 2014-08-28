//
//  MyFavComViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-10.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "XxyTableView.h"
#import "MBProgressHUD.h"
#import "TopicItem.h"

typedef void (^PopBlock)(void);

@interface MyFavComViewController : PubViewController<UITableViewDataSource,MBProgressHUDDelegate,UITableViewDelegate>

{
    MBProgressHUD *HUD;
    XxyTableView *topicItemTableView;
    NSMutableArray *topicData;
    NSInteger currPage;
    UIView *navMoreView;
    BOOL isLoadingMore;
    NSArray *moreBtnArr;
}

@property (nonatomic, strong) PopBlock popBlock;


@end
