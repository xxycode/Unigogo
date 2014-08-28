//
//  MapViewController.m
//  Unigogo
//
//  Created by xxy on 14-7-16.
//  Copyright (c) 2014年 xxy. All rights reserved.
//

#import "MapViewController.h"
#import "UIImage+ImageEffects.h"
#import "XxyHttpRequest.h"
#import "NearButton.h"
#import "UIButton+setFrame.h"
#import "MyPointAnnotation.h"
#import "MapDetailViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
       // @"http://yuntuapi.amap.com/datasearch/around?key=11496020d1641fca77dbeed9385ff8b8&limit=30&center=112.863439,27.879213&radius=4000&tableid=53c4e294e4b0dd06e5927061&keywords=%E5%8C%97%E5%B1%B1%E9%98%B6%E6%A2%AF%E6%95%99%E5%AE%A4&page=1"
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"湘大地图"];
    [self initMapView];
    // Do any additional setup after loading the view.
}


- (void)initMapView
{
    //27.8893710000,112.8724950000
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, navBarH, kScreenWidth, 44)];
    [self.view addSubview:searchBar];
    if (kVersion < 7.0) {
        [[searchBar.subviews objectAtIndex:0] removeFromSuperview];
    }
    [searchBar setPlaceholder:@"请输入关键字"];
    [searchBar setDelegate:self];
    btnHide = [[UIView alloc] initWithFrame:CGRectMake(0, navBarH + 44, kScreenWidth, kScreenHeight - 64 - 44)];
    [btnHide setBackgroundColor:[UIColor blackColor]];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [btnHide addGestureRecognizer:tapGR];
    //[searchBar setInputAccessoryView:btnHide];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(27.87963539, 112.86243081);
    [MAMapServices sharedServices].apiKey =@"acf18afaf5dfa43e12002d79cb0d8695";
    _mapView=[[MAMapView alloc] initWithFrame:CGRectMake(0, navBarH + 44, kScreenWidth, kScreenHeight - 64 - 44)];
    CGPoint p = _mapView.logoCenter;
    [_mapView setLogoCenter:CGPointMake(p.x, p.y - 40)];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, MACoordinateSpanMake(0.02, 0.02));
    [_mapView setRegion:region];
    [_mapView setZoomLevel:17 animated:YES];
    
    UIButton *nearButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 65, 5+(navBarH - 44), 60, 34)];
    [nearButton setBackgroundImage:[UIImage imageNamed:@"nearBtn.png"] forState:UIControlStateNormal];
    [nearButton setBackgroundImage:[UIImage imageNamed:@"nearBtn_f.png"] forState:UIControlStateHighlighted];
    [nearButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:nearButton];
    
    [self.view addSubview:_mapView];
    [self initToolView];
    [self initAnnotations];
}

- (void)hideKeyboard
{
    [searchBar resignFirstResponder];
    [UIView animateWithDuration:0.35 animations:^{
        [btnHide setAlpha:0];
        [self.view setY:0];
        [self.navView setY:0];
    } completion:^(BOOL cmp){
        [btnHide removeFromSuperview];
    }];
}

- (void)initToolView
{
    CGFloat delt = kVersion >= 7.0? 40:60;
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - delt, kScreenWidth, 40)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:36/255.0 green:41/255.0 blue:44/255.0 alpha:0.6]];
    instagramSegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"标准", @"卫星",@"标准黑夜"]];
    instagramSegmentedControl.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    instagramSegmentedControl.segmentIndicatorBackgroundColor = [UIColor whiteColor];
    instagramSegmentedControl.segmentIndicatorInset = 0.0f;
    instagramSegmentedControl.titleTextColor = [UIColor lightGrayColor];
    instagramSegmentedControl.selectedTitleTextColor = [UIColor darkGrayColor];
    [instagramSegmentedControl sizeToFit];
    instagramSegmentedControl.center = CGPointMake(bottomView.center.x, 20.0f);
    [instagramSegmentedControl addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventValueChanged];
    [bottomView addSubview:instagramSegmentedControl];
    [self.view addSubview:bottomView];
}

- (void)segmentSelected:(NYSegmentedControl *)control
{
    NSInteger selectedIndex = control.selectedSegmentIndex;
    switch (selectedIndex) {
        case 0:
            [_mapView setMapType:MAMapTypeStandard];
            break;
        case 1:
            [_mapView setMapType:MAMapTypeSatellite];
            break;
        case 2:
            [_mapView setMapType:MAMapTypeStandardNight];
            break;
        default:
            break;
    }
}

- (void)showMenu:(UIButton *)sender
{
    [searchBar resignFirstResponder];
    UIView *bView = [[UIView alloc] initWithFrame:self.view.bounds];
    [bView setTag:245];
    [bView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBview)];
    [bView addGestureRecognizer:tapGR];
    CGRect rect =self.view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imagView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [imagView setBackgroundColor:[UIColor clearColor]];
    [imagView setUserInteractionEnabled:YES];
    [bView addSubview:imagView];
    [self.view addSubview:bView];
    [bView setAlpha:0.0f];
    if (kVersion >= 7.0) {
        UIImage *bimg = [img applyBlurWithRadius:5.0 tintColor:[UIColor colorWithWhite:1.0 alpha:0.5] saturationDeltaFactor:0.9 maskImage:img];
        [imagView setImage:bimg];
        [UIView animateWithDuration:0.35 animations:^{
            [bView setAlpha:1.0f];
        }];
    }else{
        [imagView setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.85]];
        [bView setBackgroundColor:[UIColor clearColor]];
        [UIView animateWithDuration:0.35 animations:^{
            [bView setAlpha:1];
        }];
    }
    [self showNearBtn];
}

- (void)showNearBtn
{
    UIView *bView = [self.view viewWithTag:245];
    NSArray *nearIcon = @[@"cantin.png",@"sushem.png",@"wc.png",@"yushi.png",@"office.png",@"jiaoxue.png",@"xiu.png",@"shangye.png"];
    NSArray *nearTit = @[@"食堂餐厅",@"公寓宿舍",@"卫生间",@"浴室澡堂",@"办公室学院",@"教学楼",@"休闲娱乐",@"商业区"];
    NSArray *keyWords = @[@"餐厅",@"公寓",@"卫生间",@"浴室",@"学院",@"教学楼",@"休闲区",@"商业区"];
    CGFloat curr_X = 27.5f;
    CGFloat curr_Y = (kScreenHeight - kScreenWidth) / 2 + 27.5f;
    CGFloat arr_Y[8];
    for (int i = 0; i < 8; i ++) {
        if (i % 3 == 0 && i > 0) {
            curr_X = 27.5;
            curr_Y += 27.5 + 70;
        }
        arr_Y[i] = curr_Y;
        NearButton *btn = [[NearButton alloc] initWithFrame:CGRectMake(curr_X, curr_Y, 70, 70)];
        [btn setImage:[UIImage imageNamed:[nearIcon objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setFont:[UIFont systemFontOfSize:12.f]];
        [btn setBottomTitle:[nearTit objectAtIndex:i]];
        [btn setTitleColor:[UIColor blackColor]];
        [btn setKeyWord:[keyWords objectAtIndex:i]];
        [btn addTarget:self action:@selector(nBtnAct:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTag:i + 2014];
        [bView addSubview:btn];
        curr_X += 27.5 + 70;
    }
}

- (void)nBtnAct:(NearButton *)sender
{
    [self dismissBview];
    [self loadAnnotationsWithKeyword:sender.keyWord];
}

- (void)loadAnnotationsWithKeyword:(NSString *)keyword
{
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD setLabelText:@"正在加载"];
    }
    [HUD show:YES];
    NSString *url = [NSString stringWithFormat:@"http://yuntuapi.amap.com/datasearch/around?key=11496020d1641fca77dbeed9385ff8b8&limit=50&center=112.863439,27.879213&radius=4000&tableid=53c4e294e4b0dd06e5927061&keywords=%@&page=1",keyword];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self showAnnotations:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoad];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (void)showAnnotations:(NSData *)data
{
    [HUD hide:YES];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *count = [dic objectForKey:@"count"];
    if ([count isEqualToString:@"0"]) {
        [MBProgressHUD showMsg:self.view title:@"没有找到相关信息" delay:1.5];
        return;
    }
    [_mapView removeAnnotations:annotations];
    NSArray *dataArr = [dic objectForKey:@"datas"];
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in dataArr) {
        NSString *location = [dic objectForKey:@"_location"];
        NSArray *loc = [location componentsSeparatedByString:@","];
        NSString *w = [loc objectAtIndex:1];
        NSString *j = [loc objectAtIndex:0];
        MyPointAnnotation *point = [[MyPointAnnotation alloc] init];
        [point setCoordinate:CLLocationCoordinate2DMake(w.floatValue, j.floatValue)];
        [point setTitle:[dic objectForKey:@"_name"]];
        [point setPid:[dic objectForKey:@"_id"]];
        [resArr addObject:point];
    }
    annotations = resArr;
    [_mapView addAnnotations:annotations];
    MyPointAnnotation *p = [annotations objectAtIndex:0];
    CLLocationCoordinate2D coordinate = p.coordinate;
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, MACoordinateSpanMake(0.02, 0.02));
    [_mapView setRegion:region];
    [_mapView setZoomLevel:17 animated:YES];
}

- (void)failedLoad
{
    [HUD hide:YES];
    [MBProgressHUD showMsg:self.view title:@"加载失败，请检查网络" delay:1.5];
}

- (void)dismissBview
{
    UIView *view = (UIView *)[self.view viewWithTag:245];
    [UIView animateWithDuration:0.35 animations:^{
        [view setAlpha:0.0f];
    } completion:^(BOOL com){
        [view removeFromSuperview];
    }];
}


- (void)initAnnotations
{
    annotations = [NSMutableArray array];
    //定义一个标注，放到annotations数组
    MyPointAnnotation *red = [[MyPointAnnotation alloc] init];
    red.coordinate = CLLocationCoordinate2DMake(27.87851632, 112.86307454);
    red.title  = @"湘潭大学迎新服务咨询总站";
    [red setPid:@"-1"];
    [annotations insertObject:red atIndex: 0];
    //定义第二个标注，放到annotations数组
    MyPointAnnotation *green = [[MyPointAnnotation alloc] init];
    green.coordinate = CLLocationCoordinate2DMake(27.88078289, 112.86250591);
    green.title  = @"理科生报道处";
    [green setPid:@"-2"];
    //定义第三标注，放到annotations数组
    [annotations insertObject:green atIndex:1];
    MyPointAnnotation *purple = [[MyPointAnnotation alloc] init];
    purple.coordinate = CLLocationCoordinate2DMake(27.88605557, 112.86220551);
    purple.title  = @"文科生报到处";
    [purple setPid:@"-3"];
    [annotations insertObject:purple atIndex:2];
    MyPointAnnotation *sushe = [[MyPointAnnotation alloc] init];
    sushe.coordinate = CLLocationCoordinate2DMake(27.88257051, 112.86454439);
    sushe.title  = @"新生宿舍入口";
    [sushe setPid:@"-4"];
    [annotations insertObject:sushe atIndex:3];
    
    //添加annotations数组中的标注到地图上
    [_mapView addAnnotations:annotations];
    //[_mapView selectAnnotation:red animated:YES];
}

//-(void)initOverlays{
//    CLLocationCoordinate2D polylineCoords[4];
//    polylineCoords[0].latitude = 27.8768377;
//    polylineCoords[0].longitude = 112.86335349;
//    polylineCoords[1].latitude = 27.88081134;
//    polylineCoords[1].longitude = 112.86277413;
//    polylineCoords[2].latitude = 27.88304942;
//    polylineCoords[2].longitude = 112.86267757;
//    polylineCoords[3].latitude = 27.88307787;
//    polylineCoords[3].longitude = 112.86175489;
//    polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:4];
//    [_mapView addOverlay:polyline];
//}

-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
            annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
            annotationView.animatesDrop = YES;       //设置标注动画显示，默认为NO
            annotationView.draggable = YES;           //设置标注可以拖动，默认为NO
            UIButton *deBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 27.0, 27.0)];
            //[deBtn addTarget:self action:@selector(btnAct) forControlEvents:UIControlEventTouchUpInside];
            [deBtn setImage:[UIImage imageNamed:@"ndet.png"] forState:UIControlStateNormal];
            [annotationView setRightCalloutAccessoryView:deBtn];
        }
        annotationView.pinColor = MAPinAnnotationColorRed;
        return annotationView;
    }
    return nil;
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id)overlay
{
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        polygonView.lineWidth   = 8.f;  //线宽，必须设置
        polygonView.strokeColor = UIColorFromRGB(0x000000);
        polygonView.fillColor   = [UIColor redColor];
        return polygonView;
    }
    return nil;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [btnHide setAlpha:0.0];
    [self.view addSubview:btnHide];
    [UIView animateWithDuration:0.35 animations:^{
        [btnHide setAlpha:0.7f];
        [self.navView setY:-20];
        [self.view setY:-44];
    }];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)sBar
{
    [sBar resignFirstResponder];
    [UIView animateWithDuration:0.35 animations:^{
        [btnHide setAlpha:0];
        [self.view setY:0];
        [self.navView setY:0];
    } completion:^(BOOL cmp){
        [btnHide removeFromSuperview];
    }];
    NSString *keyword = [[sBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (keyword.length == 0) {
        [MBProgressHUD showMsg:self.view title:@"关键字不能为空" delay:1.5];
        return;
    }
    if (HUD == nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        [HUD setLabelText:@"正在加载"];
    }
    [HUD show:YES];
    NSString *url = [NSString stringWithFormat:@"http://yuntuapi.amap.com/datasearch/around?key=11496020d1641fca77dbeed9385ff8b8&limit=50&center=112.863439,27.879213&radius=4000&tableid=53c4e294e4b0dd06e5927061&keywords=%@&page=1",keyword];
    XxyHttpRequest *req = [[XxyHttpRequest alloc] init];
    [req setFinishBlock:^(NSData *data){
        [self showAnnotations:data];
    }];
    [req setFailedBlock:^(NSError *err){
        [self failedLoad];
    }];
    [req startAsyncWithUrl:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];

}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    MyPointAnnotation *pA = (MyPointAnnotation *)view.annotation;
    currPid = pA.pid;
    currName = pA.title;
//    
//    if (detailView == nil) {
//        detailView = [[MyAnnotationView alloc] initWithAnnotation:pA reuseIdentifier:@"ann"];
//    }
//    NSInteger l = view.annotation.title.length;
//    CGFloat w = l * 12 + 30;
//    [detailView setX: 24 - w/2];
//    [detailView setY: -42];
//    [detailView setTitle:view.annotation.title];
//    [detailView setNeedsLayout];
//    MapViewController *sV = self;
//    [detailView setShowNdet:^{
//        [sV showNdet];
//    }];
//    [view addSubview:detailView];
}
- (void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self showNdet];
}

- (void)showNdet
{
    MapDetailViewController *detVC = [[MapDetailViewController alloc] init];
    [detVC setLid:currPid];
    [detVC setLName:currName];
    [self.navigationController pushViewController:detVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"新生地图"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"新生地图"];
}

//- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
//{
//    [detailView removeFromSuperview];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
