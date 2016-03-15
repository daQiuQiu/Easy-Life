//
//  AdViewController.m
//  
//
//  Created by 易仁 on 16/3/14.
//
//

#import "AdViewController.h"
#import <Masonry.h>

@interface AdViewController ()

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
//    NSArray *adImageArray = @[@"AD1",@"AD2",@"AD3",@"AD4",@"AD5"];
//    int tag = arc4random() % 6;
//    self.adImageView.image = [UIImage imageNamed:adImageArray[tag]];
    [self creatAdImageView];
    NSLog(@"ad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 广告图片
-(void) creatAdImageView {
    self.adImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
    NSArray *adImageArray = @[@"AD1",@"AD2",@"AD3",@"AD4",@"AD5",@"AD6",@"AD7",@"AD8",@"AD9",@"AD10"];
    int tag = arc4random() % 10;
    self.adImageView.image = [UIImage imageNamed:adImageArray[tag]];
    [self.view addSubview:self.adImageView];
    
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.adImageView.layer addAnimation:transition forKey:nil];//添加1秒渐变
    
    [UIView animateWithDuration:4.0f animations:^{
        self.adImageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
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
