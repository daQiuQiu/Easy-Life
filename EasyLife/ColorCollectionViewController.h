//
//  ColorCollectionViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/3/7.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorCollectionViewController : UICollectionViewController
@property (nonatomic,strong) NSArray *imageNameArray;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSArray *colorNameArray;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *useColorButton;

@end
