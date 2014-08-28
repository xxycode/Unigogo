//
//  NewTopicViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-5.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "NewTopicViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MKNetworkKit.h"
#import "SecretFactory.h"
#import "UIImage+Resize.h"
#import "WTStatusBar.h"
#import "AddTagViewController.h"

@interface NewTopicViewController ()

@end

@implementation NewTopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _hid = @"0";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"发布新帖"];
    [self initViews];
    [contentView addSubview:contentTextView];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    keyBoardType = 1;
    [self registerForKeyboardNotifications];
    backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundView];
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64)];
    [contentView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.6]];
    [self.view addSubview:contentView];
    [backgroundView setUserInteractionEnabled:YES];
    [backgroundView setImage:[UIImage imageNamed:@"additem.png"]];
    [self.view bringSubviewToFront:self.navView];
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40 - (64 - navBarH) - 40 - 85)];
    toolView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height - 40, kScreenWidth, 40)];
    [toolView setBackgroundColor:UIColorFromRGB(0x24292c)];
    [contentView addSubview:toolView];
    [contentTextView setBackgroundColor:[UIColor clearColor]];
    [contentTextView setFont:[UIFont systemFontOfSize:16.0f]];
    UIButton *addc = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
    [addc setBackgroundImage:[UIImage imageNamed:@"addphotoc.png"] forState:UIControlStateNormal];
    [addc addTarget:self action:@selector(addPhotoc) forControlEvents:UIControlEventTouchUpInside];
    UIButton *adda = [[UIButton alloc] initWithFrame:CGRectMake(80, 5, 30, 30)];
    [adda setBackgroundImage:[UIImage imageNamed:@"addphotoa.png"] forState:UIControlStateNormal];
    [adda addTarget:self action:@selector(addPhotoa) forControlEvents:UIControlEventTouchUpInside];
    UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(140, 5, 30, 30)];
    [faceBtn setBackgroundImage:[UIImage imageNamed:@"face.png"] forState:UIControlStateNormal];
    [faceBtn setTag:213];
    [faceBtn addTarget:self action:@selector(showFaceKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *tagBtn = [[UIButton alloc] initWithFrame:CGRectMake(200, 5, 30, 30)];
    [tagBtn setBackgroundImage:[UIImage imageNamed:@"tagc.png"] forState:UIControlStateNormal];
    [tagBtn addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchUpInside];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, contentTextView.frame.size.height + 5, 70, 70)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [contentView addSubview:imageView];
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 30, 30)];
    [sendButton addTarget:self action:@selector(sendAct:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"sendBtn.png"] forState:UIControlStateNormal];
    //[sendButton setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [toolView addSubview:sendButton];
    [toolView addSubview:faceBtn];
    [toolView addSubview:addc];
    [toolView addSubview:adda];
    [toolView addSubview:tagBtn];
    [contentTextView becomeFirstResponder];
}

- (void) addPhotoa
{
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

- (void) addPhotoc
{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        [imageView setImage:portraitImg];
        UIButton *delBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [delBtn setCenter:CGPointMake(65, 5)];
        [delBtn addTarget:self action:@selector(delAct:) forControlEvents:UIControlEventTouchUpInside];
        [delBtn setImage:[UIImage imageNamed:@"dellpic.png"] forState:UIControlStateNormal];
        [imageView setUserInteractionEnabled:YES];
        [imageView addSubview:delBtn];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

- (void)delAct:(UIButton *)btn
{
    [imageView setImage:nil];
    [btn removeFromSuperview];
}

- (void)sendAct:(UIButton *)sender
{
    [sender setEnabled:NO];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSString *content = contentTextView.text;
    NSString *tmpContent = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tmpContent.length == 0) {
        [MBProgressHUD showMsg:self.view.window title:@"内容不能位空" delay:2.0];
        return;
    }
    [WTStatusBar setStatusText:@"正在发送" animated:YES];
    [WTStatusBar setProgressBarColor:UIColorFromRGB(0x99cc00)];
    [postDic setObject:token forKey:@"access_token"];
    [postDic setObject:content forKey:@"content"];
    if (tag != nil && ![tag isEqualToString:@""]) {
        [postDic setObject:tag forKey:@"tag"];
    }
    if (_hid != nil && ![_hid isEqualToString:@"0"]) {
        [postDic setObject:_hid forKey:@"hid"];
    }
    NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/addtopic",kHost];
    MKNetworkEngine *eng = [[MKNetworkEngine alloc] init];
    MKNetworkOperation *op = [eng operationWithURLString:url params:postDic httpMethod:@"POST"];
    if (imageView.image != nil) {
        if (imageView.image.size.width >= 3000 || imageView.image.size.height >= 3000) {
            UIImage *resizedImage = [imageView.image imageByScalingAndCroppingForSize:CGSizeMake(imageView.image.size.width/3, imageView.image.size.height/3)];
            NSData *data = UIImageJPEGRepresentation(resizedImage, 0.7);
            [op addData:data forKey:@"pic" mimeType:@"image/jpeg" fileName:@"item.jpg"];
        }else if (imageView.image.size.width >= 2000|| imageView.image.size.height >= 2000){
            UIImage *resizedImage = [imageView.image imageByScalingAndCroppingForSize:CGSizeMake(imageView.image.size.width/2, imageView.image.size.height/2)];
            NSData *data = UIImageJPEGRepresentation(resizedImage, 0.7);
            [op addData:data forKey:@"pic" mimeType:@"image/jpeg" fileName:@"item.jpg"];
        }else{
            NSData *data = UIImageJPEGRepresentation(imageView.image, 0.7);
            [op addData:data forKey:@"pic" mimeType:@"image/jpeg" fileName:@"item.jpg"];
        }
    }
    __block NewTopicViewController *nV = self;
    [op onUploadProgressChanged:^(double process){
        if (process < 1) {
            [WTStatusBar setProgress:process animated:YES];
        }else{
            [WTStatusBar setStatusText:@"发送成功" timeout:1.f animated:YES];
            [nV dismissSelf];
        }
        
    }];
    [eng enqueueOperation:op];
    
}

- (void)addTag
{
    AddTagViewController *addTagViewController = [[AddTagViewController alloc] init];
    [addTagViewController setAddBlock:^(NSString *tags){
        [self finishAddTag:tags];
    }];
    [addTagViewController setTags:tag];
    [self presentViewController:addTagViewController animated:YES completion:nil];
}

- (void)finishAddTag:(NSString *)str
{
    [contentTextView becomeFirstResponder];
    NSString *tmpStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tmpStr.length > 0) {
        tag = [NSString stringWithString:tmpStr];
    }
}

- (void) dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidde:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    keyBoardType = 1;
    UIButton *button = (UIButton *)[toolView viewWithTag:213];
    [button setBackgroundImage:[UIImage imageNamed:@"face.png"] forState:UIControlStateNormal];
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGRect frame = contentView.frame;
    frame.size.height = kScreenHeight - navBarH - keyboardSize.height;
    [UIView animateWithDuration:0.35 animations:^{
        if (faceKeyBoard != nil) {
            [faceKeyBoard setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 165)];
        }
        [contentView setFrame:frame];
        [contentTextView setFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height - 40 - (64 - navBarH) - 85)];
        [imageView setFrame:CGRectMake(5, contentTextView.frame.size.height + 5, 70, 70)];
        [toolView setFrame:CGRectMake(0, contentView.frame.size.height - 40 - (64 - navBarH), kScreenWidth, 40)];
    }];
    //NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void)keyboardWasHidde:(NSNotification *) notif
{
    CGRect frame = contentView.frame;
    frame.size.height = kScreenHeight - navBarH;
    [UIView animateWithDuration:0.35 animations:^{
        [contentView setFrame:frame];
        [contentTextView setFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height - 40 - (64 - navBarH) - 85)];
        [imageView setFrame:CGRectMake(5, contentTextView.frame.size.height + 5, 70, 70)];
        [toolView setFrame:CGRectMake(0, contentView.frame.size.height - 40 - (64 - navBarH), kScreenWidth, 40)];
    }];

}

- (void)showFaceKeyBoard:(UIButton *)button
{
    if (keyBoardType == 1) {
        [button setBackgroundImage:[UIImage imageNamed:@"ftkeyboard.png"] forState:UIControlStateNormal];
        [contentTextView resignFirstResponder];
        if (faceKeyBoard == nil) {
            faceKeyBoard = [[FaceContentView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 165)];
            [faceKeyBoard setBackgroundColor:[UIColor whiteColor]];
            NewTopicViewController *newTC = self;
            [faceKeyBoard.faceView setClickBlock:^(NSString *faceStr){
                [newTC addFaceStr:faceStr];
            }];
            [backgroundView addSubview:faceKeyBoard];
            [backgroundView bringSubviewToFront:faceKeyBoard];
        }
        CGRect frame = contentView.frame;
        frame.size.height = kScreenHeight - 64 - faceKeyBoard.frame.size.height;
        [UIView animateWithDuration:0.35 animations:^{
            [faceKeyBoard setFrame:CGRectMake(0, kScreenHeight - 165 - (64 - navBarH), kScreenWidth, 165)];
            [contentView setFrame:frame];
            [contentTextView setFrame:CGRectMake(0, 0, kScreenWidth, frame.size.height - 40 - (64 - navBarH) - 85)];
            [imageView setFrame:CGRectMake(5, contentTextView.frame.size.height + 5, 70, 70)];
            [toolView setFrame:CGRectMake(0, contentView.frame.size.height - 40, kScreenWidth, 40)];
        }];

        keyBoardType = 2;
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"face.png"] forState:UIControlStateNormal];
        [contentTextView becomeFirstResponder];
        keyBoardType = 1;
    }
}

- (void)addFaceStr:(NSString *)str
{
    if (![str isEqual:@"-1"]) {
        NSMutableString *orgStr = [NSMutableString stringWithString:contentTextView.text];
        [orgStr appendString:str];
        [contentTextView setText:orgStr];
    }else{
        NSMutableString *orgStr = [NSMutableString stringWithString:contentTextView.text];
        NSInteger len = orgStr.length;
        if (len <= 3) {
            if (len == 0) {
                return;
            }
            NSString *resStr = [orgStr substringToIndex:len - 1];
            [contentTextView setText:resStr];
            return;
        }
        NSString *lastSubStr = [orgStr substringFromIndex:len - 4];
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[\\d{2}]" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result = [regex firstMatchInString:lastSubStr options:0 range:NSMakeRange(0, [lastSubStr length])];
        if (result) {
            NSString *resStr = [orgStr substringToIndex:len - 4];
            [contentTextView setText:resStr];
        }else{
            NSString *resStr = [orgStr substringToIndex:len - 1];
            [contentTextView setText:resStr];
        }
       
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"社区发布"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"社区发布"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
