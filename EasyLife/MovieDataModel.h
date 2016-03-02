//
//  MovieDataModel.h
//  EasyLife
//
//  Created by 易仁 on 16/2/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <Foundation/Foundation.h>
//1 是正在上映的影片，2是即将上映的影片
@interface MovieDataModel : NSObject

@property (nonatomic,strong) NSMutableArray *onMovieTitleArray;
@property (nonatomic,strong) NSMutableArray *willOnMovieTitleArray;
@property (nonatomic,strong) NSMutableArray *ratingArray1;
@property (nonatomic,strong) NSMutableArray *ratingArray2;//这个显示上映日期，因为未上映电影没有评分
@property (nonatomic,strong) NSMutableArray *directorArray1;
@property (nonatomic,strong) NSMutableArray *directorLinkArray;
@property (nonatomic,strong) NSMutableArray *directorArray2;
@property (nonatomic,strong) NSMutableArray *descArray1;
@property (nonatomic,strong) NSMutableArray *descArray2;
@property (nonatomic,strong) NSMutableArray *star1Array;
@property (nonatomic,strong) NSMutableArray *starLinkArray;
@property (nonatomic,strong) NSMutableArray *starImageUrlArray;
@property (nonatomic,strong) NSMutableArray *starPresentImageArray;
@property (nonatomic,strong) NSMutableArray *star2Array;
@property (nonatomic,strong) NSMutableArray *iconUrlArray1;
@property (nonatomic,strong) NSMutableArray *iconUrlArray2;
@property (nonatomic,strong) NSMutableArray *presentImageArray1;
@property (nonatomic,strong) NSMutableArray *presentImageArray2;
@property (nonatomic,strong) NSMutableArray *playDate;//上映日期
@property (nonatomic,strong) NSMutableArray *cinemaNumber;//上映影院数量
@property (nonatomic,strong) NSString *selectedName;//选中的电影
@property (nonatomic,strong) NSString *tag;//类别
@property (nonatomic,strong) NSString *area;//地区
@property (nonatomic,strong) NSMutableAttributedString *desc;//简要内容


+(instancetype) initWithModel; //init方法

@end
