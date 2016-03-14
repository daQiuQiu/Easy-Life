//
//  MapDataModel.m
//  EasyLife
//
//  Created by 易仁 on 16/3/11.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "MapDataModel.h"

@implementation MapDataModel

+(instancetype) initWithModel {
    static MapDataModel *model;
    if (model == nil) {
        model = [[MapDataModel alloc]init];
    }
    return model;
}
@end
