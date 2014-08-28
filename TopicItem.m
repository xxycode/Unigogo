//
//  TopicItem.m
//  Unigogo
//
//  Created by xxy on 14-7-7.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "TopicItem.h"

@implementation TopicItem

- (void)setDic:(NSDictionary *)dic
{
    dataDic = dic;
    _addtime = [dic objectForKey:@"addtime"];
    _content = [dic objectForKey:@"content"];
    _from = [dic objectForKey:@"from"];
    _hid = [dic objectForKey:@"hid"];
    _tid = [dic objectForKey:@"id"];
    _numcomment = [dic objectForKey:@"numcomment"];
    _numhot = [dic objectForKey:@"numhot"];
    _numshare = [dic objectForKey:@"numshare"];
    _numzan = [dic objectForKey:@"numzan"];
    _pic_url = [dic objectForKey:@"pic_url"];
    _tag = [dic objectForKey:@"tag"];
    _thumbpic_url = [dic objectForKey:@"thumbpic_url"];
    _uid = [dic objectForKey:@"uid"];
    _userpic = [dic objectForKey:@"userpic"];
    _userthumb = [dic objectForKey:@"userthumb"];
    NSString *canZan = [dic objectForKey:@"zanable"];
    if ([canZan isEqual:@"1"]) {
        _zanAble = YES;
    }else{
        _zanAble = NO;
    }
}
- (NSDictionary *)getDicOfItem
{
    return dataDic;
}

@end
