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

@interface TableViewController : UITableViewController<UIViewControllerPreviewingDelegate>
@property (nonatomic,weak)NSTimer *timer;
- (IBAction)sideMenuShow:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideMenuButton;
// peek && pop 相关
@property (nonatomic, assign) CGRect sourceRect;       // 用户手势点 对应需要突出显示的rect
@property (nonatomic, strong) NSIndexPath *indexPath;  // 用户手势点 对应的indexPath


//@property (strong,nonatomic)NewsData *dataModel;
@end
