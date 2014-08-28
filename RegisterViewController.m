//
//  RegisterViewController.m
//  Unigogo
//
//  Created by xxy on 14-6-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "RegisterViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "QRadioButton.h"
#import "XxyHttprequest.h"
#import "SecretFactory.h"
#import "MKNetworkKit.h"


#define ORIGINAL_MAX_WIDTH 960.0f

@interface RegisterViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *userImageView;
@end

@implementation RegisterViewController

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
    [self setTitle:@"用户注册"];
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
        [_userImageView setImage:[UIImage imageNamed:@"regdef.png"]];
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
    //backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    //[self.view addSubview:backgroundView];
    //[backgroundView setUserInteractionEnabled:YES];
    //[backgroundView setImage:[UIImage imageNamed:@"regbg.png"]];
    CGFloat navH = kVersion >= 7.0? 64:44;
    conView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, navH, kScreenWidth, kScreenHeight - navH)];
    [self.view addSubview:conView];
    UITapGestureRecognizer *tGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    [conView setUserInteractionEnabled:YES];
    [conView addGestureRecognizer:tGR];
    
    [conView addSubview:_userImageView];
    [self.view bringSubviewToFront:self.navView];
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    username = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, navH + 80, kScreenWidth - 40, 40)];
    [username setPlaceholder:@"用户名(字母开头6~18位)"];
    [username setTag:245];
    [username setReturnKeyType:UIReturnKeyNext];
    [username setDelegate:self];
    nickname = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, navH + 140, kScreenWidth - 40, 40 )];
    [nickname setPlaceholder:@"昵称"];
    [nickname setTag:246];
    [nickname setReturnKeyType:UIReturnKeyNext];
    [nickname setDelegate:self];
    password = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, navH + 140 + 60 + 40, kScreenWidth - 40, 40 )];
    [password setReturnKeyType:UIReturnKeyNext];
    QRadioButton *_radio1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio1.frame = CGRectMake(20, navH + 140 + 40 + 10, 80, 40);
    [_radio1 setTitle:@"男" forState:UIControlStateNormal];
    [_radio1 setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [_radio1.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [conView addSubview:_radio1];
    [_radio1 setChecked:YES];
    
    QRadioButton *_radio2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
    _radio2.frame = CGRectMake(120, navH + 140 + 40 + 10, 80, 40);
    [_radio2 setTitle:@"女" forState:UIControlStateNormal];
    [_radio2 setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [_radio2.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [conView addSubview:_radio2];

    [password setSecureTextEntry:YES];
    [password setDelegate:self];
    [password setTag:247];
    [password setPlaceholder:@"密码"];
    passworded = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, navH + 140 + 60 + 40 + 60, kScreenWidth - 40, 40)];
    [passworded setSecureTextEntry:YES];
    [passworded setDelegate:self];
    [passworded setTag:248];
    [passworded setReturnKeyType:UIReturnKeyDone];
    [passworded setPlaceholder:@"确认密码"];
    [conView addSubview:username];
    [conView addSubview:nickname];
    [conView addSubview:password];
    [conView addSubview:passworded];
    UIButton *comfirButtom = [[UIButton alloc] initWithFrame:CGRectMake(20, navH + 140 + 60 + 40 + 60 + 20 + 40, 130, 40)];
    [comfirButtom setBackgroundColor:UIColorFromRGB(0x99cc00)];
    [comfirButtom.layer setCornerRadius:20.0f];
    [comfirButtom addTarget:self action:@selector(commitToRegister) forControlEvents:UIControlEventTouchUpInside];
    [comfirButtom setTitle:@"确认" forState:UIControlStateNormal];
    [comfirButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [conView addSubview:comfirButtom];
    UIButton *reInputButton = [[UIButton alloc] initWithFrame:CGRectMake(20+130+20, navH + 140 + 60 + 20 + 40 + 60 + 40, 130, 40)];
    [reInputButton setBackgroundColor:UIColorFromRGB(0x0ff4f3d)];
    [reInputButton.layer setCornerRadius:20.0f];
    [reInputButton setTitle:@"重填" forState:UIControlStateNormal];
    [reInputButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [conView setContentSize:CGSizeMake(kScreenWidth, reInputButton.frame.origin.y + 70)];
    [reInputButton addTarget:self action:@selector(reIputAct) forControlEvents:UIControlEventTouchUpInside];
    [conView addSubview:reInputButton];
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

- (void)commitToRegister
{
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    [HUD show:YES];
    HUD.labelText = @"正在加载";
    NSString *seckey = [SecretFactory getCurrentSecretKey];
    NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/register",kHost];
    ASIFormDataRequest *req = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [req setPostValue:nickname.text forKey:@"nickname"];
    [req setPostValue:username.text forKey:@"username"];
    [req setPostValue:password.text forKey:@"password"];
    [req setPostValue:passworded.text forKey:@"passworded"];
    [req setPostValue:seckey  forKey:@"seckey"];
    [req setPostValue:[NSString stringWithFormat:@"%d",infoSex] forKey:@"sex"];
    NSData *data = UIImageJPEGRepresentation(_userImageView.image, 0.7);
    [req addData:data withFileName:@"head.jpg" andContentType:@"image/jpeg" forKey:@"pic"];
    [req setDelegate:self];
    [req startAsynchronous];
}

- ( void )requestFinished:( ASIHTTPRequest *)request
{
    [HUD hide:YES];
    NSData *data = [request responseData];
    NSString *str = [request responseString];
    if ([str isEqualToString:@"error"]) {
        [MBProgressHUD showMsg:self.view title:@"注册失败未知错误" delay:1.5];
        return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [dic objectForKey:@"status"];
    NSString *message = [dic objectForKey:@"message"];
    if ([status isEqualToString:@"0"]) {
        [MBProgressHUD showMsg:self.view title:message delay:1.5];
    }else{
        [MBProgressHUD showMsg:self.view title:@"注册成功" delay:1.5];
        [self performSelector:@selector(dismissAct) withObject:nil afterDelay:1.6];
    }
}

//- (void)finishLoadData:(NSData *)data
//{
//    [HUD hide:YES];
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    if ([str isEqualToString:@"error"]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册失败，未知错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//        return;
//    }
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSString *status = [dic objectForKey:@"status"];
//    NSString *message = [dic objectForKey:@"message"];
//    if ([status isEqualToString:@"0"]) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//    }else{
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//        [alertView show];
//
//        [[NSUserDefaults standardUserDefaults] setObject:message forKey:@"access_token"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//}

- (void)dismissAct
{
    _dB();
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
        infoSex = 2;
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
    [MobClick beginLogPageView:@"注册"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"注册"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
