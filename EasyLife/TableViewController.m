//
//  TableViewController.m
//  NewsDemo
//
//  Created by 易仁 on 16/1/12.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "TableViewController.h"
#import "DataLoading.h"
#import "NewsDetailViewController.h"
#import "AppDelegate.h"
#import "PeekViewController.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height


@interface TableViewController ()
@property(nonatomic,strong)UIScrollView *topScr;
@property (nonatomic,strong)UIPageControl *page;
//@property (nonatomic,strong) NSMutableArray *imagearray;
@property (nonatomic,strong) NSMutableArray *defaultImageArray;
@property (nonatomic,strong) TableViewController *tableController;


@end
CGFloat positionY;
NSDictionary *fontdic;
int titleTag = 0;
int timeCount = 0;
BOOL isClear = YES;
BOOL isLoading = NO;
@implementation TableViewController

-(void)viewWillAppear:(BOOL)animated {
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //设置自动调整布局用，NO 会使tabbar 挡住最后一行cell
    
    self.navigationController.navigationBarHidden = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //self.tabBarController.tabBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    if (isClear == YES) {
        NSLog(@"透明");
    }
    else {
        [self changeColor];//改变主题色
    }
    
    NSLog(@"ViewWillAppear");
    
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"idKey"]) {
        NSLog(@"ID 改变了");
        [self getNewsWithChannelID:nil];
    }
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForPreviewingWithDelegate:self sourceView:self.view];//注册3dtouch方法
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;//不显示滑动条
    NSLog(@"ViewDidLoad!");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationToRefresh) name:@"refreshnews" object:nil];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
     //self.imagearray = [NSMutableArray array];
    DataLoading *model = [DataLoading initWithModel];
    //[model setValue:@"5572a109b3cdc86cf39001db" forKey:@"idKey"];
    //model.channelId = [NSMutableString stringWithFormat:@"%@",[model valueForKey:@"idKey"]];
//    [model addObserver:self forKeyPath:@"price" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    NSLog(@"fuzhi:%@",model.channelId);
    
    //self.tableController = [[TableViewController alloc]init];
    //[self.tableController setValue:@"5572a109b3cdc86cf39001db" forKey:@"ID"];
    //model.channelId = [model.channelId valueForKey:@"ID"];
//    UIImage *image = [[UIImage alloc]init];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = image;
//    self.navigationController.navigationBar.translucent = YES;
    UIColor * color = [UIColor whiteColor];
    fontdic = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = fontdic;
    [self notificationToRefresh];//默认载入新闻
    

}

#pragma mark - 添加滑动手势 
//-(void) creatGesture {
//    UISwipeGestureRecognizer *swipeRight;
//    swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(showSideMenu)];
//    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
//    
//    [self.tableView addGestureRecognizer:swipeRight];
//}
//
//-(void) showSideMenu {
//    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    YRSideViewController *sideViewController=[delegate sideController];
//    [sideViewController showLeftViewController:true];
//}

#pragma mark - 通知刷新方法
-(void) notificationToRefresh {
    //[self removeScrollView];
    DataLoading *model = [DataLoading initWithModel];
    [self pullToRefresh];
    self.navigationItem.title = @"今日热闻";

    if (model.chosenindex == 0) {
        self.navigationItem.title = @"今日热闻";
    }
    else if (model.chosenindex > 0){
        self.navigationItem.title = model.cateArray[model.chosenindex];
    }
    else {
        self.navigationItem.title = @"今日热闻";
    }
}

#pragma mark - 创建顶部Scroll

-(void)creatScrollView {
    DataLoading *model = [DataLoading initWithModel];
    self.defaultImageArray = [NSMutableArray array];
//    if ([model.imageArray count] ) {//图片大于3张
        NSLog(@"图片大于3张");
    self.topScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenW, 200)];
    self.topScr.showsHorizontalScrollIndicator = NO;
    _topScr.contentSize = CGSizeMake(screenW*4, 200);
    _topScr.pagingEnabled = YES;
    _topScr.bounces = NO;
    _topScr.delegate = self;
        
    
    self.page = [[UIPageControl alloc]initWithFrame:CGRectMake((screenW-50)/2.0, 160, 50, 50)];
    self.page.numberOfPages = 4;
    self.page.tag = 201;
    for (int i = 0; i < 4; i++) {

        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(screenW*i, 0, screenW, 200)];
        image.userInteractionEnabled = YES;
        image.backgroundColor = [UIColor grayColor];
        image.contentMode = UIViewContentModeScaleAspectFill ;
        image.clipsToBounds = YES;
        [self.topScr addSubview:image];
        image.tag = i+200;
        [self.defaultImageArray addObject:image];
        NSLog(@"加载图片 %lu",(unsigned long)[self.defaultImageArray count]);
        NSLog(@"imagarray:%ld",[model.imageArray count]);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        [image addGestureRecognizer:tap];
    }
//    }
//    else {//加载图片不足3张
//        NSLog(@"图片不足3张");
//        unsigned long imageNum = [model.imageArray count];
//        NSLog(@"imagearray:%ld", imageNum);
//        self.topScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenW, 200)];
//        _topScr.contentSize = CGSizeMake(screenW*imageNum, 200);
//        _topScr.pagingEnabled = YES;
//        _topScr.bounces = NO;
//        _topScr.delegate = self;
//        self.page = [[UIPageControl alloc]initWithFrame:CGRectMake((screenW-50)/2.0, 160, 50, 50)];
//        self.page.numberOfPages = imageNum;
//        self.page.tag = 201;
//        
//        for (int i = 0; i < imageNum; i++) {
//            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(screenW*i, 0, screenW, 200)];
//            image.userInteractionEnabled = YES;
//            image.backgroundColor = [UIColor grayColor];
//            image.contentMode = UIViewContentModeScaleAspectFill ;
//            image.clipsToBounds = YES;
//            [self.topScr addSubview:image];
//            image.tag = i+200;
//            [self.defaultImageArray addObject:image];
//            NSLog(@"加载图片 %lu",(unsigned long)[self.defaultImageArray count]);
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
//            [image addGestureRecognizer:tap];
//        }
//
//
//    }
    //设置timer
   self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];

    
    self.tableView.tableHeaderView = self.topScr;
    //[self.tableView.tableHeaderView addSubview:_topScr];
    [self.view addSubview:self.page];
    [self.tableView reloadData];
    
}
#pragma mark - 定时翻页



-(void)scrollTimer{
    timeCount ++;
    if (timeCount == 4) {
        timeCount = 0;
    }
    [self.topScr scrollRectToVisible:CGRectMake(timeCount * screenW, 0, screenW, 200) animated:YES];
    self.page.currentPage = timeCount;
}



-(void) tapped {
    NSLog(@"点击 %ld", (long)self.page.currentPage);
    NewsDetailViewController *newsD = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
    [self.navigationController pushViewController:newsD animated:YES];
    newsD.navigationController.navigationBarHidden = YES;
    
    DataLoading *model = [DataLoading initWithModel];
    newsD.url = model.urlArray[self.page.currentPage];
    newsD.newsTag = self.page.currentPage;
    
}

#pragma  mark - Scroll Delegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentPage = self.topScr.contentOffset.x/screenW;
    self.page.currentPage = currentPage;
    timeCount = currentPage;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    positionY= scrollView.contentOffset.y;//获取Y的数据
    //CGFloat positionX = scrollView.contentOffset.x;
    //NSLog(@"xxxxxxxxxxxxxxx%f",positionX);
    //NSLog(@"yyyyyyyyyyyyyyy%f",positionY);
    if (positionY != 0){//给navigationbar加颜色
        if (positionY > 0 && positionY != 128) {
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self changeColor];
            [self.navigationController.navigationBar setAlpha:(positionY)/160.0];
            //设置navigationbar title
            
                       // NSLog(@"取消透明");
            //self.navigationController.navigationBar.shadowImage = [UIImage new];
            isClear = NO;
        }
        else if (positionY <= 0 && positionY >= -64) {//重新让navigationbar 透明
            [self.navigationController.navigationBar setAlpha:0.9];
            [self.navigationController.navigationBar setBackgroundColor:nil];
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.shadowImage = [UIImage new];
            self.navigationController.navigationBar.translucent = YES;
            //self.navigationController.navigationBar.hidden = YES;
            isClear = YES;
            //NSLog(@"需要透明");
        
        }
        else if (positionY < 0){
//            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//            [self.navigationController.navigationBar setBarTintColor:kColor(23, 144, 211, 1)];
//            [self.navigationController.navigationBar setAlpha:1];
            //self.navigationController.navigationBarHidden = YES;
        }
        else if (positionY == -160.0){
        //[self.topScr removeFromSuperview];
        NSLog(@"不等于0");
        }
    }
    

//    if (position < - 214) {
//        self.tableView.bounces = NO;
//    }
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 改变导航栏颜色
-(void) changeColor {
    int tag = [[[NSUserDefaults standardUserDefaults]objectForKey:@"tag"] intValue];
    if (tag == 0) {//蓝色图标
        [self.navigationController.navigationBar setBarTintColor:bColor];
    }
    else if (tag == 1) {//红色
        [self.navigationController.navigationBar setBarTintColor:rColor];
    }
    else if (tag == 2) {//黄色
        [self.navigationController.navigationBar setBarTintColor:yColor];
    }
    else if (tag == 3) {//绿色
        [self.navigationController.navigationBar setBarTintColor:gColor];
    }
    
}




#pragma mark - 拿新闻类别
-(void) chooseCatelogue {
    NSLog(@"init!");

        NSLog(@"dataloading init?");
        NSString *urlString = [NSString stringWithFormat:@"http://apis.baidu.com/showapi_open_bus/channel_news/channel_news"];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        request.HTTPMethod = @"get";
        [request setValue:@"48d0498b92b758d3e0d5119c69c08a94" forHTTPHeaderField:@"apikey"];
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                NSLog(@"error:%@",error);
            }
            else {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSDictionary *dic2 = [dic objectForKey:@"showapi_res_body"];
                NSMutableArray *array = [dic2 objectForKey:@"channelList"];
                DataLoading *model = [DataLoading initWithModel];
                model.Array = [NSMutableArray array];
                [model.Array addObjectsFromArray:array];
                //NSLog(@"%ld",[model.Array count]);
                for (NSDictionary *dicc in array) {
                    
                    NSString *name = [dicc valueForKey:@"name"];
                    //NSLog(@"%@",name);
                    if ([name isEqualToString:@"体育焦点"]) {
                        NSMutableString *channelId = [dicc valueForKey:@"channelId"];
                        NSLog(@"ID is %@",channelId);
                        DataLoading *model = [DataLoading initWithModel];
                        model.channelId = channelId;
                        NSLog(@"IDdata is %@",model.channelId);
                    }
                    
                    
                    //NSLog(@"channelId  ===    %@",model.channelId);
                }
                
                
                
                //NSLog(@"data is %@",channelData.Array);
                
//                [self getNews];
                
                
            }
        }];
    
    
        [dataTask resume];
        ;
    
    
}

#pragma mark - 调试打印
-(void)display {
    DataLoading *model = [DataLoading initWithModel];
    
    NSLog(@"data getting");
    NSLog(@"DATA ==== %@",model.channelId);
    NSLog(@"%ld",[model.newsTitleArray count]);
}

#pragma mark -Private methods
- (void)sideMenuClick:(NSString *)channelId
{
    [self getNewsWithChannelID:channelId];
}

#pragma mark - 得到新闻内容
-(void)getNewsWithChannelID:(NSString *)channelId {
    
    DataLoading *model = [DataLoading initWithModel];
    NSString *channelid = model.channelId;
    NSLog(@"newsID is%@",channelid);
    
    if (channelId) {
        channelId = channelId;
    }
    
    NSString *url = @"http://apis.baidu.com/showapi_open_bus/channel_news/search_news";
    NSString *argu = [NSString stringWithFormat:@"channelId=%@&page=1",channelid];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",url,argu];
    NSLog(@"%@",urlString);
    NSURL *dataurl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:dataurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    request.HTTPMethod = @"get";
    [request setValue:@"48d0498b92b758d3e0d5119c69c08a94" forHTTPHeaderField:@"apikey"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络不给力"
                                                                           message:@"请稍后再试"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSLog(@"JSON%@",dic);
            NSDictionary *dic1 = [dic objectForKey:@"showapi_res_body"];
            NSDictionary *dic2 = [dic1 objectForKey:@"pagebean"];
            NSMutableArray *array = [dic2 objectForKey:@"contentlist"];
            //NSLog(@"数据：%@",array);
            DataLoading *model = [DataLoading initWithModel];
            model.newsTitleArray = [NSMutableArray array];
            model.imageArray = [NSMutableArray array];
            model.urlArray = [NSMutableArray array];
            model.tagArray = [NSMutableArray array];
            for (NSDictionary *dic in array) {
                NSString *title = [dic objectForKey:@"title"];
                NSString *newsurl = [dic objectForKey:@"link"];
                NSDictionary *tagDic = [dic objectForKey:@"sentiment_tag"];
                if (tagDic) {
                    NSString *tag = [tagDic objectForKey:@"name"];
                    [model.tagArray addObject:tag];
                    //NSLog(@"tag = %@",tag);
                }
                else {
                    NSString *notag = @" ";
                    [model.tagArray addObject:notag];
                }
                NSLog(@"%@",title);
                NSLog(@"%@",newsurl);
                [model.newsTitleArray addObject:title];
                [model.urlArray addObject:newsurl];

                NSMutableArray *imageurl = [dic objectForKey:@"imageurls"];
                
                if ([imageurl count] == 0) {
                    
                    NSString *noImageurl = [NSString stringWithFormat:@"http://pic21.nipic.com/20120606/8671112_194118074339_2.jpg"];
                    noImageurl = [noImageurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                    [model.imageArray addObject:noImageurl];
                }
                else {
                    NSDictionary *imagedic = imageurl[0];
                    NSString *imageurlstring = [imagedic objectForKey:@"url"];
                    [model.imageArray addObject:imageurlstring];
                }//取第一张图片，如果没有  自动使用备用图
                
//                if (imageurl == nil) {
//                    [imageurl addObject:@"x"];
//                }
//                NSLog(@"imagedic is aaaa%@",[dic objectForKey:@"imageurls"]);
                //NSLog(@"存数组：%@",imageurl);
//                NSLog(@"%ld",[imageurl count]);
//                [model.imageArray addObjectsFromArray:imageurl];
//                NSLog(@"%ld",[model.imageArray count]);
//                for (NSDictionary *imagedic in imageurl) {
//                    
//                    //NSLog(@"arrar is%@",model.imageArray);
//                }
            }
            
            
            

        }
        dispatch_async(dispatch_get_main_queue(), ^{
          
            NSLog(@"123 load");
            [self getImage];
            if (self.timer) {
                //[self.timer invalidate];
            }
            if (self.topScr == nil) {
                [self creatScrollView];
            }
            
        });

    }];

    [dataTask resume];
    
    
    
}

#pragma mark - 加载图片
-(void) getImage {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        DataLoading *model = [DataLoading initWithModel];
        UIImage *image = [[UIImage alloc]init];
        model.imagePresentArray = [NSMutableArray array];
        if ([model.imageArray count] > 0) {
        NSLog(@"图片链接数量：%ld",[model.imageArray count]);
        for (int i =0; i< [model.imageArray count] ; i++) {
            if (image) {
                
            
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[model.imageArray objectAtIndex:i]]]];
                if (image) {
                    [model.imagePresentArray addObject:image];
                }
                else {
                    NSLog(@"图片加载失败");
                }
            
            }
            
        }
        
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.tableView reloadData];
            //[self creatScrollView];
            if ([model.imagePresentArray count] > 3) {//图片大于4张加载4张
                for (int i = 0; i < 4; i++) {
                for (UIImageView *imageview in self.topScr.subviews) {
                    if (imageview.tag == i+200 ) {
                        imageview.image = model.imagePresentArray[i];
                    }
                }
                }
                //NSLog(@"Table Reloaded!");
                //[self.tableView reloadData];
            }
            else {//图片不足4张加载实际图片数量
                for (int i = 0; i < [model.imagePresentArray count]; i++) {
                    for (UIImageView *imageview in self.topScr.subviews) {
                        if (imageview.tag == i+200 ) {
                            imageview.image = model.imagePresentArray[i];
                        }
                    }
                }
                
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Table Reloaded!");
                
                [self.tableView reloadData];
                
                [self.tableView.mj_header endRefreshing];
                self.tableView.userInteractionEnabled = YES;
                self.sideMenuButton.enabled = YES;
            });
            
            
            
        });
    });
    //[self.tableView reloadData];
    
}
     

     
     
    


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DataLoading *model = [DataLoading initWithModel];
    if ([model.imageArray count] > 0) {
        return [model.newsTitleArray count];
        
        
        
    }
    else {
        return 5;
    }
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 224;
//}






//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NewsTableViewCell *imcell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        DataLoading *model = [DataLoading initWithModel];
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[model.imageArray objectAtIndex:indexPath.row]]]];
//        imcell.cellImage.image = image;
//        NSLog(@"%ld",[model.imageArray count]);
//    });
//    
//    
//    
//}
#pragma mark - 配置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *cellidentifier = @"Cell";
//    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
//    if (cell == nil) {
//        cell = [[NewsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellidentifier];
//    }
   
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    DataLoading *model = [DataLoading initWithModel];
    if ([model.imagePresentArray count] > 0 && indexPath.row < [model.imagePresentArray count] && [model.newsTitleArray count] != 0) {
        NSLog(@"Title 数量:%lu",(unsigned long)[model.newsTitleArray count]);
        NSLog(@"Image 数量:%lu",(unsigned long)[model.imagePresentArray count]);
        
        int tag = (arc4random() % 900) + 100;
        NSString *comment = [NSString stringWithFormat:@"%d评",tag];
        //评论数随机
        cell.cellImage.image = model.imagePresentArray[indexPath.row];
        cell.cellImage.clipsToBounds = YES;
        [cell.cellTitle sizeToFit];
        [cell.tagTitle sizeToFit];
        [cell.commentTitle sizeToFit];
        [cell.cellTitle setNumberOfLines:0];
        cell.cellTitle.text = model.newsTitleArray[indexPath.row];
        cell.tagTitle.text = model.tagArray[indexPath.row];
        cell.commentTitle.text = comment;
        [self.tableView setSeparatorColor:[UIColor grayColor]];
                // Configure the cell...
        NSLog(@"配置cell");

    }
    else {
        cell.cellImage.backgroundColor = [UIColor grayColor];
        cell.cellTitle.text = nil;
        [cell.cellTitle setNumberOfLines:0];
        [self.tableView setSeparatorColor:[UIColor grayColor]];
        // Configure the cell...
        NSLog(@"配置cell");

    }
    
    
    //cell.cellImage.image = self.imagearray[indexPath.row];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[model.imageArray objectAtIndex:indexPath.row]]]];
//        cell.cellImage.image = image;
//        NSLog(@"%@",model.imageArray[indexPath.row]);
//        [self.tableView reloadData];
//    });
    
    

    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 128;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsDetailViewController *newsD = [self.storyboard instantiateViewControllerWithIdentifier:@"webview"];
    DataLoading *model = [DataLoading initWithModel];
    if (indexPath.row < [model.urlArray count]) {
        
        newsD.url = model.urlArray[indexPath.row];
        newsD.newsTag = indexPath.row;
        newsD.image = model.imagePresentArray[indexPath.row];
        newsD.newsTitle = model.newsTitleArray[indexPath.row];
        NSLog(@"%ld",indexPath.row);
    }

    [self.navigationController pushViewController:newsD animated:YES];
    newsD.navigationController.navigationBarHidden = YES;
    
}


#pragma mark - sideMenu显示

- (IBAction)sideMenuShow:(UIBarButtonItem *)sender {
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideController];
    [sideViewController showLeftViewController:true];
}

#pragma mark - 下拉刷新方法
-(void)pullToRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNewsWithChannelID:nil];
        
        
        
        //[self.tableView.mj_header endRefreshing];
    }] ;
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.userInteractionEnabled = NO;
    self.sideMenuButton.enabled = NO;
    
}

-(void) removeScrollView {
    [self.topScr removeFromSuperview];
}

-(void) pullToRe {//测试方法
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getNewsWithChannelID:nil];
        
        [header endRefreshing];
        

    }];
    
    
    [self.view addSubview:header];
    [header beginRefreshing];
    
}

#pragma mark - Stop Timer

-(void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"timer expired");
}

#pragma mark - previewingDelegate
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier  isEqual: @"showdetail"]) {
//        //PeekViewController *peekVC  = [[PeekViewController alloc]init];
//        
//        //[self.navigationController popToViewController:peekVC animated:YES];
//    }
//}

-(UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    PeekViewController *childVC = [[PeekViewController alloc] init];
    childVC.preferredContentSize = CGSizeMake(0.0f,screenH-100.0f);
    [self getShouldShowRectAndIndexPathWithLocation:location];
    DataLoading *model = [DataLoading initWithModel];
    if (self.indexPath.row >= 0) {
        childVC.url = model.urlArray[self.indexPath.row];
        CGRect rect = self.sourceRect;
        previewingContext.sourceRect = rect;
    }
    
    return childVC;
}


- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self tableView:self.tableView didSelectRowAtIndexPath:self.indexPath];
}

- (BOOL)getShouldShowRectAndIndexPathWithLocation:(CGPoint)location {
    NSInteger row = (location.y -200)/96;
    self.sourceRect = CGRectMake(0, row * 96+200 , screenW, 94);
    self.indexPath = [NSIndexPath indexPathForItem:row inSection:0];
    NSLog(@"%ld",self.indexPath.row);
    return  YES;
}

@end
