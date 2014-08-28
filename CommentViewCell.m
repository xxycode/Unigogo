//
//  CommentViewCell.m
//  Unigogo
//
//  Created by xxy on 14-7-9.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "CommentViewCell.h"
#import "UIButton+setFrame.h"

@implementation CommentViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self setBackgroundColor:[UIColor clearColor]];
    fromImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 36, 36)];
    bgView = [[UIView alloc] initWithFrame:CGRectMake(7, 5, kScreenWidth - 14, 300)];
    [bgView.layer setBorderWidth:1.0f];
    [bgView.layer setBorderColor:UIColorFromRGB(0xcccccc).CGColor];
    [fromImage.layer setMasksToBounds:YES];
    //[fromImage.layer setCornerRadius:18.0f];
    [bgView addSubview:fromImage];
    [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    [bgView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.8]];
    fromName = [[UILabel alloc] initWithFrame:CGRectMake(46, 5, 200, 20)];
    [fromName setBackgroundColor:[UIColor clearColor]];
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(46, 25, 120, 20)];
    [timeLabel setTextColor:UIColorFromRGB(0x99cc00)];
    [timeLabel setBackgroundColor:[UIColor clearColor]];
    [timeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    contentTextView = [[TQRichTextView alloc] initWithFrame:CGRectMake(5, 46, kScreenWidth - 14 - 10, 20)];
    [contentTextView setFont:[UIFont systemFontOfSize:17.0f]];
    [contentTextView setBackgroundColor:[UIColor clearColor]];
    rcontentTextView = [[TQRichTextView alloc] initWithFrame:CGRectMake(45, 46, kScreenWidth - 14 - 10 - 40, 20)];
    [rcontentTextView setFont:[UIFont systemFontOfSize:17.0f]];
    [rcontentTextView setBackgroundColor:[UIColor clearColor]];
    //[rcontentTextView setBackgroundColor:UIColorFromRGB(0xcecece)];
    repSlideView = [[UIView alloc] initWithFrame:CGRectMake(40, 51, 2, 20)];
    [repSlideView setBackgroundColor:UIColorFromRGB(0x99cc00)];
    
    delBtn = [[UIButton alloc] initWithFrame:CGRectMake(295 - 27 - 37, 10, 27, 20)];
    [delBtn setImage:[UIImage imageNamed:@"comDel.png"] forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delAct) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:delBtn];
    
    UIButton *repBtn = [[UIButton alloc] initWithFrame:CGRectMake(295 - 27, 10, 27, 20)];
    [repBtn setImage:[UIImage imageNamed:@"reply.png"] forState:UIControlStateNormal];
    [repBtn addTarget:self action:@selector(replyAct) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:repBtn];
    
    [self addSubview:bgView];
    [bgView addSubview:repSlideView];
    [bgView addSubview:fromImage];
    [bgView addSubview:fromName];
    [bgView addSubview:timeLabel];
    [bgView addSubview:contentTextView];
    [bgView addSubview:rcontentTextView];
}

- (void)replyAct
{
    if (_repBlock) {
        _repBlock(_item.cid);
    }
}

- (void)delAct
{
    if (_delBock) {
        _delBock(_item.cid);
    }
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    CGFloat h = [CommentViewCell getHeighWithItem:_item];
    CGRect frame = bgView.frame;
    frame.size.height = h - 6;
    if (![_item.thumbPic isKindOfClass:[NSNull class]]) {
        if (![_item.thumbPic isEqualToString:@"empty"]) {
            NSString *url = [NSString stringWithFormat:@"http://218.244.137.199/community/Public/Uploads/%@", _item.thumbPic];
            [fromImage sd_setImageWithURL:[NSURL URLWithString:url]];
        }
    }else{
        [fromImage setImage:[UIImage imageNamed:@"defuser.png"]];
    }
    [timeLabel setText:[self getTime:_item.addtime]];
    [bgView setFrame:frame];
    fromName.text = _item.nickname;
    if (_item.recontent != nil && _item.recontent.length > 0) {
        NSString *st = [_item.recontent stringByReplacingOccurrencesOfString:@"]" withString:@""];
        CGSize labelSize = [st sizeWithFont:[UIFont boldSystemFontOfSize:17.2f]
                          constrainedToSize:CGSizeMake(kScreenWidth - 65, 1000)
                              lineBreakMode:NSLineBreakByCharWrapping];
        [rcontentTextView setHidden:NO];
        CGRect f = rcontentTextView.frame;
        f.origin.y = 46 + 5;
        f.size.height = labelSize.height + 5;
        [rcontentTextView setFrame:f];
        [rcontentTextView setText:[NSString stringWithFormat:@"回复 %@",_item.recontent]];
        [contentTextView setText:_item.content];
        NSString *str = [_item.content stringByReplacingOccurrencesOfString:@"]" withString:@""];
        CGSize labSize = [str sizeWithFont:[UIFont boldSystemFontOfSize:17.f]
                          constrainedToSize:CGSizeMake(kScreenWidth - 24, 1000)
                              lineBreakMode:NSLineBreakByCharWrapping];
        frame.size.height = labSize.height+10;
        [contentTextView setFrame:CGRectMake(5, rcontentTextView.getBottom, kScreenWidth - 14 - 10, labSize.height)];
        [repSlideView setHeight:rcontentTextView.frame.size.height-5];
        [repSlideView setHidden:NO];
    }else{
        [repSlideView setHidden:YES];
        [rcontentTextView setHidden:YES];
        contentTextView.text =  _item.content;
        [contentTextView setText:_item.content];
        NSString *st = [_item.content stringByReplacingOccurrencesOfString:@"]" withString:@""];
        CGSize labelSize = [st sizeWithFont:[UIFont boldSystemFontOfSize:17.f]
                          constrainedToSize:CGSizeMake(kScreenWidth - 24, 1000)
                              lineBreakMode:NSLineBreakByCharWrapping];
        frame.size.height = labelSize.height+10;
        [contentTextView setFrame:CGRectMake(5, 46, kScreenWidth - 14 - 10, labelSize.height)];
    }
    if ([_item.delable isEqualToString:@"1"]) {
        [delBtn setHidden:NO];
    }else{
        [delBtn setHidden:YES];
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

+ (CGFloat)getHeighWithItem:(CommentItem *)item
{
    CGFloat h = 0;
    h += 46;
    NSString *st = [item.content stringByReplacingOccurrencesOfString:@"]" withString:@""];
    CGSize labelSize = [st sizeWithFont:[UIFont boldSystemFontOfSize:16.5f]
                      constrainedToSize:CGSizeMake(kScreenWidth - 24, 1000)
                          lineBreakMode:NSLineBreakByCharWrapping];   // str是要显示的字符串
    h += labelSize.height + 15;
    if (item.recontent != nil && item.recontent.length > 0) {
        NSString *st = [item.recontent stringByReplacingOccurrencesOfString:@"]" withString:@""];
        CGSize labelSize = [st sizeWithFont:[UIFont boldSystemFontOfSize:17.0f]
                          constrainedToSize:CGSizeMake(kScreenWidth - 64, 1000)
                              lineBreakMode:NSLineBreakByCharWrapping];
        h += labelSize.height + 15;
        
    }
    return h;
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
