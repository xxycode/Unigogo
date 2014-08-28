//
//  MainButton.h
//  Unigogo
//
//  Created by Apple on 14-6-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainButton : UIButton

- (void)setBottomTitle:(NSString *)title;
- (void)startShake;
- (void)stopShake;
- (void)setTitleColor:(UIColor *)color;
@property (nonatomic, assign) NSInteger x_id;
@property (nonatomic, strong) NSString *btnTitle;
@property (nonatomic, strong) UIFont *font;

@end
