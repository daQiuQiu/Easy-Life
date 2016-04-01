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
#import "movieWebViewController.h"
#import "movieDetailTableViewCell.h"


@interface MovieDetailViewController () {
    
}

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
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
    
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
    NSString *cinemaNumber = [NSString stringWithFormat:@"上海%@",model.cinemaNumber[self.movieNo]];
    self.cinemaNumberLabel.text = cinemaNumber;
    self.movieImageView.image = model.presentImageArray1[self.movieNo];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    //表格
    self.infoTableView.delegate = self;
    self.infoTableView.dataSource = self;
    
    self.infoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self creatLabel];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 电影2级接口
-(void) getMovieDetailWithName: (NSString *)movieName {
    MovieDataModel *model = [MovieDataModel initWithModel];
    model.star1Array = [NSMutableArray array];
    model.starImageUrlArray = [NSMutableArray array];
    model.starLinkArray = [NSMutableArray array];
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
                
                NSArray *starArray = [resultDic objectForKey:@"act_s"];
                for (NSDictionary *dic in starArray) {
                    
                    NSString *starName = [dic objectForKey:@"name"];
                    
                    if (starName) {
                        NSString *starImagrUrl = [dic objectForKey:@"image"];
                        NSString *starLink = [dic objectForKey:@"url"];
                        //NSLog(@"star TU = %@",starImagrUrl);
                        [model.star1Array addObject:starName];
                        if (starImagrUrl == nil ||[starImagrUrl isKindOfClass:[NSNull class]]) {

                            NSString *noImageurl = [NSString stringWithFormat:@"http://h.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=05e1074ebf096b63814c56563c03ab7c/8b82b9014a90f6037c2a5c263812b31bb051ed3d.jpg"];
                            noImageurl = [noImageurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                            [model.starImageUrlArray addObject:noImageurl];
                            
                        }
                        else {
                            [model.starImageUrlArray addObject:starImagrUrl];
                            
                        }
                        [model.starLinkArray addObject:starLink];
//                        if ([starLink isKindOfClass:[NSNull class]]) {
//                            NSString *noLink = [NSString stringWithFormat:@"http://baidu.com/"];
//                            [model.starLinkArray addObject:noLink];
//                        }
//                        else {
//                            [model.starLinkArray addObject:starLink];
//                        }
                        
                    }
                    
                }
                model.tag = tag;
                model.area = area;
                //model.desc = desc;
                //这边设置string行间距
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:desc];
                NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc]init];
                [paraStyle setLineSpacing:10];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, [desc length])];
                model.desc = attributedString;
//                UIFont *font = [UIFont fontWithName:@"Arial" size:15];
//                rect = [desc boundingRectWithSize:CGSizeMake(screenW, screenH)//限制最大的宽度和高度
//                                                           options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
//                                                        attributes:@{NSFontAttributeName:font}//传人的字体字典
//                                                           context:nil];

                
            }
            else {
                NSLog(@"reason = %@",reason);
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.areaLabel.text = model.area;
            self.movieTagLabel.text = model.tag;
            self.descLabel.attributedText = model.desc;
            [self.descLabel sizeToFit];
            NSLog(@"frame = %f",(self.descLabel.bounds.size.height));
            NSLog(@"%@",model.desc);
            [self getImage];
            NSLog(@"UI Refresh!");
        });
        
    }];
    [datatask resume];
    
}

#pragma mark - 创建摘要Label
-(void) creatLabel {
    //MovieDataModel *model = [MovieDataModel initWithModel];
    _descLabel = [[UILabel alloc]init];
    _descLabel.textColor = [UIColor darkTextColor];
    _descLabel.numberOfLines = 0;
    //label
    
    _expandButton = [[UIButton alloc]init];
    self.expandButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.expandButton setTitle:@"展开" forState:UIControlStateNormal];
    [self.expandButton setTitleColor:[UIColor colorWithRed:20/255.0 green:143/255.0 blue:250/255.0 alpha:1]forState:UIControlStateNormal];
    [_expandButton addTarget:self action:@selector(expandCell) forControlEvents:UIControlEventTouchUpInside];
    //button
    
    self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(expandCell)];
    self.tap.numberOfTapsRequired = 1;
    self.tap.numberOfTouchesRequired = 1;//cell单击手势
    
    self.playTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playMovie)];
    self.playTap.numberOfTapsRequired = 1;
    self.playTap.numberOfTouchesRequired = 1;//cell单击手势
    [self.backEffectView addGestureRecognizer:self.playTap];
}

#pragma mark - 加载图片
-(void) getImage {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        MovieDataModel *model = [MovieDataModel initWithModel];
        UIImage *image = [[UIImage alloc]init];
        model.starPresentImageArray = [NSMutableArray array];
        NSLog(@"图片链接数量：%ld",[model.starImageUrlArray count]);
        if ([model.starImageUrlArray count] > 0) {
            
            for (int i =0; i< [model.starImageUrlArray count] ; i++) {
                if (image) {
                    
                    
                    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[model.starImageUrlArray objectAtIndex:i]]]];
                    if (image) {
                        [model.starPresentImageArray addObject:image];
                    }
                    else {
                        NSLog(@"图片加载失败");
                    }
                    
                }
                
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.infoTableView reloadData];
            NSLog(@"图片加载完成Reload Table!");
            
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MovieDataModel *model = [MovieDataModel initWithModel];
    if (section == 2) {
        if ([model.star1Array count] > 0) {
            NSLog(@"%lu",(unsigned long)[model.star1Array count]);
            return [model.star1Array count];
            
        }
        else {
            NSLog(@"%lu",(unsigned long)[model.star1Array count]);

            return 1;
            }
    }
    else {
       return 1;
    }
    
    
    
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (isExpand == NO) {
            return 130;
        }
        else {
            if (self.descLabel.bounds.size.height >10) {
                return (int)self.descLabel.bounds.size.height+70;
            }
            else {
                return 130;
            }
            
        }
    }
    else if (indexPath.section == 1) {
        return 60;
    }
    else {
        return 80;
    }
}


#pragma mark - TableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDataModel *model = [MovieDataModel initWithModel];
    
    movieDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = NO;
    if (cell == nil) {
        cell = [[movieDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.userInteractionEnabled = NO;
    }
    if (indexPath.section == 0) {
        
            
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIFont *font = [UIFont fontWithName:@"Arial" size:15];
        _descLabel.font = font;
        [cell addGestureRecognizer:self.tap];
        [cell addSubview:_descLabel];//添加摘要Label
        
    
        [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (cell).with.insets (UIEdgeInsetsMake(10, 15, 30, 15));
            //设置边距
            
        }];
        [cell addSubview:_expandButton];
        [_expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo (CGSizeMake(40, 30));
            
            make.centerX.equalTo (cell);
            //make.bottom.equalTo (cell).with.offset (-5);
            make.top.equalTo (_descLabel.mas_bottom).with.offset (0);
        }];
        
        
    }
    else if (indexPath.section == 1){
        cell.textLabel.text = model.directorArray1[self.movieNo];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([model.starPresentImageArray count] > 0 && [model.star1Array count] > 0) {
            UIImage *icon = model.starPresentImageArray[indexPath.row];
            CGSize itemSize = CGSizeMake(60, 70);
            UIGraphicsBeginImageContextWithOptions(itemSize, NO,0.0);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [icon drawInRect:imageRect];
            
            cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.textLabel.text = model.star1Array[indexPath.row];
        }
        
    }
    cell.userInteractionEnabled = YES;
//    [UIView animateWithDuration:0.3f animations:^{
//        [self.infoTableView layoutIfNeeded];
//    }];表格加载动画
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDataModel *model = [MovieDataModel initWithModel];
    if (indexPath.section == 1) {
        movieWebViewController *movieWevVC = [self.storyboard instantiateViewControllerWithIdentifier:@"moviewebview"];
        movieWevVC.urlString = model.directorLinkArray[self.movieNo];
        [self.navigationController pushViewController:movieWevVC animated:YES];
        movieWevVC.navigationController.navigationBarHidden = YES;
        movieWevVC.tabBarController.tabBar.hidden = YES;//跳转导演链接
    }
    if (indexPath.section == 2) {
        movieWebViewController *movieWevVC = [self.storyboard instantiateViewControllerWithIdentifier:@"moviewebview"];
        if ([model.starLinkArray count] > 0) {
            
        
        if ([model.starLinkArray[indexPath.row] isKindOfClass:[NSNull class]]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"暂无信息" message:@"该演员信息暂无，看看其他的吧:)" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
        }//无演员信息警告
        else {
        movieWevVC.urlString = model.starLinkArray[indexPath.row];
        [self.navigationController pushViewController:movieWevVC animated:YES];
        movieWevVC.navigationController.navigationBarHidden = YES;
        movieWevVC.tabBarController.tabBar.hidden = YES;
        }//跳转演员信息
        }
    }
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    else if (section == 1){
        return @"导演";
    }
    else {
        return @"主要演员";
    }

}
#pragma mark - Cell展开方法
-(void) expandCell {
    if (isExpand == NO) {
        isExpand = YES;
        self.descLabel.numberOfLines = 0;
        [self.descLabel sizeToFit];
        [self.expandButton setTitle:@"收起" forState:UIControlStateNormal];
        [self.infoTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else {
        isExpand = NO;
        [self.expandButton setTitle:@"展开" forState:UIControlStateNormal];
        self.descLabel.numberOfLines = 3;
        [self.infoTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
}

#pragma mark - 视频播放
-(void) playMovie {
    [UIApplication sharedApplication].statusBarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.playView = [[MoviePlayerView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH) URL:nil];
    _playView.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    _playView.bounds = CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width);
    
    NSLog(@"playTap Touched!");
    NSArray *urlArray = @[@"http://baobab.wdjcdn.com/14562919706254.mp4",
                          @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                          @"http://baobab.wdjcdn.com/14525705791193.mp4",
                          @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                          @"http://baobab.wdjcdn.com/1455968234865481297704.mp4",
                          @"http://baobab.wdjcdn.com/1455782903700jy.mp4",
                          @"http://baobab.wdjcdn.com/14564977406580.mp4",
                          @"http://baobab.wdjcdn.com/1456316686552The.mp4",
                          @"http://baobab.wdjcdn.com/1456480115661mtl.mp4",
                          @"http://baobab.wdjcdn.com/1456665467509qingshu.mp4",
                          @"http://baobab.wdjcdn.com/1455614108256t(2).mp4",
                          @"http://baobab.wdjcdn.com/1456317490140jiyiyuetai_x264.mp4",
                          @"http://baobab.wdjcdn.com/1455888619273255747085_x264.mp4",
                          @"http://baobab.wdjcdn.com/1456734464766B(13).mp4",
                          @"http://baobab.wdjcdn.com/1456653443902B.mp4",
                          @"http://baobab.cdn.wandoujia.com/14468618701471.mp4"];
    
    int tag = arc4random() % 16;
    NSURL *url = [NSURL URLWithString:
                  urlArray[tag]];
    
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    [_playView addSubview:_moviePlayer.view];
    
    
    self.moviePlayer.view.frame = _playView.bounds;
    
    //    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI/2.0);
    //    self.moviePlayer.view.transform = landscapeTransform;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    [_moviePlayer setFullscreen:YES animated:YES];
    _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_playView];
        
    
    
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
        self.navigationController.navigationBarHidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self.playView removeFromSuperview];//移除播放View
        [UIApplication sharedApplication].statusBarHidden = NO;
            }
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
}





@end
