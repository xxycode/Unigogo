//
//  PersonSetViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-10.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import "VPImageCropperViewController.h"
#import "MBProgressHUD.h"
#import "LRTextFeild.h"
#import "WTStatusBar.h"
#import "ASIFormDataRequest.h"
#import "UpdatePasswordViewController.h"

typedef void (^FinishUpdateBlock)(void);

@interface PersonSetViewController : PubViewController<UIAlertViewDelegate,ASIHTTPRequestDelegate>
{
    VPImageCropperViewController *imgEditorVC;
    NSInteger imgorg;
    UIScrollView *conView;
    NSInteger infoSex;
    MBProgressHUD *HUD;
    LRTextFeild *nickname;
    UpdatePasswordViewController *updateVC;
    BOOL isOrgImg;
}

@property (nonatomic, strong) UIImage *userImage;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, assign) NSInteger sex;

@property (nonatomic, strong) FinishUpdateBlock finishBlock;

@end
