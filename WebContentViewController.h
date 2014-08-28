//
//  WebContentViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD.h"

@interface WebContentViewController : BaseViewController<UIWebViewDelegate>
{
    UIWebView *contentView;
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) NSString *url;

@end
