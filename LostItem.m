//
//  LostItem.m
//  Unigogo
//
//  Created by xxy on 14-6-25.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "LostItem.h"

@implementation LostItem


- (void)setDic:(NSDictionary *)dic
{
    dataDic = dic;
    NSArray *type = @[@"电子数码",@"书本",@"文体用品",@"证件及卡",@"服装及包",@"钥匙",@"其他"];
    _content = [dic objectForKey:@"content"];
    _from = [dic objectForKey:@"from"];
    _lid = [dic objectForKey:@"id"];
    _pic = [dic objectForKey:@"pic"];
    _thumbpic = [dic objectForKey:@"thumbpic"];
    _phone = [dic objectForKey:@"tel"];
    _time = [dic objectForKey:@"time"];
    NSString *str = [dic objectForKey:@"type"];
    _type = [str integerValue];
    _typeT = [type objectAtIndex:_type - 1];
    _userpic = [dic objectForKey:@"userpic"];
    _userthumb = [dic objectForKey:@"userthumb"];
}

- (NSDictionary *)getDicOfItem
{
    return dataDic;
}

@end
