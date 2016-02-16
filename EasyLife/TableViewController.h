//
//  TableViewController.h
//  NewsDemo
//
//  Created by 易仁 on 16/1/12.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataLoading.h"
#import "MJRefresh.h"
#import "MJRefreshNormalHeader.h"

@interface TableViewController : UITableViewController
@property (nonatomic,weak)NSTimer *timer;
- (IBAction)sideMenuShow:(UIBarButtonItem *)sender;



//@property (strong,nonatomic)NewsData *dataModel;
@end
