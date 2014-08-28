//
//  LostItemCell.m
//  Unigogo
//
//  Created by xxy on 14-6-25.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LostItemCell.h"
#import "DAProgressOverlayView.h"
#import "UIButton+setFrame.h"
#import "MBProgressHUD.h"
#import <ShareSDK/ShareSDK.h>

@class LostandfoundViewController;

@implementation LostItemCell

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
    canDelet = deletable;
    isPer = per;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    fromImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 36, 36)];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(7, 5, kScreenWidth - 14, 300)];
    [fromImage.layer setMasksToBounds:YES];
    [fromImage.layer setCornerRadius:18.0f];
    [bgView addSubview:fromImage];
    [bgView.layer setBorderWidth:1.0f];
    [bgView.layer setBorderColor:UIColorFromRGB(0xcccccc).CGColor];
    [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    [self.contentView addSubview:bgView];
    [bgView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.6]];
    fromName = [[UILabel alloc] initWithFrame:CGRectMake(46, 5, 200, 20)];
    [fromName setBackgroundColor:[UIColor clearColor]];
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 25, 120, 20)];
    UITapGestureRecognizer *callGR = [[UITapGestureRecognizer alloc] init];
    [callGR addTarget:self action:@selector(callPhone)];
    [timeLabel setTextColor:UIColorFromRGB(0x99cc00)];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    itemImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 46, kScreenWidth - 14, (kScreenWidth - 14)*3/4)];
    [itemImage setContentMode:UIViewContentModeScaleToFill];
    UITapGestureRecognizer *panGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panAct)];
    [itemImage addGestureRecognizer:panGR];
    [itemImage setUserInteractionEnabled:YES];
    CGRect frame = [itemImage frame];
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, frame.origin.y+frame.size.height+5, frame.size.width - 10, 20)];
    [contentLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [contentLabel setLineBreakMode:NSLineBreakByCharWrapping];
    [contentLabel setNumberOfLines:0];
    [contentLabel setBackgroundColor:[UIColor clearColor]];
    if (per == NO) {
        currJtype = 0;
        itemsTypes = @[@"请选择",@"色情",@"广告",@"反动",@"暴力",@"侵权",@"其他"];
        shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 102, 40)];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"share.png"] forState:UIControlStateNormal];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"share_f.png"] forState:UIControlStateHighlighted];
        [shareButton addTarget:self action:@selector(shareAct) forControlEvents:UIControlEventTouchUpInside];
        favButton = [[UIButton alloc] initWithFrame:CGRectMake(102, 0, 102, 40)];
        [favButton setBackgroundImage:[UIImage imageNamed:@"fav.png"] forState:UIControlStateNormal];
        [favButton setBackgroundImage:[UIImage imageNamed:@"fav_f.png"] forState:UIControlStateHighlighted];
        [favButton addTarget:self action:@selector(favAct) forControlEvents:UIControlEventTouchUpInside];
        jubaoButton = [[UIButton alloc] initWithFrame:CGRectMake(204, 0, 102, 40)];
        [jubaoButton setBackgroundImage:[UIImage imageNamed:@"jubao.png"] forState:UIControlStateNormal];
        [jubaoButton setBackgroundImage:[UIImage imageNamed:@"jubao_f.png"] forState:UIControlStateHighlighted];
        [jubaoButton addTarget:self action:@selector(juBaoaAct) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:favButton];
        [bgView addSubview:jubaoButton];
        [bgView addSubview:shareButton];
    }
    tagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tag.png"]];
    tagLabel = [[TagLabel alloc] initWithFrame:CGRectZero];
    [tagLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [tagLabel setTextColor:[UIColor whiteColor]];
    [tagLabel setBackgroundColor:UIColorFromRGB(0x95b0cb)];
    [tagLabel.layer setCornerRadius:5.0f];
    [bgView addSubview:tagLabel];
    [bgView addSubview:tagView];
    [bgView addSubview:fromName];
    [bgView addSubview:itemImage];
    [bgView addSubview:timeLabel];
    [bgView addSubview:contentLabel];
    if (canDelet) {
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
}

- (void)shareAct
{
    id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@http://218.244.137.199/lostandfound/index.php/index/show?id=%@",_item.content,_item.lid]
                                       defaultContent:@"欢迎下载Go校园"
                                                image:nil
                                                title:@"我分享了一条来自湘潭大学失物招领的帖子，快来看看吧"
                                                  url:[NSString stringWithFormat:@"http://218.244.137.199/community/index.php/index/show?id=%@",_item.lid]
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
    [postDic setObject:_item.lid forKey:@"lid"];
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
    [req setProgressBlock:^(float curr){
        
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:url]];
}

- (void)finishLoadData
{
    [MBProgressHUD showMsg:self.window title:@"非常感谢你的举报" delay:2];
}

- (void)failedLoadData
{
    [MBProgressHUD showMsg:self.window title:@"举报失败，请检查网络" delay:2];
}

- (void)deleteAct
{
    if (_delActionBlock != nil) {
        _delActionBlock(_indexPath);
    }
    if (_delPreActionBlock != nil) {
        _delPreActionBlock(_indexPath,_item.lid);
    }
}

-(void)cellPanGes:(UIPanGestureRecognizer *)panGes{
    CGPoint pointer = [panGes locationInView:self.contentView];
    if (panGes.state == UIGestureRecognizerStateBegan) {
        startX = pointer.x;
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        CGPoint p = [panGes locationInView:self];
        CGRect f = self.contentView.frame;
        f.origin.x = p.x - startX;
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

- (void)favAct
{
    NSDictionary *dic = [_item getDicOfItem];
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favl"];
    NSArray *idArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"favlid"];
    for (NSString *str in idArr) {
        if ([str isEqualToString:_item.lid]) {
            [MBProgressHUD showMsg:self.window title:@"你已经收藏过这条信息了" delay:2];
            return;
        }
    }
    NSMutableArray *tmpArr = [[NSMutableArray alloc] initWithArray:arr];
    NSMutableArray *tmpArrId = [[NSMutableArray alloc] initWithArray:idArr];
    [tmpArr addObject:dic];
    [tmpArrId addObject:_item.lid];
    [[NSUserDefaults standardUserDefaults] setObject:tmpArr forKey:@"favl"];
    [[NSUserDefaults standardUserDefaults] setObject:tmpArrId forKey:@"favlid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [MBProgressHUD showMsg:self.window title:@"收藏成功" delay:2];
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

- (void)callPhone
{
    NSString *telUrl = [NSString stringWithFormat:@"telprompt:%@",_item.phone];
    NSURL *url = [[NSURL alloc] initWithString:telUrl];
    [[UIApplication sharedApplication] openURL:url];
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
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/lostandfound/Public/Uploads/%@", _item.pic];
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

+ (CGFloat)cellHeightForItem:(LostItem *)item isPer:(BOOL)per
{
    CGFloat h = 0.0;
    h += 46;
    if (![item.pic isEqualToString:@""]) {
        h += 235;
    }
    CGSize labelSize = [item.content sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]
                       constrainedToSize:CGSizeMake(kScreenWidth - 20, 1000)
                           lineBreakMode:NSLineBreakByCharWrapping];   // str是要显示的字符串
    h += labelSize.height + 10 + 45 + 22;
    if (per) {
        h -= 40;
    }
    return h;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat h = [LostItemCell cellHeightForItem:_item isPer:isPer];
    if (canDelet) {
        [deleteButton setAlpha:0.0f];
        [deleteButton setCenter:CGPointMake(kScreenWidth - 35, h/2.0)];
    }
    CGRect frame = bgView.frame;
    frame.size.height = h - 5;
    if (![_item.userthumb isEqualToString:@"empty"]) {
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/community/Public/Uploads/%@", _item.userthumb];
        [fromImage sd_setImageWithURL:[NSURL URLWithString:url]];
    }else
    {
        [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    }
    [timeLabel setText:[self getTime:_item.time]];
    [bgView setFrame:frame];
    if ([_item.from isEqualToString:@"-1"]) {
        fromName.text =  @"匿名用户";
        [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    }else{
        fromName.text = _item.from;
    }
    contentLabel.text =  _item.content;
    if (![_item.pic isEqualToString:@""]) {
        [itemImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://218.244.137.199/lostandfound/Public/Uploads/%@", _item.thumbpic]]];
        CGRect frame =  contentLabel.frame;
        frame.origin.y =  286;
        CGSize labelSize = [_item.content sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]
                                    constrainedToSize:CGSizeMake(kScreenWidth - 20, 1000)
                                        lineBreakMode:NSLineBreakByCharWrapping];
        frame.size.height = labelSize.height;
        [contentLabel setFrame:frame];
        [itemImage setHidden:NO];
    }else{
        CGRect frame =  contentLabel.frame;
        frame.origin.y =  51;
        CGSize labelSize = [_item.content sizeWithFont:[UIFont boldSystemFontOfSize:16.0f]
                                     constrainedToSize:CGSizeMake(kScreenWidth - 20, 1000)
                                         lineBreakMode:NSLineBreakByCharWrapping];
        frame.size.height = labelSize.height;
        [contentLabel setFrame:frame];
        [itemImage setHidden:YES];
    }
    CGRect btnFrame = contentLabel.frame;
    [tagView setFrame:CGRectMake(5, btnFrame.origin.y + btnFrame.size.height + 8 , 13, 13)];
    [tagLabel setText:_item.typeT];
    NSInteger len = tagLabel.text.length;
    [tagLabel setFrame:CGRectMake(22, btnFrame.origin.y + btnFrame.size.height + 5, len*13+4, 18)];
    if (isPer == NO) {
        CGFloat y = btnFrame.origin.y + btnFrame.size.height + 5 + 22;
        [shareButton setY:y];
        [favButton setY:y];
        [jubaoButton setY:y];
    }

}

- (NSString *)getTime:(NSString *)time
{
    NSInteger cTime = time.integerValue;
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    NSInteger tdelt = curTime - cTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:cTime];
    if (tdelt < 60) {
        return @"刚刚";
    } else if (tdelt < 3600){
        return [NSString stringWithFormat:@"%d分钟前",tdelt/60];
    } else if (tdelt < 3600 * 24){
        return [NSString stringWithFormat:@"%d小时前",tdelt/3600];
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
