//
//  BookItemRes.h
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
/*
 searchid: 0100754459,
 name: PHP & MySQL实战手册&nbsp;,
 author: 麦克劳克林胡乔林,甘亮,陈洁&nbsp;,
 publisher: 中国电力出版社&nbsp;,
 isbn: 978-7-5123-5239-1&nbsp;,
 pubtime: 2014&nbsp;,
 sid: TP312PH/102/2=1&nbsp;,
 currstatus: 馆藏数：2&nbsp;可借数：2&nbsp;
 */

#import <Foundation/Foundation.h>

@interface BookItemRes : NSObject
{
    NSDictionary *dataDic;
}

@property (nonatomic, strong) NSString *searchid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *publisher;
@property (nonatomic, strong) NSString *isbn;
@property (nonatomic, strong) NSString *pubtime;
@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *currstatus;

- (void)setDic:(NSDictionary *)dic;
- (NSDictionary *)getDic;

@end
