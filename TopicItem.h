//
//  TopicItem.h
//  Unigogo
//
//  Created by xxy on 14-7-7.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicItem : NSObject
{
    NSDictionary *dataDic;
}

@property (nonatomic ,strong ) NSString *content;
@property (nonatomic ,strong ) NSString *from;
@property (nonatomic ,strong ) NSString *hid;
@property (nonatomic ,strong ) NSString *pic;
@property (nonatomic ,strong ) NSString *addtime;
@property (nonatomic ,strong ) NSString *tid;
@property (nonatomic ,strong ) NSString *pic_url;
@property (nonatomic ,strong ) NSString *tag;
@property (nonatomic ,strong ) NSString *thumbpic_url;
@property (nonatomic ,strong ) NSString *numcomment;
@property (nonatomic ,strong ) NSString *numhot;
@property (nonatomic ,strong ) NSString *numshare;
@property (nonatomic ,strong ) NSString *numzan;
@property (nonatomic ,strong ) NSString *uid;
@property (nonatomic ,strong ) NSString *userpic;
@property (nonatomic ,strong ) NSString *userthumb;
@property (nonatomic ,assign ) BOOL zanAble;


- (void)setDic:(NSDictionary *)dic;
- (NSDictionary *)getDicOfItem;

@end
