//
//  MovieDetailViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/2/25.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIVisualEffectView *backEffectView;
@property (strong, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *movieTagLabel;
@property (strong, nonatomic) IBOutlet UILabel *areaLabel;
@property (strong, nonatomic) IBOutlet UILabel *playdateLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *cinemaNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *movieImageView;
@property (assign,nonatomic) long int movieNo;

@end
