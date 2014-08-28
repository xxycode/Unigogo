//
//  LocationViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-13.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "BaseViewController.h"
#import "MRZoomScrollView.h"

@interface LocationViewController : BaseViewController<UIScrollViewDelegate>
{
    MRZoomScrollView *contentSCView;
    UIImageView *imageView;
    UIButton *backBtn;
}
@end
