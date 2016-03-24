//
//  PeekViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/3/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PeekViewController : UIViewController <UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *peekWebView;
@property (nonatomic,strong) NSString  *url;
@end
