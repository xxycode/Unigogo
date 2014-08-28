//
//  AddTagViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-7.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "AddTagViewController.h"

@interface AddTagViewController ()

@end

@implementation AddTagViewController

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
    [self setTitle:@"添加标签"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    tagView = [[UITextView alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, kScreenHeight - 64)];
    [tagView setFont:[UIFont systemFontOfSize:16.0f]];
    [tagView setDelegate:self];
    if (_tags != nil && _tags.length > 0) {
        [tagView setText:_tags];
    }
    [self.view addSubview:tagView];
    if (kVersion >= 7.0) {
        hitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 280, 20)];
    }else{
        hitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 280, 20)];
    }
    [hitLabel setBackgroundColor:[UIColor clearColor]];
    [hitLabel setTextColor:UIColorFromRGB(0x999999)];
    if (tagView.text.length == 0) {
        [hitLabel setText:@"请输入标签，多个标签请用空格隔开"];
    }
    [tagView addSubview:hitLabel];
    [tagView becomeFirstResponder];
    UIButton *comButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 60, 7 + navBarH - 44, 50, 30)];
    [comButton setBackgroundColor:UIColorFromRGB(0x80b305)];
    [comButton setTitle:@"完成" forState:UIControlStateNormal];
    [comButton.layer setCornerRadius:15.f];
    [comButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [comButton addTarget:self action:@selector(finishAct) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:comButton];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [hitLabel setHidden:NO];
    }else{
        [hitLabel setHidden:YES];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        [hitLabel setHidden:NO];
    }
}

- (void)finishAct
{
    if (self.addBlock) {
        [self dismissViewControllerAnimated:YES completion:nil];
        _addBlock(tagView.text);
    }
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
