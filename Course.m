//
//  Course.m
//  Unigogo
//
//  Created by xxy on 14-6-24.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "Course.h"

@implementation Course

- (void)setDic:(NSDictionary *)dic
{
    _address = [dic objectForKey:@"address"];
    _name = [dic objectForKey:@"name"];
    NSString *sequenceTmp = [dic objectForKey:@"sequence"];
    if ([sequenceTmp isEqualToString:@"一二"]){
        _sequence = @"1";
    }else if([sequenceTmp isEqualToString:@"三四"]){
        _sequence = @"2";
    }else if([sequenceTmp isEqualToString:@"五六"]){
        _sequence = @"3";
    }else if([sequenceTmp isEqualToString:@"七八"]){
        _sequence = @"4";
    }else{
        _sequence = @"5";
    }
    _teacher = [dic objectForKey:@"teacher"];
    _length = 2;
    _time = [dic objectForKey:@"time"];
    if ([[_time substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"("]) {
        NSString *len = [_time substringWithRange:NSMakeRange(1, 1)];
        _length = len.integerValue;
    }
    NSString *weekTmp = [dic objectForKey:@"week"];
    _week = [weekTmp substringWithRange:NSMakeRange(4, 1)];
}

@end
