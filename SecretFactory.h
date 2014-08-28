//
//  SecretFactory.h
//  Unigogo
//
//  Created by xxy on 14-6-27.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecretFactory : NSObject
+ (NSString *)getCurrentSecretKey;
+ (NSString *) md5:(NSString *)str;
@end
