//
//  XxyHttpRequest.h
//  BestvSoccer
//
//  Created by Apple on 14-6-16.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^FinishLoadBlock)(NSData *);
typedef void(^FailedBlock)(NSError *);
typedef void(^ProgressBlock)(float);

@interface XxyHttpRequest : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    NSMutableData *resData;
    NSURLConnection *connection;
    NSMutableURLRequest *request;
    NSInteger dataTotalSize;
    NSMutableArray *fileArr;
    NSMutableArray *keyArr;
    NSDictionary *postDataDic;
}

@property (nonatomic, strong)FinishLoadBlock finishBlock;
@property (nonatomic, strong)FailedBlock failedBlock;
@property (nonatomic, strong)ProgressBlock progressBlock;

- (void)startAsyncWithUrl:(NSURL *)url;
- (void)setFile:(UIImage *)img forKey:(NSString *)key;
- (void)setPostDataDic:(NSDictionary *)dic;

@end
