//
//  PeekViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/3/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "PeekViewController.h"

@interface PeekViewController ()

@end

@implementation PeekViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self loadWebWithUrl:self.url];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadWebWithUrl :(NSString *)url {
    NSLog(@"url:%@",self.url);
    self.peekWebView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.peekWebView];
    
    self.peekWebView.delegate = self;
    self.peekWebView.scalesPageToFit = YES;
    self.peekWebView.scrollView.bounces = NO;
    
    NSURL *weburl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:weburl];
    [self.peekWebView loadRequest:request];
    
}

-(NSArray<id<UIPreviewActionItem>> *)previewActionItems
{
         UIPreviewAction * action1 = [UIPreviewAction actionWithTitle:@"点赞" style:0 handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
                 NSLog(@"已经点赞");
            }];
    
//         UIPreviewAction * action2 = [UIPreviewAction actionWithTitle:@"标题2" style:0 handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//               NSLog(@"标题2");
//        
//             }];
//         UIPreviewAction * action3 = [UIPreviewAction actionWithTitle:@"标题3" style:2 handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
//                 NSLog(@"标题3");
//             }];
    
         NSArray * actions = @[action1];
    
         return actions;
}



@end
