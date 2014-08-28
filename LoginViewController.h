//
//  LoginViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PreViewController.h"
#import "RegisterViewController.h"
#import "MBProgressHUD.h"
@interface LoginViewController : PreViewController<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
}
@end
