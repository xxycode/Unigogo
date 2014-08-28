//
//  GradeItem.h
//  Unigogo
//
//  Created by xxy on 14-7-4.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GradeItem : NSObject

@property (nonatomic ,strong) NSString *qpScore;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,assign) NSInteger credit;
@property (nonatomic ,strong) NSString *type;
@property (nonatomic ,strong) NSString *ksScore;
@property (nonatomic ,assign) NSInteger psScore;
@property (nonatomic ,assign) NSInteger semester;

- (void)setDic:(NSDictionary *)dic;

@end
