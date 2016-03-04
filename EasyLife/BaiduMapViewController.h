//
//  BaiduMapViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/3/3.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface BaiduMapViewController : UIViewController<BMKMapViewDelegate,UITextFieldDelegate>
@property (strong,nonatomic) BMKMapView *mapView;
@property (strong,nonatomic) UITextField *searchField;
@end
