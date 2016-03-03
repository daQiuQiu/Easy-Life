//
//  MovieDetailViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/2/25.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoviePlayerView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MovieDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIVisualEffectView *backEffectView;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *movieTagLabel;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UILabel *playdateLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *cinemaNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;
@property (assign,nonatomic) long int movieNo;
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong,nonatomic) UILabel *descLabel;
@property (strong,nonatomic) UIButton *expandButton;
@property (strong,nonatomic) UITapGestureRecognizer *tap;
@property (strong,nonatomic) UITapGestureRecognizer *playTap;
@property (strong,nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong,nonatomic) MoviePlayerView *playView;

@end
