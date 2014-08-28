//
//  RegisterViewController.h
//  Unigogo
//
//  Created by xxy on 14-6-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PreViewController.h"
#import "VPImageCropperViewController.h"
#import "MBProgressHUD.h"
#import "LRTextFeild.h"
#import "ASIFormDataRequest.h"

typedef void(^disBlock)(void);

@interface RegisterViewController : PreViewController<MBProgressHUDDelegate,UIAlertViewDelegate,ASIHTTPRequestDelegate>
{
    VPImageCropperViewController *imgEditorVC;
    NSInteger imgorg;
    UIScrollView *conView;
    NSInteger infoSex;
    MBProgressHUD *HUD;
    LRTextFeild *username;
    LRTextFeild *nickname;
    LRTextFeild *password;
    LRTextFeild *passworded;
}

@property (nonatomic, strong) disBlock dB;


@end
