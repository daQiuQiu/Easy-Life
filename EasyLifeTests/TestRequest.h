//
//  TestRequest.h
//  piaDemo
//
//  Created by Charlie on 16/3/16.
//  Copyright © 2016年 Charlie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeHandler)(NSData* data, NSURLResponse* response, NSError* error);

@interface TestRequest : NSObject

- (void)requestWithUrlString:(NSString*)url params:(NSDictionary*)params completeHandler:(completeHandler)handler;

@end
