//
//  TopicView.m
//  Unigogo
//
//  Created by xxy on 14-7-9.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "TopicView.h"

@implementation TopicView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    bgView = [[UIView alloc] initWithFrame:CGRectMake(7, 5, kScreenWidth - 14, 300)];
    [bgView.layer setBorderWidth:1.0f];
    [bgView.layer setBorderColor:UIColorFromRGB(0xcccccc).CGColor];
    [bgView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8]];
    fromImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 36, 36)];
    [fromImage.layer setMasksToBounds:YES];
    [fromImage.layer setCornerRadius:18.0f];
    [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
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
    [bgView addSubview:tagLabel];
    [bgView addSubview:tagView];
    [bgView addSubview:timeLabel];
    [bgView addSubview:itemImage];
    [bgView addSubview:fromName];
    [bgView addSubview:contentTextView];
    [bgView addSubview:fromImage];
    [self addSubview:bgView];
}


- (void)doubleTap
{
    if (scView.zoomScale != 1.0f) {
        [scView setZoomScale:1 animated:YES];
    }else{
        [scView setZoomScale:2.0f animated:YES];
    }
}
- (void)saveAct
{
    UIImageWriteToSavedPhotosAlbum(imgV.image, nil, nil, nil);
    [MBProgressHUD showMsg:self.window title:@"保存图片成功" delay:1.75];
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


- (void)setItem:(TopicItem *)item
{
    _item = item;
    CGFloat h = 0.0;
    h += 46;
    if (![item.pic_url isEqualToString:@""]) {
        h += 235;
    }
    NSString *st = [item.content stringByReplacingOccurrencesOfString:@"]" withString:@""];
    CGSize labelSize = [st sizeWithFont:[UIFont boldSystemFontOfSize:16.5f]
                      constrainedToSize:CGSizeMake(kScreenWidth - 20, 1000)
                          lineBreakMode:NSLineBreakByCharWrapping];   // str是要显示的字符串
    h += labelSize.height + 20 + 27;
    if (item.tag.length == 0) {
        h -= 20;
    }
    CGRect f = self.frame;
    f.size.height = h;
    [self setFrame:f];
    [bgView setFrame:CGRectMake(7, 5, kScreenWidth - 14, h - 10)];
    if (![_item.thumbpic_url isEqualToString:@"empty"]) {
        NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/community/Public/Uploads/%@", _item.userthumb];
        [fromImage sd_setImageWithURL:[NSURL URLWithString:url]];
    }else
    {
        [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    }
    [timeLabel setText:[self getTime:_item.addtime]];
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
        frame.size.height = labelSize.height+5;
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
}

- (NSString *)getTime:(NSString *)time
{
    NSInteger cTime = time.integerValue;
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
    NSInteger delt = curTime - cTime;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:cTime];
    if (delt < 60) {
        return @"刚刚";
    } else if (delt < 3600){
        return [NSString stringWithFormat:@"%d分钟前",delt/60];
    } else if (delt < 3600 * 24){
        return [NSString stringWithFormat:@"%d小时前",delt/3600];
    } else{
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日"];
        NSString * s = [dateFormatter stringFromDate:date];
        return s;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
