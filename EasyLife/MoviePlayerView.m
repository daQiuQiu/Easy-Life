//
//  MoviePlayerView.m
//  EasyLife
//
//  Created by 易仁 on 16/3/3.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "MoviePlayerView.h"
#import "AppDelegate.h"
@implementation MoviePlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - 初始化
-(instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url {
    self = [super initWithFrame:frame];
    //CGAffineTransform landscapeTransform = self.transform;
//    landscapeTransform = CGAffineTransformRotate(landscapeTransform, M_PI_2);
//    self.transform = landscapeTransform;
    //self.center = CGPointMake(screenH/2.0f, screenW/2.0f);
    
    //[self playMovie];
    
    self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    [UIView animateWithDuration:0.5f animations:^{
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];//启动动画 中间开始渐变出来

    
    return self;
}
//http://vfx.mtime.cn/Video/2016/03/02/flv/160302100642743915.flv
//http://v.jxvdy.com/sendfile/w5bgP3A8JgiQQo5l0hvoNGE2H16WbN09X-ONHPq3P3C1BISgf7C-qVs6_c8oaw3zKScO78I--b0BGFBRxlpw13sf2e54QA
#pragma mark - 视频播放
-(void) playMovie {
    NSLog(@"playTap Touched!");
    NSURL *url = [NSURL URLWithString:
                  @"http://vfx.mtime.cn/Video/2016/03/02/flv/160302100642743915.flv"];
    
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    self.moviePlayer.view.frame = self.bounds;
//    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(M_PI/2.0);
//    self.moviePlayer.view.transform = landscapeTransform;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
    _moviePlayer.shouldAutoplay = YES;
    [self addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
    
    
    //[[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationLandscapeRight] forKey:@"orientation"];
    
    //[[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    
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
    }
    
}


#pragma mark - 横屏代码
//- (BOOL)shouldAutorotate{
//    return NO;
//} //NS_AVAILABLE_IOS(6_0);当前viewcontroller是否支持转屏
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    
//    return UIInterfaceOrientationMaskLandscape;
//} //当前viewcontroller支持哪些转屏方向
//
//-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationLandscapeRight;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    // Return YES for supported orientations.
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
//}

@end
