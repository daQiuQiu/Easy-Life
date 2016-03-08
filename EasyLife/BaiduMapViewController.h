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
@interface BaiduMapViewController : UIViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,UITextFieldDelegate>
@property (strong,nonatomic) BMKMapView *mapView;
@property (strong,nonatomic) BMKLocationService *locationService;
@property (strong,nonatomic) UITextField *searchField;
@property (strong,nonatomic) UIButton *trafficButton;
@property (strong,nonatomic) UIButton *locationButton;
@end
