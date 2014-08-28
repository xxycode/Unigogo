//
//  NewinfoViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-1.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PreViewController.h"
#import "QCheckBox.h"
#import "MLTableAlert.h"

@interface NewinfoViewController : PreViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate,UIActionSheetDelegate>
{
    UITextView *contentTextView;
    UIView *contentView;
    UIView *toolView;
    QCheckBox *nmCheck;
    UIImageView *imageView;
    NSInteger currType;
    MLTableAlert *typeSelectView;
    NSArray *itemsTypes;
}
@end
