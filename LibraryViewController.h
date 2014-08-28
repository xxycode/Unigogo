//
//  LibraryViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BaseViewController.h"
#import "LRTextFeild.h"
#import "MainButton.h"
#import "BorrowedViewController.h"
#import "OpenTimeViewController.h"
#import "LocationViewController.h"
#import "SearchResultViewController.h"

@interface LibraryViewController : BaseViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
{
    LRTextFeild *searchField;
    UIButton *backBtn;
    UIButton *editBtn;
    NSString *ktype;
    NSString *mtype;
    BorrowedViewController *borrVC;
    OpenTimeViewController *openVC;
    LocationViewController *locaVC;
    UIView *sView;
    UIWindow *selectView;
    UIButton *selectCancelButton;
    UIButton *selectOkButton;
    NSArray *kArr;
    NSArray *mArr;
    NSInteger currK;
    NSInteger currM;
    UITableView *selectTable;
    //SearchResultViewController *searchResVC;
}

@end
