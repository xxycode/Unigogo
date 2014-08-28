//
//  PubViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BaseViewController.h"
#import "PubNavView.h"

@interface PubViewController : BaseViewController
{
    UILabel *titLabel;
}

- (void)setTitle:(NSString *)title;

@property (nonatomic, strong) PubNavView *navView;

@end
