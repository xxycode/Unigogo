//
//  UIImage+Resize.h
//  Unigogo
//
//  Created by xxy on 14-7-2.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;

@end
