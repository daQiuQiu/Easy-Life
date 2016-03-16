//
//  BaiduMapViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/3/3.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchOption.h>
#import <CoreLocation/CoreLocation.h>

@interface BaiduMapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate>
@property (strong,nonatomic) BMKMapView *mapView;
@property (strong,nonatomic) BMKLocationService *locationService;
@property (strong,nonatomic) UITextField *searchField;
@property (strong,nonatomic) UIButton *trafficButton;
@property (strong,nonatomic) UIButton *locationButton;
@property (strong,nonatomic) BMKPoiSearch *search;
@property (strong,nonatomic) BMKUserLocation *location;
@property (strong,nonatomic) UIImage *pinImage;
@property (strong,nonatomic) UIImage *goImage;
@property (strong,nonatomic) UIVisualEffectView *detailView;//显示地点信息
@property (strong,nonatomic) UIButton *goButton;//显示导航按键
@property (strong,nonatomic) UIImageView *locationImageView;//地点图片
@property (strong,nonatomic) UIImageView *leftImageView;//地点图片
@property (strong,nonatomic) UIImage *searchImage;//地点图片
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *phoneLabel;
@property (strong,nonatomic) UILabel *addressLabel;
@property (strong,nonatomic) BMKRouteSearch *routeSearch;
@property (strong,nonatomic) BMKPoiResult *poiResultInfoList;
@property (nonatomic,assign) CLLocationCoordinate2D userCoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D goCoordinate;

@end
