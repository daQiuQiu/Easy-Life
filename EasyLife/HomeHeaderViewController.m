//
//  HomeHeaderViewController.m
//  HomeSearchDemo
//
//  Created by 易仁 on 16/1/22.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "HomeHeaderViewController.h"
#import "WebSearchViewController.h"

#import "DataModel.h"

#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height
int number;//随机笑话index
int searchTag = 0;//0 Baidu, 1 Sougou, 2 Bing.

@interface HomeHeaderViewController ()

@end

@implementation HomeHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatTable];
    
    
    [self creatHistoryTable];
    
    [self readHistoryArray];
    
    [self creatWeatherView];
    //[self creatRelaxView];
    
    [self getHotNews];
    [self addImageAndLabel];
    //[self getRelaxContent];
    
    
    
    //[self getWhetherByLocation:0 withLon:0];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self readHistoryArray];
    [self.historyTable reloadData];
    NSLog(@"History =%@",self.historyArray);
    
}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
}

#pragma mark - 读数组和清空
-(void) readHistoryArray {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.historyArray = [defaults objectForKey:@"historyarray"];
    
}

-(void) clearHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [defaults setObject:array forKey:@"historyarray"];
    self.historyArray = nil;
    [self.historyTable reloadData];
}


#pragma mark - 合并搜索链接

-(void) creatSearchLink: (NSString *)inputText {
    if (searchTag == 0) {
        self.searchLink = [NSString stringWithFormat:@"https://www.baidu.com/s?wd=%@",inputText];
    }
    else if (searchTag == 1) {
        self.searchLink = [NSString stringWithFormat:@"https://cn.bing.com/search?q=%@",inputText];
    }
    else {
        
        self.searchLink = [NSString stringWithFormat:@"https://www.sogou.com/web?query=%@",inputText];
    }
}

#pragma mark - 创建搜索框

-(void) creatSearchField {
    //添加搜索框
    self.searchFiled = [[UITextField alloc]init];
    self.searchFiled.delegate = self;
    self.searchFiled.backgroundColor = [UIColor whiteColor];
    self.searchFiled.placeholder = @"搜一下";
    self.searchFiled.borderStyle = UITextBorderStyleNone;
    self.searchFiled.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchFiled.clearButtonMode = UITextFieldViewModeAlways;
    self.searchFiled.keyboardAppearance = UIKeyboardAppearanceAlert;
    self.searchFiled.returnKeyType = UIReturnKeySearch;
    
    [self.mainTable.tableHeaderView addSubview:self.searchFiled];
    [self.searchFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.mainTable.tableHeaderView).with.offset (80);
        make.right.equalTo (self.mainTable.tableHeaderView).with.offset (-18);
        make.top.equalTo (self.mainTable.tableHeaderView.mas_bottom).with.offset (-80);
        make.height.equalTo (@50);
    }];
    //添加选择搜索的button
    self.searchEngineButton = [[UIButton alloc]init];
    //self.searchEngineButton.backgroundColor  = [UIColor redColor];
    self.searchEngineButton.contentMode = UIViewContentModeScaleAspectFill;
    [self.searchEngineButton setBackgroundImage:[UIImage imageNamed:@"Baidu"] forState:UIControlStateNormal];
    [self.searchEngineButton addTarget:self action:@selector(changeSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.mainTable.tableHeaderView addSubview:self.searchEngineButton];
    [self.searchEngineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo (self.searchFiled.mas_left);
        make.left.equalTo (self.mainTable.tableHeaderView).with.offset (18);
        make.top.equalTo (self.searchFiled);
        make.height.equalTo (@50);
    }];
    
}

-(void) changeSearch {
    if (searchTag == 0) {
        [self.searchEngineButton setBackgroundImage:[UIImage imageNamed:@"Bing"] forState:UIControlStateNormal];
        NSLog(@"Bing");
        searchTag = searchTag +1;
    }
    else if (searchTag == 1){
        [self.searchEngineButton setBackgroundImage:[UIImage imageNamed:@"Sougou"] forState:UIControlStateNormal];
        NSLog(@"Sougou");
        searchTag = searchTag +1;
    }
    else if (searchTag == 2) {
        [self.searchEngineButton setBackgroundImage:[UIImage imageNamed:@"Baidu"] forState:UIControlStateNormal];
        NSLog(@"Baidu");
        searchTag = 0;
    }
    
    NSLog(@"tag = %d",searchTag);
}
#pragma mark - 搜索框delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.searchFiled) {
        self.historyTable.hidden = NO;
        //self.searchEngineButton.hidden = YES;
        [self.searchFiled mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (self.mainTable.tableHeaderView).with.offset (20);
            make.left.equalTo (self.mainTable.tableHeaderView).with.offset (10);
            make.height.equalTo (@50);
            make.right.equalTo (self.mainTable.tableHeaderView).with.offset (-18);
        }];
        [self.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo (self.searchFiled.mas_top).with.offset (-200);
        }];
        
        [self.backgroundView setBlurLevel:1.0];
        self.hotNewsTable.hidden = YES;
        
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.mainTable layoutIfNeeded];
        }];

        
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchFiled && [self.searchFiled.text length] == 0) {
        [textField resignFirstResponder];
        NSLog(@"link = nil");
        self.historyTable.hidden = YES;
        self.searchEngineButton.hidden = NO;
        self.hotNewsTable.hidden = NO;
        [self.searchFiled mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo (self.mainTable.tableHeaderView.mas_bottom).with.offset (-80);
            make.left.equalTo (self.mainTable.tableHeaderView).with.offset (90);
            make.height.equalTo (@50);
            make.right.equalTo (self.mainTable.tableHeaderView).with.offset (-18);

            
        }];
        [self.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo (self.searchFiled.mas_top).with.offset (-30);
        }];
        [self.backgroundView setBlurLevel:0.1];
        [UIView animateWithDuration:0.3f animations:^{
            [self.mainTable.tableHeaderView layoutIfNeeded];
        }];
    }//什么都没输入的情况返回原来的状态
    
    else {
        NSString *input = self.searchFiled.text;
        NSLog(@"输入：%@",input);
        
        NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
        self.historyArray = [[NSMutableArray alloc]init];
        NSMutableArray *his = [defaults objectForKey:@"historyarray"];
        
        [self.historyArray addObjectsFromArray:his];
        [self.historyArray addObject:input];
        NSArray *reverseArray = [[self.historyArray reverseObjectEnumerator]allObjects];
        NSLog(@"倒序后：%@",reverseArray);
        [defaults setObject:reverseArray forKey:@"historyarray"];
        [defaults synchronize];
        //存入NSUserdefaults
        
        input = [input stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [self creatSearchLink:input];
        NSLog(@"link = %@",self.searchLink);
        
        self.navigationController.navigationBarHidden = NO;
        WebSearchViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"websearchview"];
        [self.navigationController pushViewController:webVC animated:YES];
        webVC.urlstring = self.searchLink;
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.view layoutIfNeeded];
        }];
        
        
    }
    return YES;
}

#pragma mark - 创建Table
//历史记录表格
-(void) creatHistoryTable {
    self.historyTable = [[UITableView alloc]init];
    self.historyTable.delegate = self;
    self.historyTable.dataSource = self;
    self.historyTable.hidden = YES;
    self.historyTable.backgroundColor = [UIColor clearColor];
    
    [self.mainTable.tableHeaderView addSubview:self.historyTable];
    [self.historyTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.searchFiled.mas_bottom).with.offset (10);
        make.left.and.right.equalTo (self.mainTable.tableHeaderView);
        make.bottom.equalTo (self.mainTable.tableHeaderView);
        
    }];
}
//主表格视图
-(void) creatTable {
    self.mainTable = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    //self.mainTable.backgroundColor = [UIColor clearColor];
    self.mainTable.tag = 1;
    
    self.backgroundView = [[DKLiveBlurView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
    _backgroundView.originalImage = [UIImage imageNamed:@"blue1"];
    _backgroundView.scrollView = self.mainTable;
    _backgroundView.isGlassEffectOn = YES;

    
   // UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green"]];
    
    [self.mainTable setBackgroundView:_backgroundView];
    [self.view addSubview:self.mainTable];
    [self creatHeaderView];
    [self creatHotNewsTable];
    
}

//创建主视图cell.1中的表格-热点新闻
-(void) creatHotNewsTable {
    self.hotNewsTable = [[UITableView alloc]init];
    self.hotNewsTable.delegate = self;
    self.hotNewsTable.dataSource = self;
    self.hotNewsTable.bounces = NO;
    [self.hotNewsTable setAlpha:0.6];
    self.hotNewsTable.backgroundColor = [UIColor blackColor];
    
}

#pragma mark - 创建header空间
-(void) creatHeaderView {
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH/2)];
    self.headerView.backgroundColor = [UIColor clearColor];
    self.mainTable.tableHeaderView = self.headerView;
    [self creatSearchField];
    [self creatLogoView];
    
}

-(void) creatLogoView {
    self.logoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.mainTable.tableHeaderView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo (self.searchFiled.mas_top).with.offset (-30);
        make.centerX.equalTo (self.mainTable.tableHeaderView);
        make.size.mas_equalTo (CGSizeMake(240, 60));
    }];
    
    
}

#pragma mark - 创建Cell2 - 天气cell
-(void) creatWeatherView {
    self.weatherView = [[UIView alloc]init];
    [self.weatherView setAlpha:0.6];
    self.weatherView.backgroundColor = [UIColor blackColor];
    
    UIButton *refresh = [[UIButton alloc]init];
    [refresh setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.weatherView addSubview:refresh];
    [refresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(18, 16));
        make.right.equalTo (self.weatherView).with.offset (-10);
        make.top.equalTo (self.weatherView).with.offset (5);
    }];
    
    [refresh addTarget:self action:@selector(refreshWeather) forControlEvents:UIControlEventTouchUpInside];
 
}

-(void) refreshWeather {
    //[self getWhetherByLocation:0 withLon:0];
    NSLog(@"刷新Weather");
}

-(void) addImageAndLabel {
    self.cityLabel = [[UILabel alloc]init];
    self.cityLabel.text = @"北京";
    self.cityLabel.textColor = [UIColor whiteColor];
    self.tempLabel = [[UILabel alloc]init];
    self.tempLabel.textColor = [UIColor whiteColor];
    self.tempLabel.text = @"10";
    self.tempLabel.font = [UIFont systemFontOfSize:50];
    self.timeLabel = [[UILabel alloc]init];
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.text = @"12:00";
    self.windLabel = [[UILabel alloc]init];
    self.windLabel.textColor = [UIColor whiteColor];
    self.windLabel.text = @"西风10级";
    self.weatherImageView = [[UIImageView alloc]init];
    //self.weatherImageView.backgroundColor = [UIColor redColor];
    self.weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.weatherView addSubview:self.weatherImageView];
    [self.weatherView addSubview:self.cityLabel];
    [self.weatherView addSubview:self.timeLabel];
    [self.weatherView addSubview:self.tempLabel];
    [self.weatherView addSubview:self.windLabel];
    //创建所有控件
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo (self.weatherView).with.offset (5);
        make.height.equalTo(@20);
        make.width.equalTo (@40);
        
    }];//城市名
    [self.weatherImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.weatherView).with.offset (20);
        make.bottom.equalTo (self.weatherView).with.offset (-60);
        make.size.mas_equalTo (CGSizeMake(120, 120));
    }];//天气图片
    
    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.weatherImageView).with.offset(0);
        make.size.mas_equalTo (CGSizeMake(80, 50));
        make.left.equalTo (self.weatherImageView.mas_right).with.offset (10);
    }];//温度label
    [self.windLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.weatherImageView.mas_right).with.offset (10);
        make.size.mas_equalTo (CGSizeMake(80, 35));
        make.top.equalTo (self.tempLabel.mas_bottom);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.weatherImageView.mas_right).with.offset (10);
        make.size.mas_equalTo (CGSizeMake(80, 35));
        make.bottom.equalTo (self.weatherImageView).with.offset(0);
    }];
    
    
}

#pragma mark - Cell3 - 随机笑话
-(void) creatRelaxView {
    self.relaxView = [[UIView alloc]init];
    [self.relaxView setAlpha:0.6];
    self.relaxView.backgroundColor = [UIColor blackColor];
    
    UIButton *refresh = [[UIButton alloc]init];
    [refresh setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    [self.relaxView addSubview:refresh];
    [refresh mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(18, 16));
        make.right.equalTo (self.relaxView).with.offset (-10);
        make.top.equalTo (self.relaxView).with.offset (5);
    }];
    [refresh addTarget:self action:@selector(refreshRelaxContent) forControlEvents:UIControlEventTouchUpInside];//刷新键加载
    
    self.viewLabel = [[UILabel alloc]init];
    self.viewLabel.text = @"每日轻松";
    self.viewLabel.textColor = [UIColor whiteColor];
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.contentMode = UIViewContentModeCenter;
    self.contentLabel.textColor = [UIColor whiteColor];
    [self.contentLabel setNumberOfLines:0];
    [self.relaxView addSubview:self.viewLabel];
    [self.relaxView addSubview:self.contentLabel];
    
    [self.viewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo (self.relaxView).with.offset (5);
        make.height.equalTo(@20);
        make.width.equalTo (@100);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo (self.relaxView).with.offset(15);
        make.bottom.equalTo (self.relaxView).with.offset(-20);
        make.right.equalTo (self.relaxView).with.offset(-10);
        make.top.equalTo (self.relaxView);
    }];
    
}

-(void) refreshRelaxContent {
    NSLog(@"刷新笑话");
    DataModel *model = [DataModel initWithModel];
    number = arc4random() % 20;
//    self.contentLabel.text = nil;//一定要赋空值，不然会出现覆盖
    if ([model.relaxArray count] > 0) {
        _contentLabel.text = model.relaxArray[number];
        NSLog(@"笑话=%@",self.contentLabel.text);
    }
    
    
    self.contentLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.3f animations:^{
        self.contentLabel.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}

#pragma mark - TableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTable) {
        return 1;
    }
    else if (tableView == self.historyTable){
        if (section == 0) {
            return [self.historyArray count];
        }
        else if (section == 1) {
            return 1;
        }
    }
    else if (tableView == self.hotNewsTable) {
        DataModel *model = [DataModel initWithModel];
        return [model.titleArray count];
    }
    else {
        return 0;
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.historyTable) {
        return 2;
    }
    else if (tableView == self.mainTable){
        return 3;
    }
    else {
        return 1;
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTable) {
        return 260;
    }
    else if(tableView == self.hotNewsTable){
        return 44;
            }
    else {
        return 64;
    }
}

#pragma mark - TableView Delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *secHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 2)];
    secHeader.backgroundColor = [UIColor colorWithRed:119 green:180 blue:204 alpha:0.5];
    
    if (tableView == self.historyTable) {
        
    
    if (section == 1) {
        return secHeader;
        }
    }
    else if (tableView == self.hotNewsTable) {
        UIView *secHeader1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenW, 30)];
        UILabel *headerLabel = [[UILabel alloc]init];
        [secHeader1 addSubview:headerLabel];
        [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.left.equalTo (secHeader1).with.offset (15);
        }];
        headerLabel.text = @"实时热点";
        headerLabel.textColor = [UIColor whiteColor];
        secHeader1.backgroundColor = [UIColor clearColor];
        //添加Label
        UIButton *refresh = [[UIButton alloc]init];
        
        [refresh setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [secHeader1 addSubview:refresh];
        [refresh mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo (CGSizeMake(18, 16));
            make.right.equalTo (secHeader1).with.offset (-10);
            make.top.equalTo (secHeader1).with.offset (5);
        }];
        
        [refresh addTarget:self action:@selector(refreshHotNews) forControlEvents:UIControlEventTouchUpInside];
        return secHeader1;
    }
    
    return nil;
}

-(void) refreshHotNews {
    NSLog(@"HotNewsRefresh");
    [self getHotNews];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.hotNewsTable) {
        return 30;
    }
    if (tableView == self.historyTable) {
       
    if (section == 1) {
        return 5;
    }
    else {
        return 0;
        }
    }
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == self.hotNewsTable) {
        
        return @"实时热点 ";
        
    }
    return nil;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString *cellidentifier = @"cell";
    static NSString *hiscellidentifier = @"hiscell";
    UITableViewCell *mainCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (mainCell == nil) {
        mainCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:hiscellidentifier];
        mainCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    mainCell.backgroundColor = [UIColor clearColor];
    if (tableView == self.historyTable) {
        

        if (indexPath.section == 0) {
            mainCell.textLabel.text = self.historyArray[indexPath.row];
        }//配置历史记录cell
        else if (indexPath.section == 1) {
            mainCell.textLabel.text = @"清除历史记录";
        }//配置清除历史记录
        
    }//历史记录Table
    else if (tableView == self.mainTable){
        

        if (indexPath.section == 0) {
            
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [mainCell.contentView addSubview:self.hotNewsTable];
        [self.hotNewsTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo (mainCell.contentView).with.insets(UIEdgeInsetsMake(0, 18, 0, 18));
        }];
        }//添加热点新闻Table
        else if (indexPath.section == 1){
            [mainCell.contentView addSubview:self.weatherView];
            [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo (mainCell.contentView).with.insets (UIEdgeInsetsMake(0, 18, 0, 18));
                
            }];
                        NSLog(@"cell2");
            }
        else if (indexPath.section == 2) {
            [self getRelaxContent];
            [self creatRelaxView];
            [mainCell.contentView addSubview:self.relaxView];
            [self.relaxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo (mainCell.contentView).with.insets (UIEdgeInsetsMake(0, 18, 0, 18));
                
            }];
            NSLog(@"cell3");
        }
         
    }//主Table
    else if (tableView == self.hotNewsTable) {
        mainCell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
        [UIView animateWithDuration:1.0f animations:^{
            mainCell.layer.transform = CATransform3DMakeScale(1, 1, 1);
        }];
        DataModel *model = [DataModel initWithModel];
        mainCell.textLabel.textColor = [UIColor whiteColor];
        mainCell.textLabel.font = [UIFont systemFontOfSize:15];
        mainCell.textLabel.text = model.titleArray[indexPath.row];
    }//配置热点新闻cell
    return mainCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tableView == self.historyTable) {
        NSLog(@"history = %ld，%ld",(long)indexPath.row,(long)indexPath.section);
        
        if (indexPath.section == 0) {
            self.searchFiled.text = cell.textLabel.text;
        }
        
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            [self clearHistory];
        }
    }
    else if (tableView == self.hotNewsTable) {
        NSLog(@"点击：%@",cell.textLabel.text);
        DataModel *model = [DataModel initWithModel];
        self.navigationController.navigationBarHidden = NO;
        WebSearchViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"websearchview"];
        [self.navigationController pushViewController:webVC animated:YES];
        webVC.urlstring = model.urlArray[indexPath.row];
        webVC.title = @"热点";
        self.tabBarController.hidesBottomBarWhenPushed = YES;

        
    }
}

#pragma mark - Scroll Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    UITableView *table = [scrollView viewWithTag:1];
//    CGFloat Y = scrollView.contentOffset.y;
//    //NSLog(@"YYYY=%f",Y);
//    if (table) {
//        //[self.mainTable.backgroundView setAlpha:(450-Y)/600];
//    }
    
    
}

#pragma mark - 热点新闻接口
-(void) getHotNews {
    NSString *url = @"http://apis.baidu.com/showapi_open_bus/channel_news/search_news";
    NSString *argu = [NSString stringWithFormat:@"channelId=5572a109b3cdc86cf39001db&page=1"];
    NSString *urlString = [NSString stringWithFormat:@"%@?%@",url,argu];
    NSLog(@"URL=%@",urlString);
    NSURL *dataurl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:dataurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    request.HTTPMethod = @"get";
    [request setValue:@"48d0498b92b758d3e0d5119c69c08a94" forHTTPHeaderField:@"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSLog(@"Response=%@",response);
        if (error) {
            NSLog(@"ERROR=%@",error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络不给力"
                                                                           message:@"请稍后再试"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:cancelAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else {
            
            NSError *jerror;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jerror];
            //NSLog(@"data= %@",data);
            //NSLog(@"JSON%@",dic);
            if (dic != nil) {
                
            
            NSDictionary *dic1 = [dic objectForKey:@"showapi_res_body"];
            NSDictionary *dic2 = [dic1 objectForKey:@"pagebean"];
            NSMutableArray *array = [dic2 objectForKey:@"contentlist"];
            DataModel *model = [DataModel initWithModel];
            model.titleArray = [NSMutableArray array];
            model.urlArray = [NSMutableArray array];
            for (int i = 0; i < 5; i++) {
                NSDictionary *dic = array[i];
                NSString *title = [dic objectForKey:@"title"];
                NSString *newsurl = [dic objectForKey:@"link"];
                NSLog(@"T=%@",title);
                //NSLog(@"U=%@",newsurl);
                [model.titleArray addObject:title];
                [model.urlArray addObject:newsurl];
            }

            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hotNewsTable reloadData];
            NSLog(@"hotNews Reload");
            
        });
        
    }];
    
    [dataTask resume];


}

#pragma mark - 天气接口
-(void)getWhetherByLocation:(double)lat withLon:(double)lng {
    lat = 121.48;
    lng = 31.41;
    NSString *urlString = [NSString stringWithFormat:@"http://v.juhe.cn/weather/geo?lon=%.2f&lat=%.2f&format=&dtype=&key=47f2f60002fd87ee842d22be302dad06",lat,lng];
    NSURL *dataurl = [NSURL URLWithString:urlString];
    NSLog(@"url = %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:dataurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    request.HTTPMethod = @"get";
    //[request setValue:@"48d0498b92b758d3e0d5119c69c08a94" forHTTPHeaderField:@"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"ERROR=%@",error);
            
        }
        else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            DataModel *model = [DataModel initWithModel];
            //NSLog(@"dic = %@",dic);
            if (dic) {
                NSDictionary *dic1 = [dic objectForKey:@"result"];
                NSDictionary *dicToday = [dic1 objectForKey:@"today"];
                NSDictionary *dicSK = [dic1 objectForKey:@"sk"];
                NSString *temp = [dicSK objectForKey:@"temp"];
                NSString *time = [dicSK objectForKey:@"time"];
                NSString *city = [dicToday objectForKey:@"city"];
                NSString *weather = [dicToday objectForKey:@"weather"];
                NSLog(@"dicSK = %@",dicSK);
                NSString *tempstr = [NSString stringWithFormat:@"%@°c",temp];
                NSString *windD = [dicSK objectForKey:@"wind_direction"];
                NSString *windS = [dicSK objectForKey:@"wind_strength"];
                //NSLog(@"WINDS = %@",windS);
                NSString *windDetail = [NSString stringWithFormat:@"%@%@",windD,windS];
                //NSLog(@"%@",windDetail);
                model.temp = tempstr;
                //NSLog(@"%@",model.temp);
                model.time = time;
                model.weather = weather;
                model.city = city;
                model.wind = windDetail;
                //NSLog(@"%@",model.city);
                NSLog(@"WEATHER = %@",model.weather);
                
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            DataModel *model = [DataModel initWithModel];
            self.timeLabel.text = model.time;
            self.tempLabel.text = model.temp;
            self.cityLabel.text = model.city;
            self.windLabel.text = model.wind;
            [self readPlist];
            
        });
    }];
    [datatask resume];
}

#pragma mark - 读取天气图plist
-(void) readPlist {
    DataModel *model = [DataModel initWithModel];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"weatherImage" ofType:@"plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
    
    NSDictionary *imagedic = [dic objectForKey:@"weatherimage"];
    //NSLog(@"imagedic = %@",imagedic);
    if (model.weather) {
        NSLog(@"time = %@",model.time);
        NSLog(@"plistWeather = %@",model.weather);
        NSString *imageName = [imagedic objectForKey:model.weather];
        self.weatherImageView.image = [UIImage imageNamed:imageName];

        }
}

#pragma mark - 笑话接口
-(void) getRelaxContent {
    NSString *urlString = [NSString stringWithFormat:@"http://japi.juhe.cn/joke/content/text.from?key=35d81badf8d5bd53ec3082eb71fd0bbc&page=1&pagesize=20"];
    NSURL *dataurl = [NSURL URLWithString:urlString];
    NSLog(@"url = %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:dataurl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
    request.HTTPMethod = @"get";
    //[request setValue:@"48d0498b92b758d3e0d5119c69c08a94" forHTTPHeaderField:@"apikey"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *datatask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
        else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *resultDic = [dic objectForKey:@"result"];
            NSArray *resArray = [resultDic objectForKey:@"data"];
            DataModel *model = [DataModel initWithModel];
            model.relaxArray = [NSMutableArray array];
            for (NSDictionary* dic1 in resArray) {
                NSString *content = [dic1 objectForKey:@"content"];
                [model.relaxArray addObject:content];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshRelaxContent];

        });
        
    }];
    [datatask resume];
}




@end