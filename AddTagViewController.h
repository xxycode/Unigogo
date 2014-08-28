//
//  AddTagViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-7.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PreViewController.h"

typedef void (^addTagBlock)(NSString *tags);

@interface AddTagViewController : PreViewController<UITextViewDelegate>
{
    UITextView *tagView;
    UILabel *hitLabel;
}

@property (nonatomic, strong) addTagBlock addBlock;
@property (nonatomic, strong) NSString *tags;

@end
