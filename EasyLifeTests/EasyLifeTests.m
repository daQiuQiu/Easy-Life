//
//  EasyLifeTests.m
//  EasyLifeTests
//
//  Created by 易仁 on 16/1/11.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestRequest.h"
@interface EasyLifeTests : XCTestCase

@end

@implementation EasyLifeTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    //TableViewController *home = [[TableViewController alloc]init];
    //[home getNewsWithChannelID:nil];
    
//    [self test1001Login];
    //[self test1002PhoneLogin];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)test1001Login {
    TestRequest* tr = [[TestRequest alloc] init];
    [tr requestWithUrlString:@"http://eggapi.seeinfront.com/api/1001" params:@{@"openid":@"321",@"nickname": @"321",@"headimgurl": @"321",@"province":@"",@"city":@"",@"sex":@"1"} completeHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:
                             NSJSONReadingMutableLeaves error:nil];
        XCTAssertEqual([dic[@"status"] integerValue], 0);
        NSLog(@"%@",dic);
        NSDictionary* result = dic[@"result"];
        XCTAssertNotNil(result);
        NSLog(@"result = %@",result);
        NSDictionary* userinfo = result[@"userinfo"];
        XCTAssertNotNil(userinfo);
        
//        for (NSString* v in userinfo) {
//            XCTAssertTrue([v isKindOfClass:[NSString class]]);
//        }
    }];
    
    NSLog(@"1001");
}

- (void)test1002PhoneLogin {
    TestRequest* tr = [[TestRequest alloc] init];
    [tr requestWithUrlString:@"http://eggapi.seeinfront.com/api/1002" params:@{@"loginphone":@"15641706680",@"password": @"1234567"} completeHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* dic1 = [NSJSONSerialization JSONObjectWithData:data options:
                             NSJSONReadingMutableLeaves error:nil];
        NSInteger a = [dic1[@"status"] integerValue];
        XCTAssertTrue(a == 5,@"12233fuck");
        if (a == 0 ) {
            NSLog(@"testPass");
        }
        else {
            NSLog(@"FAILED!");
        }
//        NSDictionary* result1 = dic1[@"result"];
//        XCTAssertNotNil(result1[@"userinfo"]);
//        
//        NSDictionary* userinfo1 = result1[@"userinfo"];
//        XCTAssertNotNil(userinfo1);
//        NSLog(@"userinfo1 = %@",userinfo1);
        
//        for (NSString* v in userinfo) {
//            XCTAssertTrue([v isKindOfClass:[NSString class]]);
//        }
    }];
    NSLog(@"1002");
}

- (void)test1 {
    int  a= 3;
    XCTAssertTrue(a == 3,"a 不能等于 0");
}

- (void)test1007giftList {
    TestRequest* tr = [[TestRequest alloc] init];
    [tr requestWithUrlString:@"http://eggapi.seeinfront.com/api/1002" params:@{@"loginphone":@"15641706680",@"password": @"1234567"} completeHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* dic1 = [NSJSONSerialization JSONObjectWithData:data options:
                              NSJSONReadingMutableLeaves error:nil];
        NSInteger a = [dic1[@"status"] integerValue];
        XCTAssertTrue(a == 5,@"12233fuck");
        if (a == 0 ) {
            NSLog(@"testPass");
        }
        else {
            NSLog(@"FAILED!");
        }
        
    }];
}

@end
