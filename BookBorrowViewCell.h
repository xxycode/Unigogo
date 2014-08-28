//
//  BookBorrowViewCell.h
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookItemBor.h"

typedef void (^SetNotfication)(NSString *backTime,NSString *bookName);

@interface BookBorrowViewCell : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *backTimeLabel;
    UIButton *noticeButton;
}

@property (nonatomic, strong) BookItemBor *item;
@property (nonatomic, strong) SetNotfication noticationBlock;

@end
