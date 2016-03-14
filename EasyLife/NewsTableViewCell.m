//
//  NewsTableViewCell.m
//  NewsDemo
//
//  Created by 易仁 on 16/1/14.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.cellTitle sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
