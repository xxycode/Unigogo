//
//  config.h
//  Unigogo
//
//  Created by Apple on 14-6-15.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#ifndef Unigogo_config_h
#define Unigogo_config_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kVersion [UIDevice currentDevice].systemVersion.floatValue
#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define kHost @"http://218.244.137.199"
#define topicNof @"NewTopicNofic"
#define kCCache @"communityCache"
#define kLCache @"lostandfoundeCache"
#define kNCache @"newStdCache"
#define kSVersion @"1.0"

#endif
