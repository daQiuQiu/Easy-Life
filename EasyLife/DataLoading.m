//
//  DataLoading.m
//  NewsDemo
//
//  Created by 易仁 on 16/1/12.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "DataLoading.h"

@implementation DataLoading
+ (id)initWithModel
{
    static DataLoading *oper;
    if (oper == nil) {
        oper = [[DataLoading alloc]init];
        oper.channelId =  [NSMutableString stringWithFormat:@"5572a109b3cdc86cf39001db"];
    }
    return oper;
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
//    @property (strong,nonatomic) NSMutableString *channelId;
//    @property (strong,nonatomic) NSMutableString *name;

//    @property (strong,nonatomic) NSMutableArray *Array;
//    @property (strong,nonatomic) NSMutableArray *newsTitleArray;
//    @property (strong,nonatomic) NSMutableArray *urlArray;
//    @property (strong,nonatomic) NSMutableArray *imageArray;
//    @property (strong,nonatomic) NSMutableArray *imagePresentArray;
//    @property (strong,nonatomic) NSMutableArray *cateArray;
//    @property (strong,nonatomic) NSMutableArray *idArray;
//    @property (strong,nonatomic) NSMutableArray *tagArray;
//    @property (strong,nonatomic) NSString *idKey;
//    @property (nonatomic,assign) NSInteger chosenindex;
    [aCoder encodeObject:_channelId forKey:@"kchannelIdKey"];
    [aCoder encodeObject:_name forKey:@"knameKey"];
    [aCoder encodeObject:_Array forKey:@"kArray"];
    [aCoder encodeObject:_newsTitleArray forKey:@"knewstitlearrayKey"];
    [aCoder encodeObject:_urlArray forKey:@"kurlArrayKey"];
    [aCoder encodeObject:_imageArray forKey:@"kimageArrayKey"];
    [aCoder encodeObject:_imagePresentArray forKey:@"kimagePresentArrayKey"];
    [aCoder encodeObject:_cateArray forKey:@"kcateArrayKey"];
    [aCoder encodeObject:_idArray forKey:@"kidArrayKey"];
    [aCoder encodeObject:_tagArray forKey:@"ktagArrayKey"];
    [aCoder encodeObject:_idKey forKey:@"kidKeyKey"];
    [aCoder encodeInteger:_chosenindex forKey:@"kchosenindexKey"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _channelId = [aDecoder decodeObjectForKey:@"kchannelIdKey"];
        _name = [aDecoder decodeObjectForKey:@"knameKey"];
        _Array = [aDecoder decodeObjectForKey:@"kArray"];
        _newsTitleArray = [aDecoder decodeObjectForKey:@"knewstitlearrayKey"];
        _urlArray = [aDecoder decodeObjectForKey:@"kurlArrayKey"];
        _imageArray = [aDecoder decodeObjectForKey:@"kimageArrayKey"];
        _imagePresentArray = [aDecoder decodeObjectForKey:@"kimagePresentArrayKey"];
        _cateArray = [aDecoder decodeObjectForKey:@"kcateArrayKey"];
        _idArray = [aDecoder decodeObjectForKey:@"kidArrayKey"];
        _tagArray = [aDecoder decodeObjectForKey:@"ktagArrayKey"];
        _idKey = [aDecoder decodeObjectForKey:@"kidKeyKey"];
        _chosenindex = [aDecoder decodeIntegerForKey:@"kchosenindexKey"];
        
    }
    return self;
}

#pragma mark - NSCoping
- (id)copyWithZone:(NSZone *)zone {
    DataLoading *model = [[[self class] allocWithZone:zone] init];
    model.channelId = [self.channelId copyWithZone:zone];
    model.name = [self.name copyWithZone:zone];
    model.Array = [self.Array copyWithZone:zone];
    model.newsTitleArray = [self.newsTitleArray copyWithZone:zone];
    model.urlArray = [self.urlArray copyWithZone:zone];
    model.imageArray = [self.imageArray copyWithZone:zone];
    model.imagePresentArray = [self.imagePresentArray copyWithZone:zone];
    model.cateArray = [self.cateArray copyWithZone:zone];
    model.idArray = [self.idArray copyWithZone:zone];
    model.idKey = [self.idKey copyWithZone:zone];
    model.tagArray = [self.tagArray copyWithZone:zone];
    //model.chosenindex = [_chosenindex copyWithZone:zone];

    return model;
}





@end
