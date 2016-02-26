//
//  MovieDetailViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/2/25.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "MovieDataModel.h"

@interface MovieDetailViewController ()

@end

@implementation MovieDetailViewController
-(void)viewWillAppear:(BOOL)animated {
    //[self.navigationController.navigationBar setAlpha:0.9];
    //[self.navigationController.navigationBar setBackgroundColor:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MovieDataModel *model = [MovieDataModel initWithModel];
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:model.presentImageArray1[self.movieNo]];
    backImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    [self.view addSubview:backImageView];//设置模糊背景
    [self.view bringSubviewToFront:self.backEffectView];//前置模糊View
    
    //传递参数
    //MovieDataModel *model = [MovieDataModel initWithModel];
    self.movieTitleLabel.text = model.onMovieTitleArray[self.movieNo];
    self.playdateLabel.text = model.playDate[self.movieNo];
    self.ratingLabel.text = model.ratingArray1[self.movieNo];
    self.cinemaNumberLabel.text = model.cinemaNumber[self.movieNo];
    self.movieImageView.image = model.presentImageArray1[self.movieNo];
    self.areaLabel.text = model.area;
    self.movieTagLabel.text = model.tag;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
