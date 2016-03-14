//
//  NavigationViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/3/10.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "NavigationViewController.h"
#import <Masonry.h>
#import "MapDataModel.h"

@interface RouteAnnotation : BMKPointAnnotation
{
    int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
    int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface NavigationViewController ()

@end

@implementation NavigationViewController
-(void)viewWillAppear:(BOOL)animated {
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    self.routeSearch.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.routeSearch = [[BMKRouteSearch alloc]init];
    [self creatMapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
    self.routeSearch.delegate = nil;
}

-(void)viewDidDisappear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - 创建MapView
-(void) creatMapView {
    self.mapView = [[BMKMapView alloc]init];
    [self.view addSubview:self.mapView];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(screenW, screenH-200));
        make.top.equalTo (self.topTravelMethodView.mas_bottom);
    }];
}

#pragma mark - MapView Delegate
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[RouteAnnotation class]]) {
        return [self getRouteAnnotationView:mapView viewForAnnotation:(RouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        polylineView.strokeColor = bColor;
        polylineView.lineWidth = 9.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - 移除现有的大头针和路线方法
-(void) removeAllPinAndPath {
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
}

#pragma mark - BMKRouteSearchDelegate
-(void)onGetTransitRouteResult:(BMKRouteSearch *)searcher result:(BMKTransitRouteResult *)result errorCode:(BMKSearchErrorCode)error {
    [self removeAllPinAndPath];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKTransitRouteLine* plan = (BMKTransitRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"我的位置";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = 3;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点

        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKTransitStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)[result.routes objectAtIndex:0];
        // 计算路线方案中的路段数目
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"我的位置";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        // 添加途经点
        if (plan.wayPoints) {
            for (BMKPlanNode* tempNode in plan.wayPoints) {
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item = [[RouteAnnotation alloc]init];
                item.coordinate = tempNode.pt;
                item.type = 5;
                item.title = tempNode.name;
                [_mapView addAnnotation:item];
            }
        }
        //轨迹点
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int j = 0; j < size; j++) {
            BMKDrivingStep* transitStep = [plan.steps objectAtIndex:j];
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        NSInteger size = [plan.steps count];
        int planPointCounts = 0;
        for (int i = 0; i < size; i++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
            if(i==0){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.starting.location;
                item.title = @"我的位置";
                item.type = 0;
                [_mapView addAnnotation:item]; // 添加起点标注
                
            }else if(i==size-1){
                RouteAnnotation* item = [[RouteAnnotation alloc]init];
                item.coordinate = plan.terminal.location;
                item.title = @"终点";
                item.type = 1;
                [_mapView addAnnotation:item]; // 添加起点标注
            }
            //添加annotation节点
            RouteAnnotation* item = [[RouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = 4;
            [_mapView addAnnotation:item];
            
            //轨迹点总数累计
            planPointCounts += transitStep.pointsCount;
        }
        
        //轨迹点

        
        BMKMapPoint * temppoints = new BMKMapPoint[planPointCounts];
        int i = 0;
        for (int p = 0; p < planPointCounts; p++) {
            
        }
        for (int j = 0; j < size; j++) {
            BMKWalkingStep* transitStep = [plan.steps objectAtIndex:j];
            
            int k=0;
            for(k=0;k<transitStep.pointsCount;k++) {
                temppoints[i].x = transitStep.points[k].x;
                temppoints[i].y = transitStep.points[k].y;
                i++;
            }
            
        }
        
        // 通过points构建BMKPolyline
        BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
        [_mapView addOverlay:polyLine]; // 添加路线overlay
        delete []temppoints;
        [self mapViewFitPolyLine:polyLine];
    }
}

//根据polyline设置地图范围
- (void)mapViewFitPolyLine:(BMKPolyline *) polyLine {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyLine.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyLine.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyLine.pointCount; i++) {
        BMKMapPoint pt = polyLine.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel = _mapView.zoomLevel - 0.3;
}

#pragma mark - 添加大头针View
- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case 0:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"start"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 1:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"end"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 2:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"bus"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 3:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"rail"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case 4:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageNamed:@"direction"];
            
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
            
        }
            break;
        default:
            break;

    }
    return view;
}


#pragma mark - 触发路线搜索
- (IBAction)busRoute:(UIButton *)sender {
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    start.pt = self.userCoordinate;
    
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    end.pt = self.goCoordinate;
    
    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    //transitRouteSearchOption.city= @"北京市";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routeSearch transitSearch:transitRouteSearchOption];
    
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }

}

- (IBAction)driveRoute:(UIButton *)sender {
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    start.pt = self.userCoordinate;
    
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    end.pt = self.goCoordinate;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }

}

- (IBAction)walkRoute:(UIButton *)sender {
    BMKPlanNode *start = [[BMKPlanNode alloc]init];
    start.pt = self.userCoordinate;
    
    BMKPlanNode *end = [[BMKPlanNode alloc]init];
    end.pt = self.goCoordinate;
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }

    
}


@end
