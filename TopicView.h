//
//  TopicView.h
//  Unigogo
//
//  Created by xxy on 14-7-9.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicItem.h"
#import "UIImageView+WebCache.h"
#import "TopicItem.h"
#import "TQRichTextView.h"
#import "TagLabel.h"
#import "TopExButton.h"
#import "DAProgressOverlayView.h"
#import "MBProgressHUD.h"

@interface TopicView : UIView<UIScrollViewDelegate>
{
    UIImageView *fromImage;
    UIView *bgView;
    UILabel *fromName;
    UIImageView *itemImage;
    TQRichTextView *contentTextView;
    UIImageView *imgV;
    CGRect orgFrame;
    UILabel *timeLabel;
    UIImageView *tagView;
    UIScrollView *scView;
    UILabel *tagLabel;
}

@property (nonatomic, strong) TopicItem *item;

@end
