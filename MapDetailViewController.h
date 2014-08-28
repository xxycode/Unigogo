//
//  MapDetailViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"

@interface MapDetailViewController : PubViewController<UIWebViewDelegate>
{
    UIWebView *contentView;
    UIActivityIndicatorView *HUD;
}
@property (nonatomic, strong) NSString *lid;
@property (nonatomic, strong) NSString *lName;

@end
