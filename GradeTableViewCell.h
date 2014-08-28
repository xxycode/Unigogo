//
//  GradeTableViewCell.h
//  Unigogo
//
//  Created by xxy on 14-7-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GradeItem.h"

@interface GradeTableViewCell : UITableViewCell
{
    UILabel *nameLabel;
    UILabel *ksTit;
    UILabel *ksScore;
    UILabel *psTit;
    UILabel *psScore;
    UILabel *qpTit;
    UILabel *qpScore;
    UILabel *creTit;
    UILabel *credit;
    UILabel *typeTit;
    UILabel *type;
    UIView *bgView;
    UIView *slideView;
}

@property(nonatomic, strong) GradeItem *item;

@end
