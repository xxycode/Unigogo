//
//  TopicCell.m
//  Unigogo
//
//  Created by xxy on 14-7-7.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "TopicCell.h"
#import "DAProgressOverlayView.h"
#import "UIButton+setFrame.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>

@implementation TopicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews:NO deletable:NO];
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier personal:(BOOL)per deleteAble:(BOOL)deletable
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews:per deletable:deletable];
    }
    return self;
}

- (void)initViews:(BOOL)per deletable:(BOOL)deletable
{
    isPer = per;
    canDelet = deletable;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    fromImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 36, 36)];
    [fromImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *tGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTap:)];
    [fromImage addGestureRecognizer:tGR];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(7, 5, kScreenWidth - 14, 300)];
    [bgView.layer setBorderWidth:1.0f];
    [bgView.layer setBorderColor:UIColorFromRGB(0xcccccc).CGColor];
    [fromImage.layer setMasksToBounds:YES];
    //[fromImage.layer setCornerRadius:18.0f];
    [bgView addSubview:fromImage];
    [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    [self.contentView addSubview:bgView];
    [bgView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8]];
    fromName = [[UILabel alloc] initWithFrame:CGRectMake(46, 5, 200, 20)];
    [fromName setBackgroundColor:[UIColor clearColor]];
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 25, 120, 20)];
    [timeLabel setTextColor:UIColorFromRGB(0x99cc00)];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 46, kScreenWidth - 14, (kScreenWidth - 14)*3/4)];
    [itemImage setContentMode:UIViewContentModeScaleToFill];
    UITapGestureRecognizer *panGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panAct)];
    [itemImage addGestureRecognizer:panGR];
    [itemImage setUserInteractionEnabled:YES];
    CGRect frame = [itemImage frame];
    contentTextView = [[TQRichTextView alloc] initWithFrame:CGRectMake(5, frame.origin.y+frame.size.height+5, frame.size.width - 10, 20)];
    [contentTextView setFont:[UIFont systemFontOfSize:17.0f]];
    [contentTextView setBackgroundColor:[UIColor clearColor]];
    tagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag.png"]];
    tagLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [tagLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [tagLabel setTextColor:UIColorFromRGB(0x888888)];
    [tagLabel setBackgroundColor:[UIColor clearColor]];
    [tagLabel.layer setCornerRadius:5.0f];
    [bgView addSubview:tagView];
    [bgView addSubview:tagLabel];
    [bgView addSubview:fromName];
    [bgView addSubview:contentTextView];
    [bgView addSubview:itemImage];
    [bgView addSubview:timeLabel];
    if (!per) {
        UIButton *juBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 14 - 5 - 40, 5, 40, 20)];
        [juBtn setTitle:@"举报" forState:UIControlStateNormal];
        [juBtn.titleLabel setFont:[UIFont systemFontOfSize:13.f]];
        [juBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
        [juBtn addTarget:self action:@selector(juBaoaAct) forControlEvents:UIControlEventTouchUpInside];
        [juBtn setTitleColor:UIColorFromRGB(0x888888) forState:UIControlStateNormal];
        [bgView addSubview:juBtn];
        itemsTypes = @[@"请选择",@"色情",@"广告",@"反动",@"暴力",@"侵权",@"其他"];
        hotView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hot.png"]];
        [hotView setFrame:CGRectMake(0, 0, 110, 44)];
        commentBtn = [[TopExButton alloc] initWithFrame:CGRectMake(0, 0, 49, 44)];
        [commentBtn setImage:[UIImage imageNamed:@"commentt.png"] forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"commentth.png"] forState:UIControlStateHighlighted];
        [commentBtn addTarget:self action:@selector(commentAct) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn setBottomTitle:@"评论"];
        repostBtn = [[TopExButton alloc] initWithFrame:CGRectMake(0, 0, 49, 44)];
        [repostBtn setImage:[UIImage imageNamed:@"repost.png"] forState:UIControlStateNormal];
        [repostBtn setImage:[UIImage imageNamed:@"reposth.png"] forState:UIControlStateHighlighted];
        [repostBtn addTarget:self action:@selector(repostAct) forControlEvents:UIControlEventTouchUpInside];
        [repostBtn setBottomTitle:@"分享"];
        zanBtn = [[TopExButton alloc] initWithFrame:CGRectMake(0, 0, 49, 44)];
        [zanBtn setImage:[UIImage imageNamed:@"zanf.png"] forState:UIControlStateNormal];
        [zanBtn setImage:[UIImage imageNamed:@"zanfh.png"] forState:UIControlStateHighlighted];
        [zanBtn addTarget:self action:@selector(zanAct) forControlEvents:UIControlEventTouchUpInside];
        [zanBtn setBottomTitle:@"赞"];
        favBtn = [[TopExButton alloc] initWithFrame:CGRectMake(0, 0, 49, 44)];
        [favBtn setBottomTitle:@"收藏"];
        [favBtn setImage:[UIImage imageNamed:@"favt.png"] forState:UIControlStateNormal];
        [favBtn setImage:[UIImage imageNamed:@"favth.png"] forState:UIControlStateHighlighted];
        [favBtn addTarget:self action:@selector(favAct) forControlEvents:UIControlEventTouchUpInside];
        hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 110, 24)];
        [hotLabel setBackgroundColor:[UIColor clearColor]];
        [hotLabel setTextAlignment:NSTextAlignmentCenter];
        [hotLabel setTextColor:UIColorFromRGB(0x9a9a9a)];
        [hotView addSubview:hotLabel];
        [bgView addSubview:hotView];
        [bgView addSubview:commentBtn];
        [bgView addSubview:repostBtn];
        [bgView addSubview:zanBtn];
        [bgView addSubview:favBtn];
    }
    if (canDelet) {
        delBtn = [[UIButton alloc] initWithFrame:CGRectMake(295 - 27, 10, 27, 20)];
        [delBtn setImage:[UIImage imageNamed:@"comDel.png"] forState:UIControlStateNormal];
        [delBtn addTarget:self action:@selector(deleteAct) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:delBtn];
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cellPanGes:)];
        panGes.delegate = self;
        panGes.delaysTouchesBegan = YES;
        panGes.cancelsTouchesInView = NO;
        [self addGestureRecognizer:panGes];
        deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 60, 30)];
        [deleteButton setBackgroundColor:[UIColor redColor]];
        [deleteButton.layer setCornerRadius:15];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [deleteButton setAlpha:0.0f];
        [deleteButton addTarget:self action:@selector(deleteAct) forControlEvents:UIControlEventTouchUpInside];
        [self insertSubview:deleteButton belowSubview:self.contentView];
    }
    //tagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag.png"]];
}

- (void)juBaoaAct
{
    if (typeSelectView == nil) {
        typeSelectView = [JuBaoTableAlert tableAlertWithTitle:@"请选择一个类别" cancelButtonTitle:@"取消" numberOfRows:^NSInteger (NSInteger section)
                          {
                              return itemsTypes.count;
                          }
                                                     andCells:^UITableViewCell* (JuBaoTableAlert *anAlert, NSIndexPath *indexPath)
                          {
                              static NSString *CellIdentifier = @"CellIdentifier";
                              UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                              if (cell == nil)
                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                              
                              if (currJtype == indexPath.row) {
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
		currJtype = selectedIndex.row;
        [typeSelectView.table reloadData];
	} andCompletionBlock:^{
		
	}];
	
	// show the alert
	[typeSelectView show];
    [typeSelectView.okButton addTarget:self action:@selector(juBaoOkAct) forControlEvents:UIControlEventTouchUpInside];
}

- (void)juBaoOkAct
{
    if (currJtype == 0) {
        [MBProgressHUD showMsg:typeSelectView title:@"请选择一个类别" delay:2];
        return;
    }
    [typeSelectView dismissTableAlert];
    NSString *url = [NSString stringWithFormat:@"%@/lostandfound/index.php/index/jubao",kHost];
    HUD = [[MBProgressHUD alloc] initWithView:self.window];
    [self.window addSubview:HUD];
    [HUD show:YES];
    HUD.labelText = @"正在加载";
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token != nil) {
        [postDic setObject:token forKey:@"token"];
    }
    [postDic setObject:_item.tid forKey:@"lid"];
    [postDic setObject:[itemsTypes objectAtIndex:currJtype] forKey:@"type"];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setPostDataDic:postDic];
    [req setFinishBlock:^(NSData *data){
        [HUD hide:YES];
        [self finishLoadData];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishLoadData
{
    [MBProgressHUD showMsg:self.window title:@"非常感谢你的举报" delay:2];
}


- (void)repostAct
{
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@http://218.244.137.199/community/index.php/index/show?id=%@",_item.content,_item.tid]
                                       defaultContent:@"欢迎下载Go校园"
                                                image:nil
                                                title:@"我分享了一条来自湘潭大学Go社区的帖子，快来看看吧"
                                                  url:[NSString stringWithFormat:@"http://218.244.137.199/community/index.php/index/show?id=%@",_item.tid]
                                          description:@"这是一条来自Go校园的信息"
                                            mediaType:SSPublishContentMediaTypeText];
 
    [ShareSDK showShareActionSheet:nil
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions: nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)imgTap:(UITapGestureRecognizer *)tGR
{
    if (_showProfileBlock) {
        _showProfileBlock(_item.uid);
    }
}

-(void)cellPanGes:(UIPanGestureRecognizer *)panGes{
    CGPoint pointer = [panGes locationInView:self.contentView];
    if (panGes.state == UIGestureRecognizerStateBegan) {
        starX = pointer.x;
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        CGPoint p = [panGes locationInView:self];
        CGRect f = self.contentView.frame;
        f.origin.x = p.x - starX;
        [self.contentView setFrame:f];
    }else if (panGes.state == UIGestureRecognizerStateEnded){
        CGRect f = self.contentView.frame;
        if (f.origin.x < -60) {
            f.origin.x = -70;
            [UIView animateWithDuration:0.2 animations:^{
                [self.contentView setFrame:f];
                [deleteButton setAlpha:1.0f];
            }];
        }else{
            f.origin.x = 0;
            [UIView animateWithDuration:0.2 animations:^{
                [self.contentView setFrame:f];
                [deleteButton setAlpha:0.0f];
            }];
        }
        return;
    }else if (panGes.state == UIGestureRecognizerStateCancelled){
        
        return;
    }
    
}


#pragma mark * UIPanGestureRecognizer delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //    NSString *str = [NSString stringWithUTF8String:object_getClassName(gestureRecognizer)];
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:self];
        return fabs(translation.x) > fabs(translation.y);
    }
    return YES;
}


- (void)commentAct
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        if (_noToken) {
            _noToken();
        }
        return;
    }
    NSInteger numcom = _item.numcomment.integerValue;
    if (numcom == 0) {
        if (_comBlock) {
            _comBlock(NO,_item.tid);
        }
    }else{
        if (_comBlock) {
            _comBlock(YES,_item.tid);
        }
    }
}

- (void)zanAct
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
    if (token == nil) {
        if (_noToken) {
            _noToken();
        }
        return;
    }
    if (!_item.zanAble) {
        XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
        NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
        [postDic setObject:token forKey:@"access_token"];
        [postDic setObject:_item.tid forKey:@"tid"];
        [req setPostDataDic:postDic];
        [req setFinishBlock:^(NSData *data){
            [self delZanFinish:data];
        }];
        [req setFailedBlock:^(NSError *err){
            [self failedLoadData];
        }];
        [req setProgressBlock:^(float curr){
            
        }];
        [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/community/index.php/index/delzan"]];
        return;
    }
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    NSMutableDictionary *postDic = [[NSMutableDictionary alloc] init];
    [postDic setObject:token forKey:@"access_token"];
    [postDic setObject:_item.tid forKey:@"tid"];
    [req setPostDataDic:postDic];
    [req setFinishBlock:^(NSData *data){
        [self zanFinish:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoadData];
    }];
    [req setProgressBlock:^(float curr){
        
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:@"http://218.244.137.199/community/index.php/index/addzan"]];
    if (handView == nil) {
        handView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 17)];
    }
    [handView setCenter:CGPointMake(49/2.0, 44/2 - 5)];
    [handView setImage:[UIImage imageNamed:@"hand.png"]];
    [zanBtn addSubview:handView];
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	handView.layer.opacity = 1.0;
	[CATransaction commit];
	CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.fromValue = [NSValue valueWithCGPoint:handView.layer.position];
	positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(100, -100)];
	CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	boundsAnimation.fromValue = [NSValue valueWithCGRect:handView.layer.bounds];
	boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	opacityAnimation.toValue = [NSNumber numberWithFloat:0.f];
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
	rotateAnimation.toValue = [NSNumber numberWithFloat:0.25 * M_PI];
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.beginTime = CACurrentMediaTime() + 0.5;
	group.duration = 1;
	group.animations = [NSArray arrayWithObjects:positionAnimation, boundsAnimation, opacityAnimation, rotateAnimation, nil];
	group.delegate = self;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	[handView.layer addAnimation:group forKey:@"moveh"];
    [self performSelector:@selector(removeHand) withObject:nil afterDelay:1.5];
}

- (void)removeHand
{
    [handView removeFromSuperview];
}

- (void)delZanFinish:(NSData *)data
{
    [zanBtn setImage:[UIImage imageNamed:@"zanf.png"] forState:UIControlStateNormal];
    NSString *zann = [zanBtn getBottomTitle];
    if (zann.integerValue == 1) {
        [zanBtn setBottomTitle:@"赞"];
    }else{
        [zanBtn setBottomTitle:[NSString stringWithFormat:@"%d",zann.integerValue - 1]];
    }
    _item.zanAble = YES;
}

- (void)zanFinish:(NSData *)data
{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *status = [dic objectForKey:@"status"];
    if ([status isKindOfClass:[NSNull class]]) {
        return;
    }
    if ([status isEqual:@"1"]) {
        NSString *zann = [zanBtn getBottomTitle];
        if ([zann isEqual:@"赞"]) {
            [zanBtn setBottomTitle:@"1"];
        }else{
            [zanBtn setBottomTitle:[NSString stringWithFormat:@"%d",zann.integerValue + 1]];
        }
        _item.zanAble = NO;
        [zanBtn setImage:[UIImage imageNamed:@"zanfed.png"] forState:UIControlStateNormal];
    }
}

- (void)failedLoadData
{
    [MBProgressHUD showMsg:self.window title:@"网络出错，请检查网络" delay:2];
}

- (void)favAct
{
    NSDictionary *dic = [_item getDicOfItem];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favt"];
    NSArray *idArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favtid"];
    for (NSString *str in idArr) {
        if ([str isEqualToString:_item.tid]) {
            [MBProgressHUD showMsg:self.window title:@"你已经收藏过这条信息了" delay:2];
            return;
        }
    }
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:arr];
    NSMutableArray *tmpArrId = [[NSMutableArray alloc] initWithArray:idArr];
    [tmpArr addObject:dic];
    [tmpArrId addObject:_item.tid];
    [[NSUserDefaults standardUserDefaults] setObject:tmpArr forKey:@"favt"];
    [[NSUserDefaults standardUserDefaults] setObject:tmpArrId forKey:@"favtid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (xinView == nil) {
        xinView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 17)];
    }
    
    [xinView setCenter:CGPointMake(49/2.0, 44/2 - 5)];
    [xinView setImage:[UIImage imageNamed:@"xin.png"]];
    [favBtn addSubview:xinView];
    [CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	xinView.layer.opacity = 1.0;
	[CATransaction commit];
	CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	positionAnimation.fromValue = [NSValue valueWithCGPoint:xinView.layer.position];
	positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(-50, -100)];
	CABasicAnimation *boundsAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
	boundsAnimation.fromValue = [NSValue valueWithCGRect:xinView.layer.bounds];
	boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 50, 50)];
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
	opacityAnimation.toValue = [NSNumber numberWithFloat:0.f];
	CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.fromValue = [NSNumber numberWithFloat:0 * M_PI];
	rotateAnimation.toValue = [NSNumber numberWithFloat:-0.25 * M_PI];
	CAAnimationGroup *group = [CAAnimationGroup animation];
	group.beginTime = CACurrentMediaTime() + 0.5;
	group.duration = 1;
	group.animations = [NSArray arrayWithObjects:positionAnimation, boundsAnimation, opacityAnimation, rotateAnimation, nil];
	group.delegate = self;
	group.fillMode = kCAFillModeForwards;
	group.removedOnCompletion = NO;
	[xinView.layer addAnimation:group forKey:@"move"];
    [self performSelector:@selector(removeXin) withObject:nil afterDelay:1.5];
}

- (void)removeXin
{
    //[MBProgressHUD showMsg:self.window title:@"收藏成功" delay:2];
    [xinView removeFromSuperview];
    [favBtn setImage:[UIImage imageNamed:@"faved.png"] forState:UIControlStateNormal];
}

- (void)panOnCellAct
{
    CGRect f = bgView.frame;
    if (f.origin.x == 7) {
        f.origin.x = -7;
    }else{
        f.origin.x = 7;
    }
    [UIView animateWithDuration:0.25 animations:^{
        [bgView setFrame:f];
    }];
}

- (void)doubleTap
{
    if (scView.zoomScale != 1.0f) {
        [scView setZoomScale:1 animated:YES];
    }else{
        [scView setZoomScale:2.0f animated:YES];
    }
}


- (void)panAct
{
    imgV = [[UIImageView alloc] initWithFrame:itemImage.frame];
    [imgV setImage:itemImage.image];
    scView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    scView.minimumZoomScale=0.5f;
    scView.maximumZoomScale=2.0f;
    [scView setUserInteractionEnabled:YES];
    [scView setDelegate:self];
    [scView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    UITapGestureRecognizer *dGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissShView:)];
    [scView addGestureRecognizer:dGR];
    UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
    doubleRecognizer.numberOfTapsRequired = 2;
    [imgV addGestureRecognizer:doubleRecognizer];
    [imgV setUserInteractionEnabled:YES];
    [dGR requireGestureRecognizerToFail:doubleRecognizer];
    CGRect f = imgV.frame;
    f.size.width = kScreenWidth;
    f.size.height = kScreenWidth*3/4;
    f.origin.y = (kScreenHeight - f.size.height)/2;
    [self.window addSubview:scView];
    UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(20, kScreenHeight - 20 - 36, 36, 36)];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"save.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAct) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setEnabled:NO];
    [saveButton setTag:208];
    [self.window addSubview:saveButton];
    CGRect f2 = [bgView convertRect:itemImage.frame toView:scView];
    [imgV setFrame:f2];
    [scView addSubview:imgV];
    [UIView animateWithDuration:0.35 animations:^{
        [imgV setFrame:f];
    } completion:^(BOOL finished){
        [itemImage setHidden:YES];
        DAProgressOverlayView *cPV = [[DAProgressOverlayView alloc] initWithFrame:imgV.bounds];
        [imgV addSubview:cPV];
        [cPV setProgress:0.0f];
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/community/Public/Uploads/%@", _item.pic_url];
        [imgV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:imgV.image options:SDWebImageContinueInBackground progress:^(NSInteger rec,NSInteger exp){
            [cPV setProgress:rec*1.0/exp];
        }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            [saveButton setEnabled:YES];
            CGSize size = image.size;
            CGFloat ow = size.width;
            CGFloat oh = size.height;
            CGFloat w = kScreenWidth;
            CGFloat h = (w * oh)/ow;
            CGRect frame = imgV.frame;
            frame.size = CGSizeMake(w, h);
            frame.origin.y = h>kScreenHeight? 0:(kScreenHeight/2 - h/2);
            [UIView animateWithDuration:0.35 animations:^{
                [imgV setFrame:frame];
            }];
            [cPV removeFromSuperview];
        }];
    }];
    
}

- (void)saveAct
{
    UIImageWriteToSavedPhotosAlbum(imgV.image, nil, nil, nil);
    [MBProgressHUD showMsg:self.window title:@"保存图片成功" delay:1.75];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imgV;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize s = scrollView.contentSize;
    if (scrollView.zoomScale >= 1.0f) {
        CGRect f = imgV.frame;
        if (f.size.height == MAX(f.size.height, f.size.width)) {
            [imgV setCenter:CGPointMake(s.width/2, s.height/2)];
        }else{
            [imgV setCenter:CGPointMake(s.width/2, kScreenHeight/2)];
        }
    }else{
        [imgV setCenter:CGPointMake(kScreenWidth/2, kScreenHeight/2)];
    }
}

- (void)dismissShView:(UITapGestureRecognizer *)ges
{
    UIButton *btn = (UIButton *)[self.window viewWithTag:208];
    [btn removeFromSuperview];
    CGRect bF = [scView convertRect:imgV.frame toView:bgView];
    [imgV setFrame:bF];
    [imgV setImage:itemImage.image];
    [bgView addSubview:imgV];
    [UIView animateWithDuration:0.35 animations:^{
        [imgV setFrame:itemImage.frame];
        [scView setAlpha:0.0f];
    }completion:^(BOOL comp){
        [itemImage setHidden:NO];
        [scView removeFromSuperview];
        [imgV removeFromSuperview];
    }];
}

+ (CGFloat)cellHeightForItem:(TopicItem *)item isPer:(BOOL)per
{
    CGFloat h = 0.0;
    h += 46;
    if (![item.pic_url isEqualToString:@""]) {
        h += 235;
    }
    NSString *st = [item.content stringByReplacingOccurrencesOfString:@"]" withString:@""];
    CGSize labelSize = [st sizeWithFont:[UIFont boldSystemFontOfSize:17.f]
                                constrainedToSize:CGSizeMake(kScreenWidth - 24, 1000)
                                    lineBreakMode:NSLineBreakByCharWrapping];   // str是要显示的字符串
    h += labelSize.height + 20 + 45 + 22;
    if (item.tag.length == 0) {
        h -= 20;
    }
    if (per) {
        h -= 44;
    }
    return h;
}

- (void)deleteAct
{
    if (_delActionBlock != nil) {
        _delActionBlock(_indexPath);
    }
    if (_delPreActionBlock != nil) {
        _delPreActionBlock(_indexPath,_item.tid);
    }
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat h = [TopicCell cellHeightForItem:_item isPer:NO];
    if (canDelet) {
        [deleteButton setAlpha:0.0f];
        [deleteButton setCenter:CGPointMake(kScreenWidth - 35, h/2.0)];
    }
    CGRect frame = bgView.frame;
    frame.size.height = h - 5;
    if (![_item.thumbpic_url isEqualToString:@"empty"]) {
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/community/Public/Uploads/%@", _item.userthumb];
        [fromImage sd_setImageWithURL:[NSURL URLWithString:url]];
    }else
    {
        [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    }
    [timeLabel setText:[self getTime:_item.addtime]];
    [bgView setFrame:frame];
    if ([_item.from isEqualToString:@"-1"]) {
        fromName.text =  @"匿名用户";
        [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    }else{
        fromName.text = _item.from;
    }
    contentTextView.text =  _item.content;
    if (![_item.pic_url isEqualToString:@""]) {
        [itemImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://218.244.137.199/community/Public/Uploads/%@", _item.thumbpic_url]]];
        CGRect frame =  contentTextView.frame;
        [contentTextView setText:_item.content];
        frame.origin.y =  286;
        NSString *st = [_item.content stringByReplacingOccurrencesOfString:@"]" withString:@""];
        CGSize labelSize = [st sizeWithFont:[UIFont boldSystemFontOfSize:17.f]
                                     constrainedToSize:CGSizeMake(kScreenWidth - 20, 1000)
                                         lineBreakMode:NSLineBreakByCharWrapping];
        frame.size.height = labelSize.height+10;
        [contentTextView setFrame:frame];
        [itemImage setHidden:NO];
    }else{
        CGRect frame =  contentTextView.frame;
        frame.origin.y =  51;
        CGSize labelSize = [_item.content sizeWithFont:[UIFont boldSystemFontOfSize:16.5f]
                                     constrainedToSize:CGSizeMake(kScreenWidth - 20, 1000)
                                         lineBreakMode:NSLineBreakByCharWrapping];
        frame.size.height = labelSize.height + 10;
        [contentTextView setText:_item.content];
        [contentTextView setFrame:frame];
        [itemImage setHidden:YES];
    }
    if (_item.tag != nil && _item.tag.length > 0) {
        [tagView setHidden:NO];
        [tagLabel setHidden:NO];
        CGRect btnFrame = contentTextView.frame;
        [tagView setFrame:CGRectMake(5, btnFrame.origin.y + btnFrame.size.height + 3 , 13, 13)];
        [tagLabel setText:_item.tag];
        NSInteger len = tagLabel.text.length;
        [tagLabel setFrame:CGRectMake(22, btnFrame.origin.y + btnFrame.size.height + 0, len*13+4, 18)];
    }else{
        [tagView setHidden:YES];
        [tagLabel setHidden:YES];
    }
    if (!isPer) {
        CGFloat y = bgView.frame.size.height - 44;
        CGFloat x = 0;
        [hotLabel setText:[NSString stringWithFormat:@"%@热度",_item.numhot]];
        [hotView setX:x];
        [hotView setY:y];
        x += 110;
        if ([_item.numcomment isEqual:@"0"]) {
            [commentBtn setBottomTitle:@"评论"];
        }else{
            [commentBtn setBottomTitle:_item.numcomment];
        }
        [commentBtn setY:y];
        [commentBtn setX:x];
        x += 49;
        if ([_item.numshare isEqual:@"0"]) {
            [repostBtn setBottomTitle:@"分享"];
        }else{
            [repostBtn setBottomTitle:_item.numshare];
        }
        [repostBtn setY:y];
        [repostBtn setX:x];
        x += 49;
        if ([_item.numzan isEqual:@"0"]) {
            [zanBtn setBottomTitle:@"赞"];
        }else{
            [zanBtn setBottomTitle:_item.numzan];
        }
        [zanBtn setX:x];
        [zanBtn setY:y];
        x += 49;
        [favBtn setX:x];
        [favBtn setY:y];
    }
    if (_item.zanAble) {
        [zanBtn setImage:[UIImage imageNamed:@"zanf.png"] forState:UIControlStateNormal];
    }else{
        [zanBtn setImage:[UIImage imageNamed:@"zanfed.png"] forState:UIControlStateNormal];
    }
    [favBtn setImage:[UIImage imageNamed:@"favt.png"] forState:UIControlStateNormal];
    NSArray *idArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favtid"];
    for (NSString *str in idArr) {
        if ([str isEqualToString:_item.tid]) {
            [favBtn setImage:[UIImage imageNamed:@"faved.png"] forState:UIControlStateNormal];
        }
    }
}

- (NSString *)getTime:(NSString *)time
{
    NSInteger cTime = time.integerValue;
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    NSInteger del = curTime - cTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:cTime];
    if (del < 60) {
        return @"刚刚";
    } else if (del < 3600){
        return [NSString stringWithFormat:@"%d分钟前",del/60];
    } else if (del < 3600 * 24){
        return [NSString stringWithFormat:@"%d小时前",del/3600];
    } else{
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString * s = [dateFormatter stringFromDate:date];
        return s;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
