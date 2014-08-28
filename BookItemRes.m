//
//  BookItemRes.m
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//
/*
 
 */
/*
 [dic objectForKey:@"searchid"
 [dic objectForKey:@"name"
 [dic objectForKey:@"author"
 [dic objectForKey:@"publisher"
 [dic objectForKey:@"isbn"
 [dic objectForKey:@"pubtime"
 [dic objectForKey:@"sid"
 [dic objectForKey:@"currstatus"
 */
#import "BookItemRes.h"

@implementation BookItemRes

- (void)setDic:(NSDictionary *)dic
{
    _searchid = [dic objectForKey:@"searchid"];
    NSString *nStr = [dic objectForKey:@"name"];
    _name = [nStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    NSString *aStr = [dic objectForKey:@"author"];
    _author = [aStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    NSString *pStr = [dic objectForKey:@"publisher"];
    _publisher = [pStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    NSString *iStr = [dic objectForKey:@"isbn"];
    _isbn = [iStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    NSString *puStr = [dic objectForKey:@"pubtime"];
    _pubtime = [puStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    NSString *sStr = [dic objectForKey:@"sid"];
    _sid = [sStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    NSString *cStr = [dic objectForKey:@"currstatus"];
    _currstatus = [cStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
}
- (NSDictionary *)getDic
{
    return dataDic;
}

@end
