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

@implementation BaiduMapViewController

-(void) viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
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
    
}

#pragma mark - 创建地图View
-(void) creatMapView {
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH-50)];//底部tabbar挡住 需要-50？？？
    [self.view addSubview:self.mapView];
    [self.mapView setTrafficEnabled:YES];
    [self.mapView setBuildingsEnabled:YES];
    [self.mapView setShowMapScaleBar:YES];
    [self.mapView setShowsUserLocation:YES];
    
}

#pragma mark - 创建搜索条和工具栏 
-(void) creatSearchBarAndButtons {
    self.searchField = [[UITextField alloc]init];
    
}


@end
