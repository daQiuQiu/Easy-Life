//
//  MainTabViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/1/11.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "MainTabViewController.h"
#import "TableViewController.h"
#import "SideViewController.h"
@interface MainTabViewController ()

@property (strong,nonatomic) UIViewController *NewsController;
@property (strong,nonatomic) UIViewController *SearchController;
@property (strong,nonatomic) UIViewController *VoiceController;
@property (strong,nonatomic) UIViewController *MovieController;
@property (strong,nonatomic) UIViewController *NearController;

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithControllers];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - 初始化ViewControlller
-(void)initWithControllers {
    self.tabBarController.tabBar.backgroundColor = nil;
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],
                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1]
                                                        } forState:UIControlStateNormal];
    //新闻页面
    UINavigationController *newsNaviVC = (UINavigationController *)[self initWithSB:@"newsnavi" inStoryBoard:@"NewsSB"];
    newsNaviVC.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"新闻" image:[UIImage imageNamed:@"news"] selectedImage:[[UIImage imageNamed:@"newsr"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//添加新闻页面
    
    
    
    //搜索首页
    self.SearchController = [self initWithSB:@"searchnavi" inStoryBoard:@"SearchSB"];
    self.SearchController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home"]  selectedImage:[[UIImage imageNamed:@"homer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //语音识别
    self.VoiceController = [self initWithSB:@"voiceview" inStoryBoard:@"VoiceSB"];
    self.VoiceController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"" image:[UIImage imageNamed:@"home"]  selectedImage:[[UIImage imageNamed:@"homer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    
    
    //添加所有控制器
    self.viewControllers = @[self.SearchController,newsNaviVC];

//    TableViewController *tableVC = newsNaviVC.viewControllers[0];// 拿到tableviewcontroller
//    SideViewController *sideMenu = [[SideViewController alloc]init];
//    sideMenu.delegate = tableVC;//设置代理

    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
