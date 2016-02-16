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





@end
