//
//  MapDataModel.h
//  EasyLife
//
//  Created by 易仁 on 16/3/11.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
@interface MapDataModel : NSObject
@property (strong,nonatomic) NSMutableArray *locationInfoArray;


+(instancetype) initWithModel;
@end
