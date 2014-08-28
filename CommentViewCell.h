//
//  CommentViewCell.h
//  Unigogo
//
//  Created by xxy on 14-7-9.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentItem.h"
#import "UIImageView+WebCache.h"
#import "TQRichTextView.h"

typedef void (^ReplyBlock)(NSString *rid);
typedef void (^DelCommentBlock)(NSString *cid);

@interface CommentViewCell : UITableViewCell<TQRichTextViewDelegate>
{
    UIImageView *fromImage;
    UILabel *fromName;
    TQRichTextView *contentTextView;
    TQRichTextView *rcontentTextView;
    UIView *bgView;
    UILabel *timeLabel;
    UIView *repSlideView;
    UIButton *delBtn;
}

@property (nonatomic, strong) ReplyBlock repBlock;
@property (nonatomic, strong) CommentItem *item;
@property (nonatomic, strong) DelCommentBlock delBock;
+ (CGFloat)getHeighWithItem:(CommentItem *)item;


@end
