//
//  BookResViewCell.h
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookItemRes.h"

@interface BookResViewCell : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *authorLabel;
    UILabel *publisherLabel;
    UILabel *isbnLabel;
    UILabel *pubtimeLabel;
    UILabel *sidLabel;
    UILabel *currStatusLabel;
}

@property (nonatomic, retain) BookItemRes *item;

@end
