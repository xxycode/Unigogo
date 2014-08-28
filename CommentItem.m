//
//  CommentItem.m
//  Unigogo
//
//  Created by xxy on 14-7-9.
//  Copyright (c) 2014年 xxy. All rights reserved.
//
/**
 "id": "1",
 "content": "内容是哈哈哈哈哈哈",
 "recontent": "",
 "rid": "0",
 "tid": "2",
 "uid": "0",
 "addtime": "1397011536",
 "delable": "0"
 "nickname": "我是大魔王",
 "userpic": "5344236ab3b66.jpg",
 "userthumb": "thumb_5344236ab3b66.jpg",
 */


#import "CommentItem.h"

@implementation CommentItem

- (void)setDic:(NSDictionary *)dic
{
    dataDic = dic;
    _cid = [dic objectForKey:@"id"];
    _content = [dic objectForKey:@"content"];
    _recontent = [dic objectForKey:@"recontent"];
    _rid = [dic objectForKey:@"rid"];
    _tid = [dic objectForKey:@"tid"];
    _uid = [dic objectForKey:@"uid"];
    _addtime = [dic objectForKey:@"addtime"];
    _delable = [dic objectForKey:@"delable"];
    _nickname = [dic objectForKey:@"nickname"];
    _thumbPic = [dic objectForKey:@"userthumb"];
}

- (NSDictionary*)getDic
{
    return dataDic;
}

@end
