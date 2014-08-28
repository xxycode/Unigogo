//
//  LRTextFeild.m
//  Unigogo
//
//  Created by xxy on 14-6-30.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LRTextFeild.h"

@implementation LRTextFeild

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat pt = kVersion >= 7.0 ? 10:7;
        [self setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self setValue:[NSNumber numberWithInt:pt] forKey:@"paddingTop"];
        [self setValue:[NSNumber numberWithInt:29] forKey:@"paddingLeft"];
        [self setValue:[NSNumber numberWithInt:5] forKey:@"paddingBottom"];
        [self setValue:[NSNumber numberWithInt:5] forKey:@"paddingRight"];
        [self setTextColor:UIColorFromRGB(0x797979)];
        [self setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self setFont:[UIFont systemFontOfSize:22.0f]];
        [self.layer setCornerRadius:20.0f];
        [self setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
