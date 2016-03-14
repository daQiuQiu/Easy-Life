//
//  movieDetailTableViewCell.m
//  EasyLife
//
//  Created by 易仁 on 16/3/2.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "movieDetailTableViewCell.h"

@implementation movieDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.bounds = CGRectMake(0, 0, 50, 65);
    self.imageView.frame = CGRectMake(0, 0, 50, 65);
    
}

@end
