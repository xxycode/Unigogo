//
//  PersonSetViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-10.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PersonSetViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "QRadioButton.h"
#import "XxyHttprequest.h"
#import "SecretFactory.h"
#import "MKNetworkKit.h"



#define ORIGINAL_MAX_WIDTH 960.0f

@interface PersonSetViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *userImageView;
@end

@implementation PersonSetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"信息修改"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    infoSex = 1;
    if (!_userImageView) {
        CGFloat w = 80.0f; CGFloat h = w;
        CGFloat x = kScreenWidth/2 - w/2;
        CGFloat y = 20;
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        [_userImageView.layer setCornerRadius:(_userImageView.frame.size.height/2)];
        if (_userImage != nil) {
            [_userImageView setImage:_userImage];
        }else{
            [_userImageView setImage:[UIImage imageNamed:@"regdef.png"]];
        }
        isOrgImg = YES;
        [_userImageView.layer setMasksToBounds:YES];
        [_userImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_userImageView setClipsToBounds:YES];
        _userImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _userImageView.layer.shadowOffset = CGSizeMake(4, 4);
        _userImageView.layer.shadowOpacity = 0.5;
        _userImageView.layer.shadowRadius = 2.0;
        _userImageView.layer.borderColor = [[UIColor grayColor] CGColor];
        _userImageView.layer.borderWidth = 1.0f;
        _userImageView.userInteractionEnabled = YES;
        _userImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_userImageView addGestureRecognizer:portraitTap];
    }
//    backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:backgroundView];
//    [backgroundView setUserInteractionEnabled:YES];
//    [backgroundView setImage:[UIImage imageNamed:@"regbg.png"]];
    CGFloat navH = kVersion >= 7.0? 64:44;
    conView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight - navH)];
    [self.view addSubview:conView];
    UITapGestureRecognizer *tGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    [conView setUserInteractionEnabled:YES];
    [conView addGestureRecognizer:tGR];
    
    [conView addSubview:_userImageView];
    [self.view bringSubviewToFront:self.navView];
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    nickname = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, navH + 80, kScreenWidth - 40, 40 )];
    [nickname setPlaceholder:@"昵称"];
    [nickname setTag:246];
    [nickname setReturnKeyType:UIReturnKeyNext];
    [nickname setDelegate:self];
    [nickname setText:_nickName];
    [nickname setBackgroundColor:[UIColor whiteColor]];
    QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio1.frame = CGRectMake(20, navH + 130, 80, 40);
    [_radio1 setTitle:@"男" forState:UIControlStateNormal];
    [_radio1 setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [conView addSubview:_radio1];
    
    
    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio2.frame = CGRectMake(120, navH + 130, 80, 40);
    [_radio2 setTitle:@"女" forState:UIControlStateNormal];
    [_radio2 setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [conView addSubview:_radio2];
    if (_sex == 1) {
        [_radio1 setChecked:YES];
    }else{
        [_radio2 setChecked:YES];
    }
    [conView addSubview:nickname];
    UIButton *comfirButtom = [[UIButton alloc] initWithFrame:CGRectMake(20, navH + 180, 130, 40)];
    [comfirButtom setBackgroundColor:UIColorFromRGB(0x99cc00)];
    [comfirButtom.layer setCornerRadius:20.0f];
    [comfirButtom addTarget:self action:@selector(commitToRegister) forControlEvents:UIControlEventTouchUpInside];
    [comfirButtom setTitle:@"确认" forState:UIControlStateNormal];
    [comfirButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [conView addSubview:comfirButtom];
    UIButton *reInputButton = [[UIButton alloc] initWithFrame:CGRectMake(20+130+20, navH + 180, 130, 40)];
    [reInputButton setBackgroundColor:UIColorFromRGB(0x0ff4f3d)];
    [reInputButton.layer setCornerRadius:20.0f];
    [reInputButton setTitle:@"重填" forState:UIControlStateNormal];
    [reInputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [conView setContentSize:CGSizeMake(kScreenWidth, reInputButton.frame.origin.y + 70)];
    [reInputButton addTarget:self action:@selector(reIputAct) forControlEvents:UIControlEventTouchUpInside];
    [conView addSubview:reInputButton];
    UIButton *btn = (UIButton *)[self.navView viewWithTag:213];
    [btn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    UIButton *comButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 90, 7 + navBarH - 44, 80, 30)];
    [comButton setBackgroundColor:UIColorFromRGB(0x80b305)];
    [comButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [comButton.layer setCornerRadius:15.f];
    [comButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [comButton addTarget:self action:@selector(updatePassword) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:comButton];
}

- (void)reIputAct
{
    for (UIView *view in conView.subviews) {
        if ([view isKindOfClass:[LRTextFeild class]]) {
            LRTextFeild *f = (LRTextFeild *)view;
            [f setText:@""];
            [f resignFirstResponder];
        }
    }
    [conView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)hidenKeyboard
{
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:UITextField.class]) {
            [view resignFirstResponder];
        }
    }
}

- (void)updatePassword
{
    if (updateVC == nil) {
        updateVC = [[UpdatePasswordViewController alloc] init];
    }
    [self presentViewController:updateVC animated:YES completion:nil];
}

- (void)pop
{
    if (_finishBlock) {
        _finishBlock();
    }
}

- (void)commitToRegister
{
    [nickname resignFirstResponder];
    NSString *tmpStr = [nickname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tmpStr.length == 0) {
        [MBProgressHUD showMsg:self.view title:@"新的昵称不能为空" delay:1.5];
        return;
    }
    if (tmpStr.length > 10) {
        [MBProgressHUD showMsg:self.view title:@"昵称不能超过10个字" delay:1.5];
        return;
    }
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.labelText = @"正在加载";
    }
    [HUD show:YES];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/updateuserinfo",kHost];
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    if (![_nickName isEqualToString:nickname.text]) {
        [req setPostValue:nickname.text forKey:@"nickname"];
    }
    [req setPostValue:token forKey:@"token"];
    [req setPostValue:[NSString stringWithFormat:@"%d",infoSex] forKey:@"sex"];
    if (!isOrgImg) {
        NSData *data = UIImageJPEGRepresentation(_userImageView.image, 0.7);
        //[op addData:data forKey:@"pic" mimeType:@"image/jpeg" fileName:@"item.jpg"];
        [req addData:data withFileName:@"head.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    }
    [req setDelegate:self];
    [req startAsynchronous];
}

- (void)requestFinished:( ASIHTTPRequest *)request
{
    [HUD hide:YES];
    NSData *data = [request responseData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *message = [dic objectForKey:@"message"];
    [MBProgressHUD showMsg:self.view title:message delay:1.5];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [HUD hide:YES];
    [MBProgressHUD showMsg:self.view title:@"更新失败，请检查网络" delay:1.25];
}


- (void)failedLoadData
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - QRadioButtonDelegate

- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    NSString *tit = radio.titleLabel.text;
    if ([tit isEqualToString:@"男"]) {
        infoSex = 1;
    }else{
        infoSex = 0;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.userImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            imgorg = 1;
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 
                             }];
        }
        
    } else if (buttonIndex == 1) {
        imgorg = 2;
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        //portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        CGRect dFrame = [UIScreen mainScreen].bounds;
        imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, (dFrame.size.height - self.view.frame.size.width)/2, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        [imgEditorVC setImageOrg:imgorg];
        isOrgImg = NO;
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
    //return sourceImage;
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat navH = kVersion >= 7.0? 64:44;
    CGFloat delt = kVersion >= 7.0? 80:20;
    conView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight +116);//原始滑动距离增加键盘高度
    CGPoint pt = [textField convertPoint:CGPointMake(0, 0) toView:conView];//把当前的textField的坐标映射到scrollview上
    if(conView.contentOffset.y-pt.y + navH <=0)//判断最上面不要去滚动
        [conView setContentOffset:CGPointMake(0, pt.y - navH - delt) animated:YES];//
    
}

- (BOOL)textFieldShouldReturn:(UITextField*)theTextField
{
    NSInteger tag = [theTextField tag];
    if (tag < 248) {
        NSInteger nTag = tag + 1;
        LRTextFeild *textFd = (LRTextFeild *)[conView viewWithTag:nTag];
        [textFd becomeFirstResponder];
    }else{
        [theTextField resignFirstResponder];
        [conView setContentSize:CGSizeMake(kScreenWidth, theTextField.frame.origin.y + 80 + 60)];
        [conView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    return YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"社区个人设置"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"社区个人设置"];
}



@end
