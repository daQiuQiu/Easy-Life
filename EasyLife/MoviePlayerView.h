//
//  MoviePlayerView.h
//  EasyLife
//
//  Created by 易仁 on 16/3/3.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface MoviePlayerView : UIView
@property (strong,nonatomic) MPMoviePlayerController *moviePlayer;

-(instancetype)initWithFrame:(CGRect)frame URL:(NSURL *)url;
@end
