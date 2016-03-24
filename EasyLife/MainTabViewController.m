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
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delayMethod) name:@"changecolor" object:nil];//添加监听消息
}

-(void) delayMethod {
    [self performSelector:@selector(changeIcon) withObject:nil afterDelay:1.8f];
}//延时方法

-(void) changeIcon {
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.tabBar.layer addAnimation:transition forKey:nil];//添加1秒渐变
    
    
    int tag = [[[NSUserDefaults standardUserDefaults]objectForKey:@"tag"] intValue];
    if (tag == 0) {//蓝色图标
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                                            NSForegroundColorAttributeName : sbColor
                                                            } forState:UIControlStateSelected];//设置tab字体
        
        self.NewsController.tabBarItem.selectedImage = [[UIImage imageNamed:@"newsb"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.NearController.tabBarItem.selectedImage = [[UIImage imageNamed:@"nearb"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.SearchController.tabBarItem.selectedImage = [[UIImage imageNamed:@"homeb"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.VoiceController.tabBarItem.selectedImage = [[UIImage imageNamed:@"listenb"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.MovieController.tabBarItem.selectedImage = [[UIImage imageNamed:@"movieb"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    }
    else if (tag == 1) {//红色
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                                            NSForegroundColorAttributeName : rColor
                                                            } forState:UIControlStateSelected];//设置tab字体
        
        self.NewsController.tabBarItem.selectedImage = [[UIImage imageNamed:@"newsr"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.NearController.tabBarItem.selectedImage = [[UIImage imageNamed:@"nearr"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.SearchController.tabBarItem.selectedImage = [[UIImage imageNamed:@"homer"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.VoiceController.tabBarItem.selectedImage = [[UIImage imageNamed:@"listenr"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.MovieController.tabBarItem.selectedImage = [[UIImage imageNamed:@"movier"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else if (tag == 2) {//黄色
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                                            NSForegroundColorAttributeName : yColor
                                                            } forState:UIControlStateSelected];//设置tab字体
        
        self.NewsController.tabBarItem.selectedImage = [[UIImage imageNamed:@"newsy"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.NearController.tabBarItem.selectedImage = [[UIImage imageNamed:@"neary"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.SearchController.tabBarItem.selectedImage = [[UIImage imageNamed:@"homey"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.VoiceController.tabBarItem.selectedImage = [[UIImage imageNamed:@"listeny"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.MovieController.tabBarItem.selectedImage = [[UIImage imageNamed:@"moviey"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else if (tag == 3) {//绿色
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                                            NSForegroundColorAttributeName : gColor
                                                            } forState:UIControlStateSelected];//设置tab字体
        
        self.NewsController.tabBarItem.selectedImage = [[UIImage imageNamed:@"newsg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.NearController.tabBarItem.selectedImage = [[UIImage imageNamed:@"nearg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.SearchController.tabBarItem.selectedImage = [[UIImage imageNamed:@"homeg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.VoiceController.tabBarItem.selectedImage = [[UIImage imageNamed:@"listeng"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.MovieController.tabBarItem.selectedImage = [[UIImage imageNamed:@"movieg"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - 初始化ViewControlller
-(void)initWithControllers {
    self.tabBarController.tabBar.backgroundColor = nil;
    
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f],
                                                        NSForegroundColorAttributeName : [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:1]
                                                        } forState:UIControlStateNormal];//设置tab字体
    //新闻页面
    self.NewsController = [self initWithSB:@"newsnavi" inStoryBoard:@"NewsSB"];
    self.NewsController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"新闻" image:[UIImage imageNamed:@"news"] selectedImage:[[UIImage imageNamed:@"newsr"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];//添加新闻页面
    
    
    
    //搜索首页
    self.SearchController = [self initWithSB:@"searchnavi" inStoryBoard:@"SearchSB"];
    self.SearchController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"首页" image:[UIImage imageNamed:@"home"]  selectedImage:[[UIImage imageNamed:@"homer"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //语音识别
    self.VoiceController = [self initWithSB:@"voicenavi" inStoryBoard:@"VoiceSB"];
    self.VoiceController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"语音" image:[UIImage imageNamed:@"listen"]  selectedImage:[[UIImage imageNamed:@"listenr"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    //影讯页面
    self.MovieController = [self initWithSB:@"movienavi" inStoryBoard:@"MovieSB"];
    self.MovieController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"影讯" image:[UIImage imageNamed:@"movie"]  selectedImage:[[UIImage imageNamed:@"movier"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    //附近页面
    self.NearController = [self initWithSB:@"nearnavi" inStoryBoard:@"NearSB"];
    self.NearController.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"附近" image:[UIImage imageNamed:@"near"]  selectedImage:[[UIImage imageNamed:@"nearr"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    
    [self changeIcon];
    //添加所有控制器
    self.viewControllers = @[self.SearchController,self.NewsController,self.VoiceController,self.MovieController,self.NearController];

    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    self.tabBarController.selectedViewController = self.NewsController;
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


-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    CATransition *animation =[CATransition animation];
    [animation setDuration:0.6f];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:kCATransitionFade];
    //[animation setSubtype:kCATransitionFromRight];
    [self.view.layer addAnimation:animation forKey:@"reveal"];
    
    NSLog(@"tab动画");
}//tabbar 页面切换动画

@end
