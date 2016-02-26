//
//  MovieTableViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/2/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "MJRefreshNormalHeader.h"

@interface MovieTableViewController : UITableViewController<UITextFieldDelegate>
- (IBAction)changeMovieStatus:(UISegmentedControl *)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *statusSegment;

@end
