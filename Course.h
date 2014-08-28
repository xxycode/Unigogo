//
//  Course.h
//  Unigogo
//
//  Created by xxy on 14-6-24.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Course : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sequence;
@property (nonatomic, strong) NSString *teacher;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *week;
@property (nonatomic, assign) NSInteger length;

- (void)setDic:(NSDictionary *)dic;

@end
