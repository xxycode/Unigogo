//
//  MapViewController.h
//  Unigogo
//
//  Created by xxy on 14-7-16.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "PubViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "NYSegmentedControl.h"
#import "MBProgressHUD.h"
#import "MyAnnotationView.h"

@interface MapViewController : PubViewController<MAMapViewDelegate,UISearchBarDelegate>
{
    MyAnnotationView *detailView;
    MAMapView *_mapView;
    UIView *bottomView;
    NSMutableArray *annotations;
    MAPolyline *polyline;
    NYSegmentedControl *instagramSegmentedControl;
    MBProgressHUD *HUD;
    UISearchBar *searchBar;
    UIView *btnHide;
    NSString *currPid;
    NSString *currName;
}
@end
