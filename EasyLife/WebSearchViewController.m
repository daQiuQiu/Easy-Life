//
//  WebSearchViewController.m
//  HomeSearchDemo
//
//  Created by 易仁 on 16/1/26.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "WebSearchViewController.h"

@interface WebSearchViewController ()

@end

@implementation WebSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviBar.tintColor = [UIColor redColor];
    self.naviBar.backgroundColor = [UIColor redColor];
    [self loadWebView];
    self.tabBarController.tabBar.hidden = YES;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadWebView {
    self.searchWebView.delegate = self;
    self.searchWebView.scalesPageToFit = YES;
    NSURL *weburl = [NSURL URLWithString:self.urlstring ];
    NSURLRequest *request = [NSURLRequest requestWithURL:weburl];
    [self.searchWebView loadRequest:request];
    
}

- (IBAction)backToSearchView:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
@end
