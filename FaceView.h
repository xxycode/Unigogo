//
//  FaceView.h
//  Unigogo
//
//  Created by xxy on 14-7-6.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^faceItemClickBlock)(NSString *str);

@interface FaceView : UIScrollView
{
    UIImageView *faceTouchedView;
    NSArray *faceArr;
}

@property (nonatomic, strong) faceItemClickBlock clickBlock;

@end
