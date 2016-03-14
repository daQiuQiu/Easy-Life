//
//  DataModel.h
//  HomeSearchDemo
//
//  Created by 易仁 on 16/1/28.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,strong) NSMutableArray *titleArray;
@property (nonatomic,strong) NSMutableArray *urlArray;
@property (nonatomic,strong) NSMutableArray *relaxArray;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *temp;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *wind;
@property (nonatomic,strong) NSString *weather;
@property (nonatomic,assign) int *colorStyle;



+(instancetype) initWithModel;


@end
