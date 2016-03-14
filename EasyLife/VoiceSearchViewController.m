//
//  VoiceSearchViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/2/21.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "VoiceSearchViewController.h"

@interface VoiceSearchViewController ()

@end

@implementation VoiceSearchViewController
-(void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadWebView];
    
    //self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
}//loading a web a activity inductor will appear.
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"finish loading");
    
}//when a web is not loaded a activity inductor will not appear

-(void)loadWebView {
    self.webView.delegate = self;
    self.webView.scalesPageToFit = YES;
    NSURL *weburl = [NSURL URLWithString:self.urlString ];
    NSURLRequest *request = [NSURLRequest requestWithURL:weburl];
    [self.webView loadRequest:request];
    
}



@end
