//
//  BaiduMapViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/3/3.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "BaiduMapViewController.h"
#import <Masonry.h>
#import "MapDataModel.h"
#import "NavigationViewController.h"

@interface BaiduMapViewController ()

@end
BOOL isShow = NO;
BOOL isLocated = NO;
BOOL isgoing = NO;//判断是否选中大头针
@implementation BaiduMapViewController

-(void) viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locationService.delegate =  self;
    self.search.delegate = self;
    self.routeSearch.delegate = self;
    [self getPinImage];
    [self changeColor];
    //self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatMapView];
    self.routeSearch = [[BMKRouteSearch alloc]init];
    [self getPinImage];
    [self locateUserPosition];
    [self creatLocationDetailView];
    
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.search.delegate = nil;
    self.routeSearch.delegate = nil;
    self.locationService.delegate = nil;//不用时delegate设置nil
    NSLog(@"WillDisappear");
    
    
    
}

#pragma mark - 创建地图View
-(void) creatMapView {
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-50)];//底部tabbar挡住 需要-50？
    [self.view addSubview:self.mapView];
    //[self.mapView setTrafficEnabled:YES];
    [self.mapView setBuildingsEnabled:YES];
    [self.mapView setShowMapScaleBar:YES];
    
    [self creatSearchBarAndButtons];
    
    
    
}

#pragma mark - 改变颜色
-(void) changeColor {
    int tag = [[[NSUserDefaults standardUserDefaults]objectForKey:@"tag"] intValue];
    if (tag == 0) {//蓝色图标
        self.searchImage = [UIImage imageNamed:@"searchb"];
        self.leftImageView.image = self.searchImage;
    }
    else if (tag == 1) {//红色
        self.searchImage = [UIImage imageNamed:@"searchr"];
        self.leftImageView.image = self.searchImage;
    }
    else if (tag == 2) {//黄色
        self.searchImage = [UIImage imageNamed:@"searchy"];
      self.leftImageView.image = self.searchImage;
    }
    else if (tag == 3) {//绿色
        self.searchImage = [UIImage imageNamed:@"searchg"];
        self.leftImageView.image = self.searchImage;
    }
    
}


#pragma mark - 创建搜索条和工具栏 
-(void) creatSearchBarAndButtons {
    self.searchImage = [UIImage imageNamed:@"searchb"];
    self.leftImageView = [[UIImageView alloc]initWithImage:self.searchImage];
    self.leftImageView.frame = CGRectMake(0, 0, 34, 34);
    self.leftImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.searchField = [[UITextField alloc]init];
    self.searchField.delegate = self;
    self.searchField.backgroundColor = [UIColor whiteColor];
    self.searchField.placeholder = @"搜附近 吃喝玩乐";
    
    self.searchField.borderStyle = UITextBorderStyleNone;
    self.searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchField.clearButtonMode = UITextFieldViewModeAlways;
    //self.searchField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.leftView = self.leftImageView;
    self.searchField.leftViewMode = UITextFieldViewModeAlways;//textfield 设置
    
    [self.view addSubview:self.searchField];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo (self.mapView);
        make.top.equalTo (self.mapView).with.offset (20);
        make.left.equalTo (self.mapView).with.offset (10);
        make.right.equalTo (self.mapView).with.offset (-10);
        make.height.equalTo(@50);
        
    }];//textfiled 约束
    
    //显示交通状况 按键
    self.trafficButton = [[UIButton alloc]init];
    [_trafficButton setImage:[UIImage imageNamed:@"jiaotong"] forState:UIControlStateNormal];
    //_trafficButton.backgroundColor = [UIColor darkGrayColor];
    [_trafficButton addTarget:self action:@selector(showTraffic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_trafficButton];
    [_trafficButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.searchField.mas_bottom).with.offset (20);
        make.size.mas_equalTo (CGSizeMake(30, 30));
        make.right.equalTo (self.searchField);
    }];
    
    //显示定位
    self.locationButton = [[UIButton alloc]init];
    [self.locationButton setImage:[UIImage imageNamed:@"dingwei"] forState:UIControlStateNormal];
    //_locationButton.backgroundColor = [UIColor darkGrayColor];
    [_locationButton addTarget:self action:@selector(locateUserPosition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationButton];
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.trafficButton.mas_bottom).with.offset (10);
        make.size.mas_equalTo (CGSizeMake(30, 30));
        make.right.equalTo (self.searchField);
    }];

    
}
#pragma mark - 定位方法
-(void) locateUserPosition {
    if (self.locationService == nil) {
        self.locationService = [[BMKLocationService alloc]init];
        self.locationService.delegate = self;
    }
    if (isLocated == NO) {
        isLocated = YES;
        [self.locationService startUserLocationService];
        [self.mapView setZoomLevel:20];
        self.mapView.showsUserLocation = NO;
        self.mapView.userTrackingMode = BMKUserTrackingModeFollowWithHeading;
        self.mapView.showsUserLocation = YES;
        
    }
    else if(isLocated == YES) {
        isLocated = NO;
        [self.locationService stopUserLocationService];
        self.mapView.showsUserLocation = NO;
    }
    
}
#pragma mark - 显示交通状况方法
-(void) showTraffic {
    //点击button 控制显示交通流量方法
    
    if (isShow == NO) {
        isShow = YES;
        [self.mapView setTrafficEnabled:YES];
    }
    else if (isShow == YES){
        isShow = NO;
        [self.mapView setTrafficEnabled:NO];
    }
}

#pragma mark - location Delegate 
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [self.mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView updateLocationData:userLocation];
    self.userCoordinate = userLocation.location.coordinate;
    self.location = userLocation;
    
}

#pragma mark - textfield Delegate方法
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if ([textField.text length] != 0) {
        NSLog(@"搜索:%@",textField.text);
        //清除之前的路线和标记
        NSArray* array = [NSArray arrayWithArray:self.mapView.annotations];
        [self.mapView removeAnnotations:array];
        array = [NSArray arrayWithArray:self.mapView.overlays];
        [self.mapView removeOverlays:array];
        
        //调用搜索
        [self creatPOISearchWithKeyword:textField.text];
    }
    else {
        NSLog(@"什么都没做");
    }
    
    return YES;
}
//CLLocationCoordinate2DMake(self.location.location.coordinate.latitude, self.location.location.coordinate.longitude)
#pragma mark - 创建POI Search
-(void) creatPOISearchWithKeyword: (NSString *)keyword {
    self.search = [[BMKPoiSearch alloc]init];
    self.search.delegate = self;
    
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = CLLocationCoordinate2DMake(self.location.location.coordinate.latitude, self.location.location.coordinate.longitude);
    option.radius = 2000;
    option.keyword = keyword;
    
    BOOL flag = [self.search poiSearchNearBy:option];
    if (flag) {
        NSLog(@"搜索成功");
        
    }
    else {
        NSLog(@"POI NEAR FAILED");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"搜索发起失败" message:@"大概是网络罢工了" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
    }
    
    
}

#pragma mark - 确定大头针图标
-(void) getPinImage {
    int tag = [[[NSUserDefaults standardUserDefaults]objectForKey:@"tag"] intValue];
    NSArray *imageNameArray = @[@"b",@"r",@"y",@"g"];
    self.pinImage = [UIImage imageNamed:imageNameArray[tag]];//获取大头针样式
    NSArray *goImageArray = @[@"roadb",@"roadr",@"roady",@"roadg"];
    self.goImage = [UIImage imageNamed:goImageArray[tag]];//获取导航按键样式
    
    [self.goButton setImage:self.goImage forState:UIControlStateNormal];
    
}

#pragma mark - 创建地点详细View
-(void) creatLocationDetailView {
    self.detailView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self.mapView addSubview:self.detailView];
    self.goButton = [[UIButton alloc]init];
    [self.goButton setImage:self.goImage forState:UIControlStateNormal];
    [self.goButton addTarget:self action:@selector(goForNaviView) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:self.goButton];
    [self.mapView bringSubviewToFront:self.goButton];
    //button 布局
    [self.goButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo (self.detailView.mas_top);
        make.right.equalTo (self.detailView).with.offset (-30);
        make.size.mas_equalTo (CGSizeMake(60, 60));
    }];
    
    ///图片和Label
    self.locationImageView = [[UIImageView alloc]init];
    self.locationImageView.contentMode = UIViewContentModeScaleToFill;
    self.locationImageView.layer.masksToBounds = YES;
    self.locationImageView.layer.cornerRadius = 7.0;
    [self.detailView addSubview:self.locationImageView];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.detailView).with.offset (10);
        make.size.mas_equalTo (CGSizeMake(60, 60));
        make.left.equalTo (self.detailView).with.offset (10);
    }];
    //图片布局
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.textColor = [UIColor darkTextColor];
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.text = @"哈哈哈哈";
    [self.detailView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.locationImageView);
        make.left.equalTo (self.locationImageView.mas_right).with.offset (5);
        make.right.equalTo (self.detailView).with.offset (-10);
        make.height.equalTo (@30);
    }];
    //地点名字Label布局
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.textColor = [UIColor darkGrayColor];
    self.phoneLabel.text = @"111111111111";
    self.phoneLabel.font = [UIFont systemFontOfSize:15];
    [self.detailView addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo (self.locationImageView);
        make.left.equalTo (self.locationImageView.mas_right).with.offset (5);
        make.right.equalTo (self.detailView).with.offset (-10);
        make.height.equalTo (@20);
    }];
    //电话号码Label
    
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.text = @"12345611111111111111111111111111111";
    self.addressLabel.textColor = [UIColor darkGrayColor];
    self.addressLabel.font = [UIFont systemFontOfSize:15];
    [self.detailView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo (self.detailView).with.offset (-5);
        make.left.equalTo (self.locationImageView);
        make.right.equalTo (self.detailView).with.offset (-10);
        make.height.equalTo (@20);
    }];
}

-(void) goForNaviView {
    NSLog(@"这是导航页面");
    NavigationViewController *naviVC = [self.storyboard instantiateViewControllerWithIdentifier:@"navivc"];
    naviVC.userCoordinate = self.userCoordinate;
    naviVC.goCoordinate = self.goCoordinate;
    self.navigationController.navigationBarHidden = NO;
    naviVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:naviVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - 导航路线方法
//-(void) getRouteFromLocation: (CLLocationCoordinate2D) coordinate {
//    if (isgoing == YES) {
//        BMKPlanNode *start = [[BMKPlanNode alloc]init];
//        start.pt = self.userCoordinate;
//        //start.name = @"起点";
//        
//        BMKPlanNode *end = [[BMKPlanNode alloc]init];
//        end.pt = self.goCoordinate;
//        //end.name = @"终点";
//        
//        
//        
//        
//        
//        
//    }
//    else {
//        NSLog(@"无信息");
//    }
//    
//}

#pragma mark - POI Search Delegate

-(void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode {
    
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        self.poiResultInfoList = [[BMKPoiResult alloc]init];
        self.poiResultInfoList = poiResultList;
        //储存POI
        [self.mapView setZoomLevel:16];//重新设置地图放大
        for (int i = 0; i < poiResultList.poiInfoList.count; i++)
        {
            BMKPoiInfo* poi = [poiResultList.poiInfoList objectAtIndex:i];
            NSLog(@"poi = %@",poi.name);
            
            BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
            
            
            
            
            if (i == 1) {
                NSLog(@"地址 = %@, dianhua = %@, city = %@, name = %@", poi.address,poi.phone,poi.city,poi.name);
            }
            [self.mapView addAnnotation:item];
            
            
                    }
        
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
        NSLog(@"%d",error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"未找到结果" message:@"请重新输入关键字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];//失败弹出提示
    }
}

#pragma mark - mapView Delegate方法
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:1];
        polylineView.strokeColor = [[UIColor alloc] initWithRed:0 green:0 blue:1 alpha:0.7];
        polylineView.lineWidth = 3.0;
        return polylineView;
    }
    return nil;
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSString *annotationID = @"myAnnotation";
    //MyAnimatedAnnotationView *annotationView = nil;
    BMKPinAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationID];
            
        }
        NSLog(@"long = %f, lat = %f",annotation.coordinate.longitude, annotation.coordinate.latitude);
        //NSLog(@"这里是 = %@",annotation.title);
        //annotationView.pinColor = BMKPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        annotationView.annotation = annotation;
        annotationView.image = self.pinImage;
        return annotationView;
    }
    
    return nil;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    NSLog(@"选中");
    
    //NSLog(@"选中的是 = %@,",view.annotation.title);
    //NSLog(@"long = %f, lat = %f",view.annotation.coordinate.longitude, view.annotation.coordinate.latitude);
    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.bottom.equalTo (self.mapView).with.offset (100);
        make.left.and.right.equalTo (self.mapView);
        make.height.mas_equalTo (100);
    }];
    [self.detailView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo (self.mapView);
    }];//下方信息框
    [UIView animateWithDuration:0.3f animations:^{
        [self.mapView layoutIfNeeded];
    }];
    
    NSArray *array = @[@"JJ1",@"JJ2",@"JJ3",@"JJ4",@"JJ5",@"JJ6",@"JJ7"];
    int tag = arc4random() % 7;
    self.locationImageView.image = [UIImage imageNamed:array[tag]];
    
    //处理选中，获取选中信息
    for (int i = 0; i < [self.poiResultInfoList.poiInfoList count]; i++) {
        BMKPoiInfo *poi = [self.poiResultInfoList.poiInfoList objectAtIndex:i];
        if (poi.pt.latitude == view.annotation.coordinate.latitude) {
            NSLog(@"选中的是 = %@,dianhua = %@",poi.name,poi.phone);
            self.nameLabel.text = poi.name;
            self.phoneLabel.text = poi.phone;
            self.addressLabel.text = poi.address;
            self.goCoordinate = poi.pt;
            isgoing = YES;
        }
    }
    
}

-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view {
    NSLog(@"取消选中");
    isgoing = NO;
    [self.detailView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo (self.mapView).with.offset (190);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        [self.mapView layoutIfNeeded];
    }];

}





@end
