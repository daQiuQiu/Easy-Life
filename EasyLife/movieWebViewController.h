//
//  movieWebViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/3/2.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface movieWebViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *myWeb;
- (IBAction)backToVC:(UIBarButtonItem *)sender;
@property (strong,nonatomic) NSString *urlString;
@end
