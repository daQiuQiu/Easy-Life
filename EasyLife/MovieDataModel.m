//
//  MovieDataModel.m
//  EasyLife
//
//  Created by 易仁 on 16/2/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "MovieDataModel.h"

@implementation MovieDataModel

+(instancetype) initWithModel {
    static MovieDataModel *model;
    if (model == nil) {
        model = [[MovieDataModel alloc]init];
    }
    return model;
}
@end
