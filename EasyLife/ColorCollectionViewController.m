//
//  ColorCollectionViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/3/7.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "ColorCollectionViewController.h"
#import "CollectionViewCell.h"
#import <Masonry.h>
@interface ColorCollectionViewController ()

@end

@implementation ColorCollectionViewController

static NSString * const reuseIdentifier = @"collcell";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewdidload");
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageNameArray = [NSArray array];
    self.imageArray = [NSMutableArray array];
    self.imageNameArray = @[@"blue",@"red",@"yellow",@"green"];
    [self creatImage];
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
    [flowlayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView.collectionViewLayout = flowlayout;
    
    // Register cell classes
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建image 
-(void) creatImage {
    self.imageView = [[UIImageView alloc]init];
    self.useColorButton = [[UIButton alloc]init];
    self.useColorButton.backgroundColor = [UIColor whiteColor];
    [self.useColorButton setTitle:@"立即使用" forState:UIControlStateNormal];
    self.useColorButton.titleLabel.textColor = [UIColor blackColor];
    [self.useColorButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
    
    for (int i = 0; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:self.imageNameArray[i]];
        [self.imageArray addObject:image];
    }
    
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d",indexPath.row);
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor darkGrayColor];
    UIImageView *imageView = [[UIImageView alloc]init];
    UIImage *image = self.imageArray[indexPath.row];
    imageView.image = image;
    imageView.frame = cell.bounds;
    [cell addSubview:imageView];//添加图片
    
    int tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"tag"] intValue];
    NSLog(@"nsutag = %d",tag);
    if (tag == indexPath.row) {
        UIButton *useColorButton = [[UIButton alloc]init];
        useColorButton.tag = indexPath.row;
        [useColorButton setTitle:@"已使用" forState:UIControlStateNormal];
        [useColorButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:useColorButton];
        [useColorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo (CGSizeMake(80, 30));
            make.centerX.equalTo (imageView);
            make.bottom.equalTo (imageView).with.offset (-20);
        }];

    }
    else {
        UIButton *useColorButton = [[UIButton alloc]init];
        useColorButton.tag = indexPath.row;
        [useColorButton setTitle:@"立即使用" forState:UIControlStateNormal];
        [useColorButton addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:useColorButton];
        [useColorButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo (CGSizeMake(80, 30));
            make.centerX.equalTo (imageView);
            make.bottom.equalTo (imageView).with.offset (-20);
        }];
    }

    // Configure the cell
    
    return cell;
}

-(void) changeColor: (UIButton*)sender {
    NSLog(@"换皮肤！");
    NSLog(@"%ld",(long)sender.tag);
    int tagnumber = (int)sender.tag;
    NSLog(@"tag存 = %d",tagnumber);
    NSString *tag = [NSString stringWithFormat:@"%d",tagnumber];
    [[NSUserDefaults standardUserDefaults] setObject:tag forKey:@"tag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changecolor" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //CGFloat height=100+(arc4random()%120);
    
    return  CGSizeMake(screenW/2-6, screenH/2-8);  //设置cell宽高
}

#pragma mark <UICollectionViewDelegate>

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *tag = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:tag forKey:@"tag"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSLog(@"coll点击tag = %@",tag);
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changecolor" object:nil];
}
/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
