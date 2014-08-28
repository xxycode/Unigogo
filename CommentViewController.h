//
//  CommentViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-8.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PreViewController.h"
#import "FaceContentView.h"
#import "XxyHttpRequest.h"
#import "MBProgressHUD.h"

@interface CommentViewController : PreViewController<UITextViewDelegate>
{
    UITextView *commentTextView;
    UILabel *hitLabel;
    UIView *toolView;
    NSInteger keyBoardType;
    FaceContentView *faceKeyBoard;
}

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *rid;

@end
