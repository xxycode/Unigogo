//
//  CommentItem.h
//  Unigogo
//
//  Created by xxy on 14-7-9.
//  Copyright (c) 2014年 xxy. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface CommentItem : NSObject
{
    NSDictionary *dataDic;
}

@property (nonatomic, strong) NSString *cid;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *recontent;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *addtime;
@property (nonatomic, strong) NSString *delable;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *thumbPic;

- (void)setDic:(NSDictionary *)dic;
- (NSDictionary*)getDic;

@end
