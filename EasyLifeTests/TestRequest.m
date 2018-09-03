//
//  TestRequest.m
//  piaDemo
//
//  Created by Charlie on 16/3/16.
//  Copyright © 2016年 Charlie. All rights reserved.
//

#import "TestRequest.h"

@implementation TestRequest

- (void)requestWithUrlString:(NSString *)url params:(NSDictionary *)params completeHandler:(completeHandler)handler {
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    NSData* postBody = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    [request setValue: @"application/json" forHTTPHeaderField:@"Content-Type"];
    unsigned long long postLength = postBody.length;
    NSString *contentLength = [NSString stringWithFormat:@"%llu", postLength];
    [request addValue:contentLength forHTTPHeaderField:@"Content-Length"];

    // This should all look familiar...
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postBody];
    request.timeoutInterval = 10;

    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError    *error) {
        if (handler) {
            handler(data, response, error);
        }
    }];
    
    [postDataTask resume];
}

@end
