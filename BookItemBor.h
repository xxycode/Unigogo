//
//  BookItemBor.h
//  Unigogo
//
//  Created by xxy on 14-7-14.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookItemBor : NSObject
{
    NSDictionary *dataDic;
}
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *barcode;
@property (nonatomic, strong) NSString *department;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *backtime;
@property (nonatomic, strong) NSString *departid;
@property (nonatomic, strong) NSString *type;

- (void)setDic:(NSDictionary *)dic;
- (NSDictionary *)getDic;

@end
