//
//  LostItemCell.h
//  Unigogo
//
//  Created by xxy on 14-6-25.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "RTLabel.h"
#import "LostItem.h"
#import "TagLabel.h"
#import "JuBaoTableAlert.h"
#import "MBProgressHUD.h"
#import "XxyHttpRequest.h"

typedef void (^delBlock)(NSIndexPath *indexPath);
typedef void (^delPreBlock)(NSIndexPath *indexPath,NSString *lid);

@interface LostItemCell : UITableViewCell<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIImageView *fromImage;
    UILabel *fromName;
    UIImageView *itemImage;
    UILabel *contentLabel;
    UIView *bgView;
    UIImageView *imgV;
    UIScrollView *scView;
    MBProgressHUD *HUD;
    CGRect orgFrame;
    UILabel *timeLabel;
    UIButton *shareButton;
    UIButton *favButton;
    UIButton *jubaoButton;
    UIImageView *tagView;
    TagLabel *tagLabel;
    BOOL isPer;
    CGFloat startX;
    CGFloat cellX;
    CGFloat delt;
    BOOL canDelet;
    UIButton *deleteButton;
    JuBaoTableAlert *typeSelectView;
    NSArray *itemsTypes;
    NSInteger currJtype;
}

@property (nonatomic, strong) LostItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) delBlock delActionBlock;
@property (nonatomic, strong) delPreBlock delPreActionBlock;

+ (CGFloat)cellHeightForItem:(LostItem *)item isPer:(BOOL)per;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier personal:(BOOL)per deleteAble:(BOOL)deletable;

@end
