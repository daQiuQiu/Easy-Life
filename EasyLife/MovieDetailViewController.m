//
//  MovieDetailViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/2/25.
//  Copyright © 2016年 易仁. All rights reserved.
//
/*
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 
 */

#import "MovieDetailViewController.h"
#import "MovieDataModel.h"
#import <Masonry.h>

@interface MovieDetailViewController ()

@end

CGRect rect;
BOOL isExpand = NO;
@implementation MovieDetailViewController
-(void)viewWillAppear:(BOOL)animated {
    //[self.navigationController.navigationBar setAlpha:0.9];
    //[self.navigationController.navigationBar setBackgroundColor:nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    MovieDataModel *model = [MovieDataModel initWithModel];
    [self getMovieDetailWithName:model.onMovieTitleArray[self.movieNo]];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MovieDataModel *model = [MovieDataModel initWithModel];
    UIImageView *backImageView = [[UIImageView alloc]initWithImage:model.presentImageArray1[self.movieNo]];
    backImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 250);
    [self.view addSubview:backImageView];//设置模糊背景
    [self.view bringSubviewToFront:self.backEffectView];//前置模糊View
    
    //传递参数
    //MovieDataModel *model = [MovieDataModel initWithModel];
    self.movieTitleLabel.text = model.onMovieTitleArray[self.movieNo];
    self.playdateLabel.text = model.playDate[self.movieNo];
    NSString *rating = [NSString stringWithFormat:@"%@/10.0",model.ratingArray1[self.movieNo]];
    self.ratingLabel.text = rating;
    self.cinemaNumberLabel.text = model.cinemaNumber[self.movieNo];
    self.movieImageView.image = model.presentImageArray1[self.movieNo];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //表格
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    [self creatLabel];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 电影2级接口
-(void) getMovieDetailWithName: (NSString *)movieName {
    MovieDataModel *model = [MovieDataModel initWithModel];
    
    NSString *urlString = [NSString stringWithFormat:@"http://op.juhe.cn/onebox/movie/video?key=a03146c3667f8bb788197a66b622553d&q=%@",movieName];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];//中文转码
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:20];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"2级ERROR = %@",error);
        }
        else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSString *reason = [dic objectForKey:@"reason"];
            //先判断能否查询的到
            NSDictionary *resultDic = [dic objectForKey:@"result"];
            if ([reason isEqualToString:@"查询成功"]) {
                NSString *tag = [resultDic objectForKey:@"tag"];
                NSString *area = [resultDic objectForKey:@"area"];
                NSString *desc = [resultDic objectForKey:@"desc"];
                NSLog(@"tag = %@,area = %@,",tag,area);
                model.tag = tag;
                model.area = area;
                model.desc = desc;
                UIFont *font = [UIFont fontWithName:@"Arial" size:15];
                rect = [desc boundingRectWithSize:CGSizeMake(screenW, screenH)//限制最大的宽度和高度
                                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                                        attributes:@{NSFontAttributeName:font}//传人的字体字典
                                                           context:nil];

                
            }
            else {
                NSLog(@"reason = %@",reason);
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.areaLabel.text = model.area;
            self.movieTagLabel.text = model.tag;
            self.descLabel.text = model.desc;
            NSLog(@"%@",model.desc);
            //[self.infoTableView reloadData];
            NSLog(@"UI Refresh!");
        });
        
    }];
    [datatask resume];
    
}

#pragma mark - 创建摘要Label
-(void) creatLabel {
    MovieDataModel *model = [MovieDataModel initWithModel];
    _descLabel = [[UILabel alloc]init];
    _descLabel.textColor = [UIColor darkTextColor];
    _descLabel.numberOfLines = 0;
    _descLabel.text = model.desc;
    //label
    
    _expandButton = [[UIButton alloc]init];
    
    [_expandButton setBackgroundImage:[[UIImage imageNamed:@"Dark_News_Navigation_Unnext"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_expandButton addTarget:self action:@selector(expandCell) forControlEvents:UIControlEventTouchUpInside];
    //button
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (isExpand == NO) {
            return 50;
        }
        else {
            return rect.size.height+50;
        }
    }
    else {
        return 50;
    }
}


#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDataModel *model = [MovieDataModel initWithModel];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.section == 0) {
        
            
        
        
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:15];
        _descLabel.font = font;
        
        [cell addSubview:_descLabel];//添加摘要Label
        
    
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (cell).with.insets (UIEdgeInsetsMake(0, 15, 30, 15));//设置边距
        }];
        [cell addSubview:_expandButton];
        [_expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo (CGSizeMake(40, 30));
            
            make.centerX.equalTo (cell);
            //make.bottom.equalTo (cell).with.offset (-5);
            make.top.equalTo (_descLabel.mas_bottom).with.offset (5);
        }];
        
        
    }
    else if (indexPath.section == 1){
        cell.textLabel.text = @"2";
    }
    else {
        cell.textLabel.text = @"3";
    }
    
    return cell;
}

-(void) expandCell {
    if (isExpand == NO) {
        isExpand = YES;
//        [self.descLabel removeFromSuperview];
//        [self.expandButton removeFromSuperview];
        [self.infoTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    else {
        isExpand = NO;
//        [self.descLabel removeFromSuperview];
//        [self.expandButton removeFromSuperview];
        [self.infoTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"剧情摘要";
    }
    else if (section == 1){
        return @"导演";
    }
    else {
        return @"主要演员";
    }

}

@end
