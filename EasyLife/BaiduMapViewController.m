//
//  BaiduMapViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/3/3.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "BaiduMapViewController.h"
#import <Masonry.h>
#import "MyAnimatedAnnotationView.h"

@interface BaiduMapViewController ()

@end
BOOL isShow = NO;
BOOL isLocated = NO;
@implementation BaiduMapViewController

-(void) viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locationService.delegate =  self;
    self.search.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatMapView];
    
    
    [self locateUserPosition];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.search.delegate = nil;
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

#pragma mark - 创建搜索条和工具栏 
-(void) creatSearchBarAndButtons {
    UIImageView *leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"60_2"]];
    //leftImage.frame = CGRectMake(0, 0, 50, 50);
    self.searchField = [[UITextField alloc]init];
    self.searchField.delegate = self;
    self.searchField.backgroundColor = [UIColor whiteColor];
    self.searchField.placeholder = @"去哪里 搜地点 查路线";
    
    self.searchField.borderStyle = UITextBorderStyleNone;
    self.searchField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchField.clearButtonMode = UITextFieldViewModeAlways;
    self.searchField.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.leftView = leftImage;
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
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [self.mapView updateLocationData:userLocation];
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

#pragma mark - 创建地点详细View
-(void) creatLocationDetailView {
    
}

#pragma mark - POI Search Delegate
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
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

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSString *annotationID = @"myAnnotation";
    //MyAnimatedAnnotationView *annotationView = nil;
    BMKPinAnnotationView *annotationView = nil;
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annotationID];
            
        }
        //annotationView.pinColor = BMKPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        annotationView.annotation = annotation;
        annotationView.image = [UIImage imageNamed:@"poi_1"];
        return annotationView;
    }
    
    return nil;
}






@end
