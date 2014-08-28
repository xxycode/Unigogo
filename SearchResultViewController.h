//
//  SearchResultViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "MBProgressHUD.h"
#import "XxyHttprequest.h"
#import "XxyTableView.h"

@interface SearchResultViewController : PubViewController<UITableViewDelegate,UITableViewDataSource>
{
    MBProgressHUD *HUD;
    XxyTableView *resList;
    NSArray *resArr;
    NSInteger curr;
    NSInteger pages;
}

@property (nonatomic, strong) NSString *keyWord;
@property (nonatomic, strong) NSString *mtype;
@property (nonatomic, strong) NSString *ktype;

@end
