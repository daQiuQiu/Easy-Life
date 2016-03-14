//
//  AppDelegate.h
//  EasyLife
//
//  Created by 易仁 on 16/1/11.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YRSideViewController.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) YRSideViewController *sideController;

@property (assign,nonatomic)BOOL isRotation;
@property (strong,nonatomic) BMKMapManager *mapManager;
@end

