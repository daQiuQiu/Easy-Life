//
//  DataModel.m
//  HomeSearchDemo
//
//  Created by 易仁 on 16/1/28.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel
+(instancetype) initWithModel {
    static DataModel *model;
    if (model == nil) {
        model = [[DataModel alloc]init];
    }
    return model;
}

@end
