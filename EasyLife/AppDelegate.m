

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
#import "AdViewController.h"
#import "ZWIntroductionViewController.h"
@interface AppDelegate ()
@property (nonatomic,strong) ZWIntroductionViewController *guideVC;
@property (nonatomic,strong) AdViewController *adVC;
@property (nonatomic,strong) UITabBarController *tabVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.tabVC = [storyBoard instantiateViewControllerWithIdentifier:@"tabvc"];
    
    SideViewController *sideMenu = [[SideViewController alloc]init];
    //sideMenu.delegate = tableVC;//设置代理
    sideMenu.view.backgroundColor = [UIColor darkGrayColor];
    
    self.sideController = [[YRSideViewController alloc]init];
    self.sideController.rootViewController = self.tabVC;
    self.sideController.leftViewController = sideMenu;
    //self.sideController.needSwipeShowMenu = false;
    [self.sideController setNeedSwipeShowMenu:NO];
    
    self.sideController.leftViewShowWidth = 180;
    [self.sideController setRootViewMoveBlock:^(UIView *rootView, CGRect orginFrame, CGFloat xoffset) {
        rootView.frame=CGRectMake(xoffset, orginFrame.origin.y, orginFrame.size.width, orginFrame.size.height);
    }];//设置水平移动
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.window.rootViewController = nil;
    self.window.rootViewController = self.sideController;
    [self.window makeKeyAndVisible];
    
    if (![[NSUserDefaults standardUserDefaults]valueForKey:@"first"]) {
        NSArray *imagearray = @[@"YISHENGHUO-1",@"YISHENGHUO-2",@"YISHENGHUO-3",@"YISHENGHUO-4"];
        //判断第一次进入
        self.guideVC = [[ZWIntroductionViewController alloc]initWithCoverImageNames:imagearray];
        
        //加载引导页
        [self.window addSubview:self.guideVC.view];
        
        __weak AppDelegate *weakSelf = self;
        self.guideVC.didSelectedEnter = ^() {
            //加载主页面
            [UIView animateWithDuration:1 animations:^{
                weakSelf.guideVC.view.alpha = 0.0;
            } completion:^(BOOL finished) {
                [weakSelf.guideVC.view removeFromSuperview];
            }];
            
            
            
            
        };

        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"first"];
    }
    else {
        
        self.adVC = [[AdViewController alloc]init];
        //self.window.rootViewController = adVC;
        [self.window addSubview:self.adVC.view];
        [self.window makeKeyAndVisible];
        [self performSelector:@selector(delayLoad) withObject:nil afterDelay:3.0];
    }

    
    
//    self.window.rootViewController = self.sideController;
//    
//    [self.window makeKeyAndVisible];
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
    
    //百度地图
    self.mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.mapManager start:@"5RFX9KsB0KuNFplQqr1WyeIh" generalDelegate:nil];
    if (!ret) {
        NSLog(@"mapManager Start Failed!");
    }else {
        NSLog(@"BaiduMap 授权成功");
    }
    
    //添加桌面3Dtouch 图标
    UIApplicationShortcutIcon *newsIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"news60-1"];
    UIApplicationShortcutItem *news = [[UIApplicationShortcutItem alloc]initWithType:@"news" localizedTitle:@"实事新闻" localizedSubtitle:nil icon:newsIcon userInfo:nil];
    //新闻
    UIApplicationShortcutIcon *searchIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *search = [[UIApplicationShortcutItem alloc]initWithType:@"search" localizedTitle:@"搜一搜" localizedSubtitle:nil icon:searchIcon userInfo:nil];
    //搜索
    UIApplicationShortcutIcon *movieIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"movie60-1"];
    UIApplicationShortcutItem *movie = [[UIApplicationShortcutItem alloc]initWithType:@"movie" localizedTitle:@"电影" localizedSubtitle:nil icon:movieIcon userInfo:nil];
    
    //电影
    UIApplicationShortcutIcon *nearIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeLocation];
    UIApplicationShortcutItem *near = [[UIApplicationShortcutItem alloc]initWithType:@"near" localizedTitle:@"搜附近" localizedSubtitle:nil icon:nearIcon userInfo:nil];
    
    application.shortcutItems = @[search,news,movie,near];
    
    return YES;
}

#pragma mark -  3D touch 代理方法
- (void)application:(UIApplication *)application performActionForShortcutItem:(nonnull UIApplicationShortcutItem *)shortcutItem completionHandler:(nonnull void (^)(BOOL))completionHandler
{
    /** 不同跳转 */
    if ([shortcutItem.type isEqualToString:@"news"])
    {
        self.tabVC.selectedIndex = 1;
    }
    else if ([shortcutItem.type isEqualToString:@"search"]) {
        self.tabVC.selectedIndex = 0;
    }
    else if ([shortcutItem.type isEqualToString:@"movie"]) {
        self.tabVC.selectedIndex = 3;
    }
    else if ([shortcutItem.type isEqualToString:@"near"]) {
        self.tabVC.selectedIndex = 4;
    }
}

//-(instancetype)initWithSB:(NSString *) identifier inStoryBoard:(NSString *) storyboardName {
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
//    if (storyBoard) {
//        return [storyBoard instantiateViewControllerWithIdentifier:identifier];
//    }
//    else {
//        NSLog(@"No SB!");
//        return nil;
//    }
//}//封装一下storyBoard调用

//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    //如果isRotataion是YES 我们就返回横屏幕状态， 否则我们就返回竖屏状态
//    if (self.isRotation) {
//        return UIInterfaceOrientationMaskLandscapeRight;
//    }
//    else {
//    return UIInterfaceOrientationMaskPortrait;
//    }
//    
//}

//-(void) creatScrollView {
//    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
//    scroll.contentSize = CGSizeMake(screenW*4, screenH);
//    scroll.delegate = self;
//    [self.window addSubview:scroll];
//    [scroll setPagingEnabled:YES];
//    
//    
//    NSArray *imagearray = @[@"YISHENGHUO-01",@"YISHENGHUO-02",@"YISHENGHUO-03",@"YISHENGHUO-04"];
//    for (int i =0; i<4; i++) {
//        UIImage *image = [UIImage imageNamed:imagearray[i]];
//        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenW*i, 0, screenW, screenH)];
//        imageView.image = image;
//        [scroll addSubview:imageView];
//    }
//}
//
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.x > screenW*4+30) {
//        [UIView animateWithDuration:0.3 animations:^{
//            scrollView.alpha = 0.0;
//        } completion:^(BOOL finished) {
//            [scrollView removeFromSuperview];
//        }];
//    }
//}

-(void) delayLoad {
    //加载主页面
    __weak AppDelegate *weakSelf = self;
    [UIView animateWithDuration:1 animations:^{
        weakSelf.adVC.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.adVC.view removeFromSuperview];
    }];//alpha 1 - 0 渐变消失

}

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
