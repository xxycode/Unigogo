//
//  MicroAppListViewController.h
//  Unigogo
//
//  Created by xxy on 14-8-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "MBProgressHUD.h"

@interface MicroAppListViewController : PubViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *dataTableView;
    NSArray *dataArr;
    MBProgressHUD *HUD;
}

@end
