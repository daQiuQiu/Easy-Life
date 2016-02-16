//
//  NewsDetailViewController.h
//  NewsDemo
//
//  Created by 易仁 on 16/1/12.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTableViewCell.h"
@interface NewsDetailViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myWeb;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *voteButton;

- (IBAction)NextArticle:(UIBarButtonItem *)sender;

- (IBAction)BackToView:(UIBarButtonItem *)sender;
- (IBAction)voteButtonClick:(UIBarButtonItem *)sender;
- (IBAction)shareNews:(UIBarButtonItem *)sender;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *newsTitle;
@property (strong,nonatomic) UIImage *image;
@property (assign,nonatomic) NSUInteger newsTag;

@end
