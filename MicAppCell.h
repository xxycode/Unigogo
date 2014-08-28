//
//  MicAppCell.h
//  Unigogo
//
//  Created by xxy on 14-8-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface MicAppCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titLabel;
@property (nonatomic, strong) NSDictionary *dic;

@end
