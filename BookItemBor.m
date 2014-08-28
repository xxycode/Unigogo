//
//  BookItemBor.m
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BookItemBor.h"

@implementation BookItemBor

- (void)setDic:(NSDictionary *)dic
{
    dataDic = dic;
    NSString *name = [dic objectForKey:@"name"];
    _name = [name stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    _barcode = [dic objectForKey:@"barcode"];
    _department = [dic objectForKey:@"department"];
    NSString *time = [dic objectForKey:@"backtime"];
    _backtime = [time stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    _departid = [dic objectForKey:@"departid"];
    _type = [dic objectForKey:@"type"];
}

- (NSDictionary *)getDic
{
    return dataDic;
}

@end
