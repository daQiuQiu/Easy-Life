//
//  SideViewController.h
//  NewsDemo
//
//  Created by 易仁 on 16/1/15.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YRClickSideMenuProtocol <NSObject>

@optional
- (void)sideMenuClick:(NSString *)channelId;
-(void)pullToRefresh;
-(void) removeScrollView;
-(void)stopTimer;

@end

@interface SideViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView *table;

/*
 获取中间的viewcontroller
 */
@property (nonatomic, weak) id<YRClickSideMenuProtocol> delegate;

@end
