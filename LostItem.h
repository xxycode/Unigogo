//
//  LostItem.h
//  Unigogo
//
//  Created by xxy on 14-6-25.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LostItem : NSObject
{
    NSDictionary *dataDic;
}

@property (nonatomic ,strong ) NSString *content;
@property (nonatomic ,strong ) NSString *from;
@property (nonatomic ,strong ) NSString *lid;
@property (nonatomic ,strong ) NSString *pic;
@property (nonatomic ,strong ) NSString *thumbpic;
@property (nonatomic ,strong ) NSString *time;
@property (nonatomic ,strong ) NSString *phone;
@property (nonatomic ,assign ) NSInteger type;
@property (nonatomic ,strong ) NSString *userpic;
@property (nonatomic ,strong ) NSString *userthumb;
@property (nonatomic ,strong ) NSString *typeT;


- (void)setDic:(NSDictionary *)dic;
- (NSDictionary *)getDicOfItem;


@end
