//
//  FaceContentView.h
//  Unigogo
//
//  Created by xxy on 14-7-6.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceView.h"

@interface FaceContentView : UIView<UIScrollViewDelegate>

@property (nonatomic, strong)UIPageControl *pageCotrol;
@property (nonatomic, strong)FaceView *faceView;

@end
