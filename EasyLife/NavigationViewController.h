//
//  NavigationViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/3/10.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearchOption.h>
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapAPI_Map/BMKPolyline.h>
#import "UIImage+Rotate.h"
@interface NavigationViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate,BMKRouteSearchDelegate>
- (IBAction)busRoute:(UIButton *)sender;
- (IBAction)driveRoute:(UIButton *)sender;
- (IBAction)walkRoute:(UIButton *)sender;
@property (strong,nonatomic) BMKLocationService *locationService;
@property (weak, nonatomic) IBOutlet UIView *topTravelMethodView;
@property (strong,nonatomic) BMKMapView *mapView;
@property (strong,nonatomic) BMKRouteSearch *routeSearch;
@property (nonatomic,assign) CLLocationCoordinate2D userCoordinate;
@property (nonatomic,assign) CLLocationCoordinate2D goCoordinate;
@property (strong,nonatomic) UIVisualEffectView *detailBlurView;//显示路线信息
@property (nonatomic) UIColor *currentColor;
@property (strong,nonatomic) UILabel *durationLabel;//显示时间
@property (strong,nonatomic) UILabel *distanceLabel;//显示距离
@property (strong,nonatomic) NSString *duration;
@property (strong,nonatomic) NSString *distance;
@end
