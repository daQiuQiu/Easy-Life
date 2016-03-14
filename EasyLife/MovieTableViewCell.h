//
//  MovieTableViewCell.h
//  EasyLife
//
//  Created by 易仁 on 16/2/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *movieImage;
@property (strong, nonatomic) IBOutlet UILabel *directorLabel;
@property (strong, nonatomic) IBOutlet UILabel *descLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;


@end
