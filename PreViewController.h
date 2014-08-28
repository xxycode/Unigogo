//
//  PreViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BaseViewController.h"
#import "PubNavView.h"

typedef void(^DismissBlock)(void);

@interface PreViewController : BaseViewController
{
    UILabel *titLabel;
}

- (void)setTitle:(NSString *)title;

@property (nonatomic, strong) PubNavView *navView;
@property (nonatomic, strong) DismissBlock disBlock;

@end
