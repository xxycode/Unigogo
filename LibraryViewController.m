//
//  LibraryViewController.m
//  Unigogo
//
//  Created by xxy on 14-6-19.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LibraryViewController.h"


@interface LibraryViewController ()

@end

@implementation LibraryViewController

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
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //[self setTitle:@"移动图书馆"];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    ktype = @"1";
    mtype = @"qx";
    kArr = @[@"默认",@"作者",@"条码",@"出版社",@"题名缩写"];
    mArr = @[@"向前匹配",@"模糊匹配",@"精确匹配"];
    currK = 0;
    currM = 0;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 9/16)];
    [imageView setImage:[UIImage imageNamed:@"libbg.png"]];
    [self.view addSubview:imageView];
    searchField = [[LRTextFeild alloc] initWithFrame:CGRectMake(20, 100, kScreenWidth - 40, 40 )];
    [searchField setPlaceholder:@"关键词"];
    [searchField setReturnKeyType:UIReturnKeySearch];
    [searchField setDelegate:self];
    [imageView addSubview:searchField];
    [imageView setUserInteractionEnabled:YES];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, navBarH - 44 + 10, kScreenWidth - 80, 24)];
    [imageView addSubview:titleLabel];
    [titleLabel setText:@"移动图书馆"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:20.0f]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [searchField.layer setShadowColor:[UIColor blackColor].CGColor];
    [searchField.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    
    backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (navBarH - 44) + 7, 32, 30)];
    [backBtn setImage:[UIImage imageNamed:@"proback.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popAct) forControlEvents:UIControlEventTouchUpInside];
    
    editBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 10 - 32, (navBarH - 44) + 7, 32, 30)];
    [editBtn setImage:[UIImage imageNamed:@"proset.png"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(setAct) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:backBtn];
    [imageView addSubview:editBtn];
    
    CGFloat bY = 32 + 180;
    CGFloat bX = 20;
    
    NSArray *img = @[@"borrowered.png",@"opentime.png",@"location.png"];
    NSArray *tit = @[@"已借图书",@"开放时间",@"馆藏分布"];
    
    for (int i = 0; i < 3; i ++) {
        MainButton *button = [[MainButton alloc] initWithFrame:CGRectMake(bX, bY, 80, 80)];
        bX += 100;
        [button setImage:[UIImage imageNamed:[img objectAtIndex:i]] forState:UIControlStateNormal];
        [button setBottomTitle:[tit objectAtIndex:i]];
        [button setTitleColor:[UIColor blackColor]];
        [button setTag:2014 + i];
        [button addTarget:self action:@selector(btnAct:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    [self.view addGestureRecognizer:tapGR];
}

- (void)btnAct:(MainButton *)button
{
    NSInteger tag = button.tag - 2014;
    switch (tag) {
        case 0:
        {
            if (borrVC == nil)
                borrVC = [[BorrowedViewController alloc] init];
            [self.navigationController pushViewController:borrVC animated:YES];
        }
            break;
        case 1:
        {
            if (openVC == nil)
                openVC = [[OpenTimeViewController alloc] init];
            [self.navigationController pushViewController:openVC animated:YES];
        }
            
            break;
        case 2:
        {
            if (locaVC == nil)
                locaVC = [[LocationViewController alloc] init];
            [self.navigationController pushViewController:locaVC animated:YES];
        }
            
            break;
        default:
            break;
    }
}

- (void)popAct
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setAct
{
    if (sView == nil) {
        sView = [[UIView alloc] initWithFrame:self.view.bounds];
        [self.view.window addSubview:sView];
        [sView setBackgroundColor:[UIColor clearColor]];
    }
    [sView setHidden:NO];
    if (selectView == nil) {
        selectView = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 40, 320)];
        [selectView setCenter:self.view.center];
        [selectView setWindowLevel:UIWindowLevelAlert];
        [sView addSubview:selectView];
        [selectView.layer setCornerRadius:5.f];
        [selectView setBackgroundColor:[UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:0.9f]];
    }
    [selectView setHidden:NO];
    CGFloat btnWidth = (kScreenWidth - 40 - 30)/2;
    selectCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	selectCancelButton.frame = CGRectMake(10 + btnWidth + 10,270,btnWidth,40);
	selectCancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	selectCancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	[selectCancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[selectCancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[selectCancelButton setBackgroundColor:[UIColor clearColor]];
	[selectCancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertCancalButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
	[selectCancelButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertCancalButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
	selectCancelButton.opaque = NO;
	selectCancelButton.layer.cornerRadius = 5.0;
	[selectCancelButton addTarget:self action:@selector(dismissTableAlert) forControlEvents:UIControlEventTouchUpInside];
    [selectView addSubview:selectCancelButton];
    
    selectOkButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	selectOkButton.frame = CGRectMake(10,270,btnWidth,40);
	selectOkButton.titleLabel.textAlignment = NSTextAlignmentCenter;
	selectOkButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
	[selectOkButton setTitle:@"确定" forState:UIControlStateNormal];
    [selectOkButton addTarget:self action:@selector(okBtnClicked) forControlEvents:UIControlEventTouchUpInside];
	[selectOkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[selectOkButton setBackgroundColor:[UIColor clearColor]];
	[selectOkButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButton.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
	[selectOkButton setBackgroundImage:[[UIImage imageNamed:@"MLTableAlertButtonPressed.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
	selectOkButton.opaque = NO;
	selectOkButton.layer.cornerRadius = 5.0;
	[selectView addSubview:selectOkButton];
    [selectView makeKeyAndVisible];
    
    selectTable = [[UITableView alloc] initWithFrame:CGRectMake(5, 50, kScreenWidth - 50, 210)];
    [selectView addSubview:selectTable];
    [selectTable setDelegate:self];
    [selectTable setDataSource:self];
    
    UILabel *titLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth - 40, 20)];
    [titLabel setBackgroundColor:[UIColor clearColor]];
    [titLabel setTextAlignment:NSTextAlignmentCenter];
    [selectView addSubview:titLabel];
    [titLabel setFont:[UIFont systemFontOfSize:18.f]];
    [titLabel setTextColor:[UIColor whiteColor]];
    [titLabel setText:@"检索设置"];
    
    selectView.transform = CGAffineTransformMakeScale(0.3, 0.3);
	[UIView animateWithDuration:0.2 animations:^{
        [selectView setAlpha:1.f];
		selectView.transform = CGAffineTransformMakeScale(1.03, 1.03);
	} completion:^(BOOL finished){
		[UIView animateWithDuration:1.0/20.f animations:^{
			selectView.transform = CGAffineTransformMakeScale(0.95, 0.95);
		} completion:^(BOOL finished){
			[UIView animateWithDuration:1.0/20.f animations:^{
				selectView.transform = CGAffineTransformIdentity;
			}];
		}];
	}];
    
}

- (void)okBtnClicked
{
    switch (currM) {
        case 0:
            mtype = @"qx";
            break;
        case 1:
            mtype = @"mh";
            break;
        case 2:
            mtype = @"jq";
            break;
        default:
            break;
    }
    switch (currK) {
        case 0:
            ktype = @"1";
            break;
        case 1:
            ktype = @"4";
            break;
        case 2:
            ktype = @"7";
            break;
        case 3:
            ktype = @"2";
            break;
        case 4:
            ktype = @"9";
            break;
        default:
            break;
    }
    [self dismissTableAlert];
}

- (void)dismissTableAlert
{
    [UIView animateWithDuration:1.0/7.5 animations:^{
		selectView.transform = CGAffineTransformMakeScale(0.9, 0.9);
	} completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            selectView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            selectView.alpha = 0.3;
        } completion:^(BOOL finished){
            // table alert not shown anymore
            [selectView setHidden:YES];
            [sView setHidden:YES];
        }];
    }];
}

- (void)dismissKeyBoard
{
    [searchField resignFirstResponder];
}

#pragma mark UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger se = indexPath.section;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (se) {
        case 0:
        {
            [cell.textLabel setText:[mArr objectAtIndex:indexPath.row]];
            if (indexPath.row == currM) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        case 1:
        {
            [cell.textLabel setText:[kArr objectAtIndex:indexPath.row]];
            if (indexPath.row == currK) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        default:
            break;
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"匹配方式";
    }else{
        return @"检索词类型";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger se = indexPath.section;
    if (se == 0) {
        currM = indexPath.row;
    }else{
        currK = indexPath.row;
    }
    [selectTable reloadData];
}

#pragma mark UITextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *str = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (str.length == 0) {
        [MBProgressHUD showMsg:self.view title:@"关键词不能为空" delay:1.5];
    }else{
        [searchField resignFirstResponder];
        SearchResultViewController *searchResVC = [[SearchResultViewController alloc] init];
        searchResVC.ktype = ktype;
        searchResVC.mtype = mtype;
        searchResVC.keyWord = str;
        [self.navigationController pushViewController:searchResVC animated:YES];
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"移动图书馆"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"移动图书馆"];
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
