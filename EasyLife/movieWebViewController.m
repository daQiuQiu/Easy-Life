//
//  movieWebViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/3/2.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "movieWebViewController.h"

@interface movieWebViewController ()

@end

@implementation movieWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebWithUrl:self.urlString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadWebWithUrl :(NSString *)url {
    NSLog(@"url:%@",url);
    self.myWeb.delegate = self;
    self.myWeb.scalesPageToFit = YES;
    self.myWeb.scrollView.bounces = NO;
    
    NSURL *weburl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:weburl];
    [self.myWeb loadRequest:request];
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



- (IBAction)backToVC:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
