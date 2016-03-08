//
//  BaiduMapViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/3/3.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "BaiduMapViewController.h"
#import <Masonry.h>
@interface BaiduMapViewController ()

@end
BOOL isShow = NO;
BOOL isLocated = NO;
@implementation BaiduMapViewController

-(void) viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.locationService.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatMapView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
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
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setShowsUserLocation:YES];
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
    [_trafficButton setTitle:@"交通" forState:UIControlStateNormal];
    _trafficButton.backgroundColor = [UIColor darkGrayColor];
    [_trafficButton addTarget:self action:@selector(showTraffic) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_trafficButton];
    [_trafficButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.searchField.mas_bottom).with.offset (20);
        make.size.mas_equalTo (CGSizeMake(50, 20));
        make.right.equalTo (self.searchField);
    }];
    
    //显示定位
    self.locationButton = [[UIButton alloc]init];
    [self.locationButton setTitle:@"定位" forState:UIControlStateNormal];
    _locationButton.backgroundColor = [UIColor darkGrayColor];
    [_locationButton addTarget:self action:@selector(locateUserPosition) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationButton];
    [_locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.trafficButton.mas_bottom).with.offset (10);
        make.size.mas_equalTo (CGSizeMake(50, 20));
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
        [self.mapView setZoomLevel:15];
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
    
}

#pragma mark - textfield Delegate方法
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}




@end
