//
//  CommentViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-8.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "CommentViewController.h"
#import "WTStatusBar.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

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
    [self setTitle:@"发表评论"];
    // Do any additional setup after loading the view.
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    keyBoardType = 1;
    [self registerForKeyboardNotifications];
    commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64)];
    [commentTextView setFont:[UIFont systemFontOfSize:16.0f]];
    [commentTextView setDelegate:self];
    [self.view addSubview:commentTextView];
    if (kVersion >= 7.0) {
        hitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 280, 20)];
    }else{
        hitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 280, 20)];
    }
    [hitLabel setBackgroundColor:[UIColor clearColor]];
    [hitLabel setTextColor:UIColorFromRGB(0x999999)];
    if (commentTextView.text.length == 0) {
        [hitLabel setText:@"来说点什么吧..."];
    }
    [commentTextView addSubview:hitLabel];
    [commentTextView becomeFirstResponder];
    UIButton *comButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 7 + navBarH - 44, 50, 30)];
    [comButton setBackgroundColor:UIColorFromRGB(0x80b305)];
    [comButton setTitle:@"发送" forState:UIControlStateNormal];
    [comButton.layer setCornerRadius:15.f];
    [comButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [comButton addTarget:self action:@selector(finishAct) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:comButton];
    UIButton *faceBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 30, 30)];
    [faceBtn setBackgroundImage:[UIImage imageNamed:@"face.png"] forState:UIControlStateNormal];
    [faceBtn setTag:213];
    [faceBtn addTarget:self action:@selector(showFaceKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 40)];
    [toolView setBackgroundColor:UIColorFromRGB(0x24292c)];
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 30, 30)];
    [sendButton addTarget:self action:@selector(finishAct) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"sendBtn.png"] forState:UIControlStateNormal];
    [commentTextView addSubview:toolView];
    [toolView addSubview:faceBtn];
    [toolView addSubview:sendButton];

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
    [UIView animateWithDuration:0.35 animations:^{
        if (faceKeyBoard != nil) {
            [faceKeyBoard setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 165)];
        }
        [toolView setFrame:CGRectMake(0, commentTextView.frame.size.height - keyboardSize.height - 40, kScreenWidth, 40)];
    }];
    //NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void)keyboardWasHidde:(NSNotification *) notif
{
    [UIView animateWithDuration:0.35 animations:^{
        [toolView setFrame:CGRectMake(0, commentTextView.frame.size.height - 40, kScreenWidth, 40)];
    }];
    
}


- (void)finishAct
{
    NSString *commentContent = commentTextView.text;
    NSString *tmpStr = [commentContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tmpStr.length == 0) {
        [MBProgressHUD showMsg:commentTextView title:@"评论内容不能为空" delay:1.5];
        return;
    }
    if (tmpStr.length > 140) {
        [MBProgressHUD showMsg:commentTextView title:@"评论内容不能超过140个字" delay:1.5];
        return;
    }
    [WTStatusBar setStatusText:@"正在发送" animated:YES];
    [WTStatusBar setProgressBarColor:UIColorFromRGB(0x99cc00)];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"%@/community/index.php/index/addcomment/",kHost];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:token forKey:@"access_token"];
    [postDic setObject:_tid forKey:@"tid"];
    [postDic setObject:tmpStr forKey:@"content"];
    if (_rid != nil && _rid.length > 0) {
        [postDic setObject:_rid forKey:@"rid"];
    }
    [req setPostDataDic:postDic];
    [req setFinishBlock:^(NSData *data){
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
    }];
    [req setFailedBlock:^(NSError *err){
        
    }];
    [req setProgressBlock:^(float curr){
        if (curr < 1) {
            [WTStatusBar setProgress:curr animated:YES];
        }else{
            [WTStatusBar setStatusText:@"发送成功" timeout:1.f animated:YES];
            [self dismissSelf];
        }
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void) dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [hitLabel setHidden:NO];
    }else{
        [hitLabel setHidden:YES];
    }
}

- (void)showFaceKeyBoard:(UIButton *)button
{
    if (keyBoardType == 1) {
        [button setBackgroundImage:[UIImage imageNamed:@"ftkeyboard.png"] forState:UIControlStateNormal];
        [commentTextView resignFirstResponder];
        if (faceKeyBoard == nil) {
            faceKeyBoard = [[FaceContentView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 165)];
            [faceKeyBoard setBackgroundColor:[UIColor whiteColor]];
            CommentViewController *commVC = self;
            [faceKeyBoard.faceView setClickBlock:^(NSString *faceStr){
                [commVC addFaceStr:faceStr];
            }];
            [commentTextView addSubview:faceKeyBoard];
            [commentTextView bringSubviewToFront:faceKeyBoard];
        }
    
        [UIView animateWithDuration:0.35 animations:^{
            [faceKeyBoard setFrame:CGRectMake(0, commentTextView.frame.size.height - faceKeyBoard.frame.size.height, kScreenWidth, 165)];
            [toolView setFrame:CGRectMake(0, commentTextView.frame.size.height - faceKeyBoard.frame.size.height - 40, kScreenWidth, 40)];
        }];
        
        keyBoardType = 2;
    }else{
        [button setBackgroundImage:[UIImage imageNamed:@"face.png"] forState:UIControlStateNormal];
        [commentTextView becomeFirstResponder];
        keyBoardType = 1;
    }
}

- (void)addFaceStr:(NSString *)str
{
    if (![str isEqual:@"-1"]) {
        NSMutableString *orgStr = [NSMutableString stringWithString:commentTextView.text];
        [orgStr appendString:str];
        [hitLabel setHidden:YES];
        [commentTextView setText:orgStr];
    }else{
        NSMutableString *orgStr = [NSMutableString stringWithString:commentTextView.text];
        NSInteger len = orgStr.length;
        if (len <= 3) {
            if (len == 0) {
                return;
            }
            NSString *resStr = [orgStr substringToIndex:len - 1];
            [commentTextView setText:resStr];
            return;
        }
        NSString *lastSubStr = [orgStr substringFromIndex:len - 4];
        NSError *error = NULL;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[\\d{2}]" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result = [regex firstMatchInString:lastSubStr options:0 range:NSMakeRange(0, [lastSubStr length])];
        if (result) {
            NSString *resStr = [orgStr substringToIndex:len - 4];
            [commentTextView setText:resStr];
        }else{
            NSString *resStr = [orgStr substringToIndex:len - 1];
            [commentTextView setText:resStr];
        }
        if (commentTextView.text.length == 0) {
            [hitLabel setHidden:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"评论"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"评论"];
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
