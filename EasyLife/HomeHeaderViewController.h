//
//  HomeHeaderViewController.h
//  HomeSearchDemo
//
//  Created by 易仁 on 16/1/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import "DKLiveBlurView.h"
@interface HomeHeaderViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITextField *searchFiled;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UITableView *mainTable;
@property (nonatomic,strong) UITableView *historyTable;
@property (nonatomic,strong) UITableView *hotNewsTable;
@property (nonatomic,strong) UIButton *searchEngineButton;
@property (nonatomic,strong) NSString *searchLink;
@property (nonatomic,strong) NSMutableArray *historyArray;
@property (nonatomic,strong) UIView *weatherView;
@property (nonatomic,strong) UIImageView *weatherImageView;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) UILabel *tempLabel;
@property (nonatomic,strong) UILabel *windLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *logoImageView;
@property (nonatomic,strong) DKLiveBlurView *backgroundView;
@property (nonatomic,strong) UILabel *viewLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIView *relaxView;


@end
