//
//  TopExButton.h
//  Unigogo
//
//  Created by xxy on 14-7-8.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopExButton : UIButton
{
    UILabel *titLabel;
}
- (void)setBottomTitle:(NSString *)title;
- (NSString *)getBottomTitle;

@end
