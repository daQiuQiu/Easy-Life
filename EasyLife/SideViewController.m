//
//  SideViewController.m
//  NewsDemo
//
//  Created by 易仁 on 16/1/15.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "SideViewController.h"
#import "DataLoading.h"
#import "AppDelegate.h"
#import "TableViewController.h"
@interface SideViewController () <YRClickSideMenuProtocol>

@end

@implementation SideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initWithTableView];
    [self getCatelogue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getCatelogue {
    NSLog(@"init!");
    
    NSLog(@"dataloading init");
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
            model.cateArray = [NSMutableArray array];
            model.idArray = [NSMutableArray array];
            [model.Array addObjectsFromArray:array];
            //NSLog(@"%ld",[model.Array count]);
            for (NSDictionary *dicc in array) {
                
                NSString *name = [dicc valueForKey:@"name"];
                NSString *channelid = [dicc valueForKey:@"channelId"];
                [model.cateArray addObject:name];
                [model.idArray addObject:channelid];
                //NSLog(@"%@",model.idArray);
            }
            NSLog(@"%lu",(unsigned long)[model.idArray count]);
            //NSLog(@"data is %@",channelData.Array);

        }
    }];
    
    
    [dataTask resume];
    ;

}
#pragma mark - 创建tableview
-(void) initWithTableView {
    self.table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 200, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    self.table.backgroundColor = [UIColor darkGrayColor];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
}

#pragma mark - datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    DataLoading *model = [DataLoading initWithModel];
    
    return [model.cateArray count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - 配置cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"cell";
    DataLoading *model = [DataLoading initWithModel];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    //配置cell
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor lightTextColor];
    cell.textLabel.text = model.cateArray[indexPath.row];
    
    cell.selectedBackgroundView = [UIView new];
    cell.selectedTextColor = [UIColor whiteColor];
    [tableView setSeparatorColor:[UIColor clearColor]];
    NSLog(@"配置cell");
    
    //cell 动画
    cell.layer.transform = CATransform3DMakeScale(0.1, 1, 1);
    [UIView animateWithDuration:0.3f animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataLoading *model = [DataLoading initWithModel];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    YRSideViewController *sideViewController=[delegate sideController];
    [sideViewController hideSideViewController:YES];
    NSString *newid = model.idArray[indexPath.row];
    [model setValue:[NSString stringWithFormat:@"%@",newid] forKey:@"idKey"];
    model.channelId = [NSMutableString stringWithFormat:@"%@",[model valueForKey:@"idKey"]];
    model.chosenindex = indexPath.row;
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshnews" object:nil];

    
//    if ([self.delegate respondsToSelector:@selector(sideMenuClick:)]) {
//        [self.delegate stopTimer];
//        [self.delegate pullToRefresh];
//        //[self.delegate sideMenuClick:model.channelId];
//        [self.delegate removeScrollView];
//
//    }

    //TableViewController *tableUpdate = [TableViewController initWithModel];
    //[tableUpdate getNews];
    
    
    NSLog(@"新的ID：%@",model.channelId);
    //[mainTable.tableView reloadData];
    //NSLog(@"%@",model.cateArray[indexPath.row]);
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"disappear");
    DataLoading *model = [DataLoading initWithModel];
    
//    TableViewController *mainTableVC = [[TableViewController alloc] init];
//    [mainTableVC.tableView removeFromSuperview];
//    [model.imagePresentArray removeAllObjects];
//    [model.newsTitleArray removeAllObjects];
//    [model.imageArray removeAllObjects];

    if ([self.delegate respondsToSelector:@selector(sideMenuClick:)]) {
        [self.delegate sideMenuClick:model.channelId];
    }
    
    //[mainTable getNews];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        [mainTableVC.tableView reloadData];
        NSLog(@"侧滑后更新table");
        
        
    });
    

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
