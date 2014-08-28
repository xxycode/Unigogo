//
//  BorrowedViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-13.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "DXAlertView.h"
#import "MBProgressHUD.h"
#import "XxyHttpRequest.h"
#import "KxMenu.h"

@interface BorrowedViewController : PubViewController<UITableViewDataSource,UITableViewDelegate>
{
    DXAlertView *alert;
    MBProgressHUD *HUD;
    NSArray *listArr;
    UITableView *bookList;
}

@property(nonatomic, strong) NSString *borrowerId;
@property(nonatomic, strong) NSString *password;

@end
