//
//  MyAnnotationView.h
//  Unigogo
//
//  Created by xxy on 14-7-29.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
typedef void(^ShowNdet)(void);

@interface MyAnnotationView : MAAnnotationView
{
    UILabel *titView;
    UIButton *deBtn;
}

@property(nonatomic, strong) NSString *title;

@property(nonatomic, strong) ShowNdet showNdet;

@end
