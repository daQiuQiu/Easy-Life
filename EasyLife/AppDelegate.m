//
//  AppDelegate.m
//  EasyLife
//
//  Created by 易仁 on 16/1/11.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "SideViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <iflyMSC/IFlyMSC.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //UINavigationController *tableViewController = (UINavigationController *)[self initWithSB:@"newsNavi" inStoryBoard:@"Main"];
    UITabBarController *tabVC = (UITabBarController *)[self initWithSB:@"tabvc" inStoryBoard:@"Main"];
    //UINavigationController *newsNaviVC = (UINavigationController *)[self initWithSB:@"newsnavi" inStoryBoard:@"NewsSB"];
    //TableViewController *tableVC = newsNaviVC.viewControllers[0];// 拿到tableviewcontroller
    
    SideViewController *sideMenu = [[SideViewController alloc]init];
    //sideMenu.delegate = tableVC;//设置代理
    sideMenu.view.backgroundColor = [UIColor darkGrayColor];
    
    self.sideController = [[YRSideViewController alloc]init];
    self.sideController.rootViewController = tabVC;
    self.sideController.leftViewController = sideMenu;
    //self.sideController.needSwipeShowMenu = false;
    [self.sideController setNeedSwipeShowMenu:NO];
    
    self.sideController.leftViewShowWidth = 180;
    [self.sideController setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
        rootView.frame=CGRectMake(xoffset, orginFrame.origin.y, orginFrame.size.width, orginFrame.size.height);
    }];//设置水平移动
    
    self.window.rootViewController = self.sideController;
    [self.window makeKeyAndVisible];
    //启动前侧滑和跟视图配置
    //分享！！！
    [ShareSDK registerApp:@"eef78a7b9c62" activePlatforms:
     @[
       @(SSDKPlatformTypeWechat),
       @(SSDKPlatformTypeSinaWeibo),
       @(SSDKPlatformTypeFacebook),
       @(SSDKPlatformTypeQQ),
       @(SSDKPlatformTypeSMS),
       @(SSDKPlatformTypeMail)] onImport:^(SSDKPlatformType platformType) {
           switch (platformType) {
               case SSDKPlatformTypeSinaWeibo:{
                   [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                   break;
               }
               case SSDKPlatformTypeWechat:{
                   [ShareSDKConnector connectWeChat:[WXApi class]];
                   break;
               }
               case SSDKPlatformTypeQQ:{
                   [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                   break;
               }
               default:
                   break;
           }
       } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
           switch (platformType) {
               case SSDKPlatformTypeSinaWeibo:{
                   [appInfo SSDKSetupSinaWeiboByAppKey:@"861288124" appSecret:@"909faec020adb6c0739478db1b46b110" redirectUri:@"http://www.715buy.com" authType:SSDKAuthTypeBoth];
                   break;
               }
               case SSDKPlatformTypeWechat: {
                   [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885" appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                   break;
               }
               default:
                   break;
           }
       }];
    //语音！！！
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=56c148b5"];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

    return YES;
}

-(instancetype)initWithSB:(NSString *) identifier inStoryBoard:(NSString *) storyboardName {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    if (storyBoard) {
        return [storyBoard instantiateViewControllerWithIdentifier:identifier];
    }
    else {
        NSLog(@"No SB!");
        return nil;
    }
}//封装一下storyBoard调用

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
