//
//  UpdatePasswordViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-11.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PreViewController.h"
#import "XxyHttpRequest.h"
#import "LRTextFeild.h"
#import "MBProgressHUD.h"
#import "SecretFactory.h"

@interface UpdatePasswordViewController : PreViewController<UITextFieldDelegate>
{
    LRTextFeild *oldpassword;
    LRTextFeild *newpassword;
    LRTextFeild *newpassworded;
    MBProgressHUD *HUD;
}

@end
