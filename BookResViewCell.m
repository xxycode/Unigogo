//
//  BookResViewCell.m
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BookResViewCell.h"

@implementation BookResViewCell

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
    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, kScreenWidth - 10, 20)];
    [nameLabel setFont:[UIFont systemFontOfSize:15.f]];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    
    authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 23, 150, 18)];
    [authorLabel setFont:[UIFont systemFontOfSize:13.f]];
    [authorLabel setBackgroundColor:[UIColor clearColor]];
    
    publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 23, 150, 18)];
    [publisherLabel setFont:[UIFont systemFontOfSize:13.f]];
    [publisherLabel setBackgroundColor:[UIColor clearColor]];
    
    isbnLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 40, 150, 18)];
    [isbnLabel setFont:[UIFont systemFontOfSize:13.f]];
    [isbnLabel setBackgroundColor:[UIColor clearColor]];
    
    pubtimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 40, 150, 18)];
    [pubtimeLabel setFont:[UIFont systemFontOfSize:13.f]];
    [pubtimeLabel setBackgroundColor:[UIColor clearColor]];
    
    sidLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 150, 18)];
    [sidLabel setFont:[UIFont systemFontOfSize:13.f]];
    [sidLabel setBackgroundColor:[UIColor clearColor]];
    
    currStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(155, 55, 150, 18)];
    [currStatusLabel setFont:[UIFont systemFontOfSize:13.f]];
    [currStatusLabel setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:nameLabel];
    [self addSubview:authorLabel];
    [self addSubview:publisherLabel];
    [self addSubview:isbnLabel];
    [self addSubview:pubtimeLabel];
    [self addSubview:sidLabel];
    [self addSubview:currStatusLabel];
}

- (void)layoutSubviews
{
    [nameLabel setText:_item.name];
    [authorLabel setText:[NSString stringWithFormat:@"作者:%@",_item.author]];
    [publisherLabel setText:[NSString stringWithFormat:@"出版社:%@",_item.publisher]];
    [isbnLabel setText:[NSString stringWithFormat:@"ISBN:%@",_item.isbn]];
    [pubtimeLabel setText:[NSString stringWithFormat:@"出版年份:%@",_item.pubtime]];
    [sidLabel setText:[NSString stringWithFormat:@"索书号:%@",_item.sid]];
    [currStatusLabel setText:_item.currstatus];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetRGBStrokeColor(context, 115, 115, 115, 0.5);
    const CGFloat f[] = {0.1372, 0.1372, 0.1372, 0.5};
    CGContextSetStrokeColor(context, f);
    CGContextMoveToPoint(context, 0, 74);
    CGContextAddLineToPoint(context, kScreenWidth, 74);
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
