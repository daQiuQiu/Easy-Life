//
//  WebSearchViewController.h
//  HomeSearchDemo
//
//  Created by 易仁 on 16/1/26.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebSearchViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,strong) IBOutlet UIWebView *searchWebView;
@property (nonatomic,strong) NSString *urlstring;
- (IBAction)backToSearchView:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UINavigationBar *naviBar;


@end
