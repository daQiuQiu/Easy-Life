//
//  DataLoading.h
//  NewsDemo
//
//  Created by 易仁 on 16/1/12.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataLoading : NSObject
//@property (strong,nonatomic) NSString *title;
//@property (strong,nonatomic) NSString *imageUrl;
//@property (strong,nonatomic) NSArray *images;
//@property (strong,nonatomic) NSString *desc;
//@property (strong,nonatomic) NSString *source;
@property (strong,nonatomic) NSMutableString *channelId;
@property (strong,nonatomic) NSMutableString *name;
//@property (strong,nonatomic) NSDictionary *dataDic;
@property (strong,nonatomic) NSMutableArray *Array;
@property (strong,nonatomic) NSMutableArray *newsTitleArray;
@property (strong,nonatomic) NSMutableArray *urlArray;
@property (strong,nonatomic) NSMutableArray *imageArray;
@property (strong,nonatomic) NSMutableArray *imagePresentArray;
@property (strong,nonatomic) NSMutableArray *cateArray;
@property (strong,nonatomic) NSMutableArray *idArray;
@property (strong,nonatomic) NSString *idKey;
@property (nonatomic,assign) NSInteger chosenindex;

+ (id)initWithModel;


@end
