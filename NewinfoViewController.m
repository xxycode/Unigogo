//
//  NewinfoViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-1.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "NewinfoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "MKNetworkKit.h"
#import "SecretFactory.h"
#import "AppDelegate.h"
#import "WTStatusBar.h"
#import "UIImage+Resize.h"


@interface NewinfoViewController ()

@end

@implementation NewinfoViewController

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
    [self setTitle:@"发布信息"];
    [self initViews];
    [contentView addSubview:contentTextView];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    currType = 0;
    itemsTypes = @[@"请选择",@"电子数码",@"书本",@"文体用品",@"证件及卡",@"服装及包",@"钥匙",@"其他"];
    [self registerForKeyboardNotifications];
    backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:backgroundView];
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - navBarH)];
    [contentView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.6]];
    [self.view addSubview:contentView];
    [backgroundView setUserInteractionEnabled:YES];
    [backgroundView setImage:[UIImage imageNamed:@"additem.png"]];
    [self.view bringSubviewToFront:self.navView];
    [self.navView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.5]];
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 40 - (64 - navBarH) - 40 - 85)];
    toolView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height - 40 - (64 - navBarH), kScreenWidth, 40)];
    [toolView setBackgroundColor:UIColorFromRGB(0x24292c)];
    [contentView addSubview:toolView];
    [contentTextView setBackgroundColor:[UIColor clearColor]];
    [contentTextView setFont:[UIFont systemFontOfSize:16.0f]];
    UIButton *addc = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [addc setBackgroundImage:[UIImage imageNamed:@"addphotoa.png"] forState:UIControlStateNormal];
    [addc addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    UIButton *typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(55, 5, 30, 30)];
    [typeBtn setBackgroundImage:[UIImage imageNamed:@"itemtypes.png"] forState:UIControlStateNormal];
    [typeBtn setTitle:@"类别" forState:UIControlStateNormal];
    [typeBtn setTitleEdgeInsets:(UIEdgeInsets){0,30,0,0}];
    [typeBtn addTarget:self action:@selector(selectType) forControlEvents:UIControlEventTouchUpInside];
    nmCheck = [[QCheckBox alloc] initWithDelegate:self];
    nmCheck.frame = CGRectMake(160, 0, 120, 40);
    [nmCheck setTitle:@"匿名发布" forState:UIControlStateNormal];
    [nmCheck setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [nmCheck.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
    [nmCheck setChecked:NO];
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, contentTextView.frame.size.height + 5, 70, 70)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [contentView addSubview:imageView];
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 50, 30)];
    [sendButton addTarget:self action:@selector(sendAct) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:UIColorFromRGB(0x99cc00) forState:UIControlStateNormal];
    [toolView addSubview:sendButton];
    [toolView addSubview:typeBtn];
    [toolView addSubview:addc];
    [toolView addSubview:nmCheck];
}



- (void)selectType
{
    if (typeSelectView == nil) {
        typeSelectView = [MLTableAlert tableAlertWithTitle:@"请选择一个类别" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                      {
                          return itemsTypes.count;
                      }
                    andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                      {
                          static NSString *CellIdentifier = @"CellIdentifier";
                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                          if (cell == nil)
                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                          
                          if (currType == indexPath.row) {
                              cell.accessoryType = UITableViewCellAccessoryCheckmark;
                          }else{
                              cell.accessoryType = UITableViewCellAccessoryNone;
                          }
                          cell.textLabel.text = [itemsTypes objectAtIndex:indexPath.row];
                          
                          return cell;
                      }];

    }
    [typeSelectView setAlpha:1.0f];
	// Setting custom alert height
	typeSelectView.height = 350;
	
	// configure actions to perform
	[typeSelectView configureSelectionBlock:^(NSIndexPath *selectedIndex){
		currType = selectedIndex.row;
        [contentTextView becomeFirstResponder];
	} andCompletionBlock:^{
		[contentTextView becomeFirstResponder];
	}];
	
	// show the alert
	[typeSelectView show];
}

- (void)sendAct
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *seckey = [SecretFactory getCurrentSecretKey];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    if (currType == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还未选择类型，请在点击添加图片的按钮旁的按钮添加" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSNumber *type = [NSNumber numberWithInteger:currType];
    NSString *content = contentTextView.text;
    NSString *tmpContent = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tmpContent.length == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [WTStatusBar setStatusText:@"正在发送" animated:YES];
    [WTStatusBar setProgressBarColor:UIColorFromRGB(0x99cc00)];
    if (nmCheck.checked) {
        [postDic setObject:@"1" forKey:@"isn"];
    }
    [postDic setObject:token forKey:@"access_token"];
    [postDic setObject:seckey forKey:@"seckey"];
    [postDic setObject:type forKey:@"type"];
    [postDic setObject:content forKey:@"content"];
    NSString *url = [NSString stringWithFormat:@"%@/lostandfound/index.php/index/addItem",kHost];
    MKNetworkEngine *eng = [[MKNetworkEngine alloc] init];
    MKNetworkOperation *op = [eng operationWithURLString:url params:postDic httpMethod:@"POST"];
    if (imageView.image != nil) {
        UIImage *resizedImage = [imageView.image imageByScalingAndCroppingForSize:CGSizeMake(imageView.image.size.width/3, imageView.image.size.height/3)];
        NSData *data = UIImageJPEGRepresentation(resizedImage, 0.7);
        [op addData:data forKey:@"pic" mimeType:@"image/jpeg" fileName:@"item.jpg"];
    }
    __block NewinfoViewController *nV = self;
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

- (void) dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)hidenWindow
//{
//    [sendingWindow hide:@"发送成功"];
//}


- (void)addPhoto
{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasHidde:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGRect frame = contentView.frame;
    frame.size.height = kScreenHeight - navBarH - keyboardSize.height;
    [UIView animateWithDuration:0.35 animations:^{
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

- (void)textViewDidChange:(UITextView *)textView
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIActionSheet代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
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
        
    } else if (buttonIndex == 1) {
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



#pragma mark - 图像选择器代理
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [contentTextView becomeFirstResponder];
    [MobClick beginLogPageView:@"发布失物"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"发布失物"];
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
