//
//  PreViewController.m
//  Unigogo
//
//  Created by xxy on 14-6-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PreViewController.h"

@interface PreViewController ()

@end

@implementation PreViewController

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
    [self initNavBackground];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initNavBackground
{
    CGFloat navH;
    if (kVersion >= 7.0) {
        navH = 64;
    }else{
        navH = 44;
    }
    _navView = [[PubNavView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, navH)];
    [self.view addSubview:_navView];
    [_navView setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:UIColorFromRGB(0xdddddd)];
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, (navH - 44) + 7, 43, 30)];
    [backBtn setImage:[UIImage imageNamed:@"nav_back.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"nav_back_pressed.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAct) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:backBtn];
    titLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, (navH - 44) + 7, kScreenWidth - 80, 30)];
    [titLabel setBackgroundColor:[UIColor clearColor]];
    [titLabel setTextAlignment:NSTextAlignmentCenter];
    [titLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [titLabel setTextColor:UIColorFromRGB(0x0e0e0e)];
    [_navView addSubview:titLabel];
}

- (void)setTitle:(NSString *)title
{
    [titLabel setText:title];
}

- (void)backAct
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (_disBlock != nil) {
            _disBlock();
        }
    }];
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
