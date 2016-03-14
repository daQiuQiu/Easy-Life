//
//  NewsDetailViewController.m
//  NewsDemo
//
//  Created by 易仁 on 16/1/12.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "DataLoading.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import "UIBarButtonItem+Badge.h"

@interface NewsDetailViewController ()
@property (nonatomic,assign) BOOL isVoted;
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadWebWithUrl:self.url];
    self.isVoted = NO;
    //self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadWebWithUrl :(NSString *)url {
    NSLog(@"url:%@",self.url);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)NextArticle:(UIBarButtonItem *)sender {
    DataLoading *model = [DataLoading initWithModel];
    
    self.newsTag = self.newsTag+1;
    if (self.newsTag < [model.urlArray count]) {
    self.url = model.urlArray[self.newsTag];
    [self loadWebWithUrl:self.url];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"最后一篇" message:@"已经是最后一篇了" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        NSLog(@"没有下一篇了");
    }
}

- (IBAction)BackToView:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)voteButtonClick:(UIBarButtonItem *)sender {
    ;
    if (self.isVoted == NO) {
        self.isVoted = YES;
        self.voteButton.tintColor = [UIColor blueColor];
        self.voteButton.badgeValue = @"2";
        
    }
    else if (self.isVoted == YES) {
        self.isVoted = NO;
        self.voteButton.tintColor = [UIColor darkGrayColor];
        self.voteButton.badgeValue = @"1";
        self.voteButton.badge.text = @"4";
    }
}

#pragma mark - Share分享
- (IBAction)shareNews:(UIBarButtonItem *)sender {
    NSArray *imageArray = @[self.image];
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKEnableUseClientShare];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://weibo.com"]
                                          title:self.newsTitle
                                           type:SSDKContentTypeAuto];
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            switch (state) {
                case SSDKResponseStateSuccess:{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享成功"
                                        message:nil
                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    break;
                }
                case SSDKResponseStateFail: {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"分享失败"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];
                    break;
                }
                    
                default:
                    break;
            }
        }];
                    }
    
    
}
@end
