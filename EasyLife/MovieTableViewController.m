//
//  MovieTableViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/2/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "MovieTableViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDataModel.h"
#import "MovieDetailViewController.h"

@interface MovieTableViewController ()

@end
BOOL isOn = YES;//默认显示正在上映
@implementation MovieTableViewController
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self changeColor];//设置导航栏颜色
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self pullToRefresh];
    [self setSegment];
    self.title = @"电影";
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.tintColor = [UIColor whiteColor];
    [backbutton setTintColor:[UIColor whiteColor]];
    backbutton.title = @"";
    self.navigationItem.backBarButtonItem = backbutton;
    
    
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


#pragma mark - 设置SegmentControl
-(void) setSegment {
    self.statusSegment.tintColor = [UIColor colorWithRed:255 green:83 blue:106 alpha:1];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName,nil,nil];
    [self.statusSegment setTitleTextAttributes:attributes forState:UIControlStateNormal];
}
//APPKEY:a03146c3667f8bb788197a66b622553d
#pragma mark - 影讯接口（地点）
-(void) getMovieNews {
    //配置接口网络连接
    NSString *urlString = [NSString stringWithFormat:@"http://op.juhe.cn/onebox/movie/pmovie?key=a03146c3667f8bb788197a66b622553d&city=上海"];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//中文转码
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:20];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR = %@",error);
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络不给力"
                                                                           message:@"请稍后再试"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {//JSON解析
            MovieDataModel *model = [MovieDataModel initWithModel];
            model.directorArray1 = [NSMutableArray array];
            model.directorArray2 = [NSMutableArray array];
            model.onMovieTitleArray = [NSMutableArray array];
            model.willOnMovieTitleArray = [NSMutableArray array];
            model.ratingArray1 = [NSMutableArray array];
            model.ratingArray2 = [NSMutableArray array];
            model.descArray1 = [NSMutableArray array];
            model.descArray2 = [NSMutableArray array];
            model.iconUrlArray1 = [NSMutableArray array];
            model.iconUrlArray2 = [NSMutableArray array];
            model.playDate = [NSMutableArray array];
            model.cinemaNumber = [NSMutableArray array];
            model.directorLinkArray = [NSMutableArray array];
            
            //model数组初始化
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            //NSLog(@"data = %@",dic);
            NSDictionary *dic1 = [dic objectForKey:@"result"];
            NSArray *dataArray = [dic1 objectForKey:@"data"];
            NSLog(@"array count = %lu",(unsigned long)[dataArray count]);
            for (NSDictionary *l1dic in dataArray) {
                
                
                NSArray *dataArray2 = [l1dic objectForKey:@"data"];
                for (NSDictionary *dic in dataArray2) {
                    NSDictionary *direcDic = [dic objectForKey:@"director"];
                    NSDictionary *dic11 = [direcDic objectForKey:@"data"];
                    NSDictionary *dic22 = [dic11 objectForKey:@"1"];
                    
                    
                    NSString *movieStatus = [l1dic objectForKey:@"name"];
                    //NSLog(@"状态 = %@",movieStatus);//拿到电影状态
                    
                    NSString *directorName = [dic22 objectForKey:@"name"];
                    NSString *directorLink = [dic22 objectForKey:@"link"];
                    //NSLog(@"director = %@",directorName);//拿到导演名字
                    
                    NSString *grade = [dic objectForKey:@"grade"];
                    //NSLog(@"grade = %@",grade);//拿到评分
                    NSString *movieTitle = [dic objectForKey:@"tvTitle"];
                    //NSLog(@"Movie = %@",movieTitle);//拿到电影名字
                    //[self getMovieDetailWithName:movieTitle];
                    NSString *iconAddress = [dic objectForKey:@"iconaddress"];
                    //NSLog(@"pic = %@",iconAddress);//拿到图片地址
                    
                    NSDictionary * briefDic = [dic objectForKey:@"story"];
                    NSDictionary *briefDic1 = [briefDic objectForKey:@"data"];
                    //NSLog(@"briefDic = %@",briefDic1);
                    NSString *briefStory = [briefDic1 objectForKey:@"storyBrief"];
                    //NSLog(@"故事概要 = %@",briefStory);//拿到故事概要
                    
                    NSDictionary *playdate = [dic objectForKey:@"playDate"];
                    NSString *date = [playdate objectForKey:@"data"];
                    //NSLog(@"上映日期 = %@",date);//拿上映日期
                    
                    //分类储存
                    if ([movieStatus isEqualToString:@"正在上映"]) {
                        //NSLog(@"添加正在上映的电影");
                        [model.directorArray1 addObject: directorName];//导演
                        [model.descArray1 addObject:briefStory];//概述
                        [model.onMovieTitleArray addObject:movieTitle];//电影名字
                        [model.iconUrlArray1 addObject:iconAddress];
                        [model.playDate addObject:date];
                        [model.directorLinkArray addObject:directorLink];//导演信息链接
                        if (grade) {
                            [model.ratingArray1 addObject:grade];//评分
                        }
                        else {
                            [model.ratingArray1 addObject:@"0.0"];
                        }
                        
                        
                        NSString *cinemaNumber = [dic objectForKey:@"subHead"];
                        [model.cinemaNumber addObject:cinemaNumber];//上映影院数量
                    }
                    else if ([movieStatus isEqualToString:@"即将上映"]){
                        //NSLog(@"添加即将上映的电影");
                        
                        [model.ratingArray2 addObject:date];
                        [model.directorArray2 addObject:directorName];
                        [model.descArray2 addObject:briefStory];
                        [model.willOnMovieTitleArray addObject:movieTitle];
                        [model.iconUrlArray2 addObject:iconAddress];
                    }
                }

            }
            //NSDictionary *datadic2 = dataArray[0];
            
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.tableView reloadData];
            NSLog(@"数据加载完成，重新加载表格");
            [self getMovieImage];
            
            //[self getMovieDetailWithName:nil];
        });
    }];
    [datatask resume];
}

#pragma mark - 解析电影封面
-(void) getMovieImage {
    MovieDataModel *model = [MovieDataModel initWithModel];
    model.presentImageArray1 = [NSMutableArray array];
    model.presentImageArray2 = [NSMutableArray array];
    UIImage *image1 = [[UIImage alloc]init];//上映影片封面
    UIImage *image2 = [[UIImage alloc]init];//即将上映影片封面
    for (int i = 0; i < [model.iconUrlArray1 count]; i++) {
        image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[model.iconUrlArray1 objectAtIndex:i]]]];
        [model.presentImageArray1 addObject:image1];
    }
    for (int i = 0; i < [model.iconUrlArray2 count]; i++) {
        image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[model.iconUrlArray2 objectAtIndex:i]]]];
        [model.presentImageArray2 addObject:image2];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MovieDataModel *model = [MovieDataModel initWithModel];
    if ([model.onMovieTitleArray count] > 0) {
        return [model.onMovieTitleArray count];
    }
    else if ([model.willOnMovieTitleArray count] > 0){
        return [model.willOnMovieTitleArray count];
    }
    else {
        return 5;
    }
    
}

#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MovieDataModel *model = [MovieDataModel initWithModel];
    if (cell == nil) {
        cell = [[MovieTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([model.onMovieTitleArray count] > 0) {
        
    
    if (isOn == YES) {
        cell.titleLabel.text = model.onMovieTitleArray[indexPath.row];
        //NSLog(@"title = %@",model.onMovieTitleArray);
        NSString *directorName = [NSString stringWithFormat:@"%@ 作品",model.directorArray1[indexPath.row]];
        cell.directorLabel.text = directorName;
        cell.descLabel.text = model.descArray1[indexPath.row];
        cell.descLabel.numberOfLines = 0;
        cell.ratingLabel.font = [UIFont systemFontOfSize:16];
        cell.ratingLabel.text = model.ratingArray1[indexPath.row];
        cell.movieImage.image = model.presentImageArray1[indexPath.row];
    }else {
        NSLog(@"显示即将上映的电影");
        cell.titleLabel.text = model.willOnMovieTitleArray[indexPath.row];
        NSString *directorName = [NSString stringWithFormat:@"%@ 作品",model.directorArray2[indexPath.row]];
        cell.directorLabel.text = directorName;
        cell.descLabel.text = model.descArray2[indexPath.row];
        cell.descLabel.numberOfLines = 0;
        cell.ratingLabel.font = [UIFont systemFontOfSize:12];
        cell.ratingLabel.text = model.ratingArray2[indexPath.row];
        cell.movieImage.image = model.presentImageArray2[indexPath.row];
        }
        [self.tableView.mj_header endRefreshing];
    }
    else {
        NSLog(@"数据加载不成功");
    }
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isOn == YES) {
        MovieDataModel *model = [MovieDataModel initWithModel];

        MovieDetailViewController *movieDetailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"moviedetail"];
        movieDetailVC.movieNo = indexPath.row;

        NSLog(@"选择的电影 = %@",model.onMovieTitleArray[indexPath.row]);
        [self.navigationController pushViewController:movieDetailVC animated:YES];
        movieDetailVC.movieNo = indexPath.row;
        NSLog(@"number = %ld",movieDetailVC.movieNo);
            
       
        
    }

}

#pragma mark - 电影segment点击方法
- (IBAction)changeMovieStatus:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        if (isOn == NO) {
            isOn = YES;
            [self.tableView reloadData];
        }
        NSLog(@"显示正在上映");
        
    }
    else {
        
        NSLog(@"显示即将上映");
        if (isOn == YES) {
            isOn = NO;
            [self.tableView reloadData];
        }
    }
    
}

#pragma mark - 下拉刷新
-(void) pullToRefresh {
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getMovieNews];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 电影detail搜索接口
//-(void) getMovieDetailWithName: (NSString *)movieName {
//    MovieDataModel *model = [MovieDataModel initWithModel];
//    model.area = [NSMutableArray array];
//    model.tag = [NSMutableArray array];
//    
//        NSString *urlString = [NSString stringWithFormat:@"http://op.juhe.cn/onebox/movie/video?key=a03146c3667f8bb788197a66b622553d&q=%@",movieName];
//        urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//中文转码
//        NSURL *url = [NSURL URLWithString:urlString];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:20];
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if (error) {
//                NSLog(@"2级ERROR = %@",error);
//            }
//            else {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//                NSString *reason = [dic objectForKey:@"reason"];
//                //先判断能否查询的到
//                NSDictionary *resultDic = [dic objectForKey:@"result"];
//                if ([reason isEqualToString:@"查询成功"]) {
//                    NSString *tag = [resultDic objectForKey:@"tag"];
//                    NSString *area = [resultDic objectForKey:@"area"];
//                    
//                    NSLog(@"tag = %@,area = %@,",tag,area);
//                    [model.tag addObject:tag];
//                    [model.area addObject:area];
//                    
//                }
//                else {
//                    NSLog(@"reason = %@",reason);
//                }
//                
//            }
//            
//        }];
//        [datatask resume];
//
//    }
//

@end
