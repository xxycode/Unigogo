//
//  GradeItem.m
//  Unigogo
//
//  Created by xxy on 14-7-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "GradeItem.h"

@implementation GradeItem

- (void)setDic:(NSDictionary *)dic
{
    _qpScore = [dic objectForKey:@"qpScore"];
    _name = [dic objectForKey:@"name"];
    NSString *cr = [dic objectForKey:@"credit"];
    _credit = [cr integerValue];
    _type = [dic objectForKey:@"type"];
    _ksScore = [dic objectForKey:@"ksScore"];
    NSString *ps = [dic objectForKey:@"psScore"];
    _psScore = [ps integerValue];
    NSString *se = [dic objectForKey:@"semester"];
    _semester = [se integerValue];
}

@end
