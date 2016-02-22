//
//  VoiceSearchViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/2/21.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceSearchViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *urlString;

@end
