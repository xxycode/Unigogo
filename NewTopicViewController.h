//
//  NewTopicViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-5.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PreViewController.h"
#import "FaceContentView.h"
#import "MBProgressHUD.h"


@interface NewTopicViewController : PreViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate,UIActionSheetDelegate>
{
    UITextView *contentTextView;
    UIView *contentView;
    UIView *toolView;
    UIImageView *imageView;
    FaceContentView *faceKeyBoard;
    int keyBoardType;
    NSString *tag;
}

@property (nonatomic, strong) NSString *hid;


@end
