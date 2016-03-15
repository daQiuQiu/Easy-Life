//
//  VoiceViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/2/15.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "VoiceViewController.h"
#import "VoiceSearchViewController.h"
#import <Masonry.h>
@interface VoiceViewController ()

@end

@implementation VoiceViewController
-(void) viewWillAppear:(BOOL)animated {
    [self changeBackgroundImage];
    self.animatedImageView.animationImages = nil;
    self.automaticallyAdjustsScrollViewInsets = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //demo录音文件保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
    [self creatBackgroundImage];
    [self.startListen addTarget:self action:@selector(startListening:) forControlEvents:UIControlEventTouchDown];
    [self.startListen addTarget:self action:@selector(stopListening:)                forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [self.view bringSubviewToFront:self.startListen];
    [self.view bringSubviewToFront:self.resultLabel];
    [self.view bringSubviewToFront:self.displayLabel];
    
    __weak typeof(self) weakSelf = self;
    self.resultLabel = [[UILabel alloc]init];
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.resultLabel];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(200, 50));
        make.centerX.equalTo (weakSelf.view).with.offset (-200);
        make.centerY.equalTo (weakSelf.view.mas_centerY).with.offset (0);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
    //self.tabBarController.tabBar.hidden = NO;
}

-(void) creatBackgroundImage {
    
    self.backImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenW, screenH)];
    
    [self.view addSubview:self.backImageView];
    
    [self creatAnimationImageView];
}

#pragma mark - 动画ImageView
-(void) creatAnimationImageView {
     self.imageArray = [NSMutableArray array];
    UIImage *image = [[UIImage alloc]init];
    self.animatedImageView = [[UIImageView alloc]init];
    self.animatedImageView.animationDuration = 1.3f;
    for (int i = 0; i < 30; i++) {
        image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i]];
        [_imageArray addObject:image];
    }
    self.animatedImageView.animationRepeatCount = 0;//infinite
    self.animatedImageView.animationImages = _imageArray;
    [self.backImageView addSubview:self.animatedImageView];
    [self.animatedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo (CGSizeMake(screenW, screenW));
        make.center.equalTo (self.startListen);
    }];
    
}

#pragma mark - Label动画
-(void) labelAnimationIn {
    __weak typeof(self) weakSelf = self;
    

    [self.resultLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view).with.offset (0);
    }];
    
    
    [UIView animateWithDuration:1.0f animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - 换背景
-(void) changeBackgroundImage {
    int tag = [[[NSUserDefaults standardUserDefaults]objectForKey:@"tag"] intValue];
    
    
    if (tag == 0) {//蓝色图标
        self.backImageView.image = [UIImage imageNamed:@"blue"];
        
    }
    else if (tag == 1) {//红色
        self.backImageView.image = [UIImage imageNamed:@"red"];
        
    }
    else if (tag == 2) {//黄色
        self.backImageView.image = [UIImage imageNamed:@"yellow"];
        
    }
    else if (tag == 3) {//绿色
        self.backImageView.image = [UIImage imageNamed:@"green"];
        
    }
    
}


#pragma mark - 开始听
- (IBAction)startListening:(UIButton *)sender {
    [self recognizerSetting];
    [self.iflySpeechRecognizer startListening];
    self.animatedImageView.animationImages = self.imageArray;
    [self.animatedImageView startAnimating];
}

- (IBAction)stopListening:(UIButton *)sender {
    [self.iflySpeechRecognizer stopListening];
    self.animatedImageView.animationImages = nil;
    [self.animatedImageView stopAnimating];
}

-(void) recognizerSetting {
    self.isCanceled = NO;
    if (self.iflySpeechRecognizer == nil) {
        self.iflySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];;
    }
    
    [self.iflySpeechRecognizer cancel];
    //设置音频来源为麦克风
    [self.iflySpeechRecognizer setParameter:@"1" forKey:@"audio_source"];
    //设置听写结果格式为json
    [self.iflySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    [self.iflySpeechRecognizer setParameter:@"60000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [self.iflySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [self.iflySpeechRecognizer setDelegate:self];
}
//init method
-(void) initRecognizer {
    if (self.iflySpeechRecognizer == nil) {
        self.iflySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
        [self.iflySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [self.iflySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    self.iflySpeechRecognizer.delegate = self;
}
#pragma mark - 听写Delegate
- (void) onBeginOfSpeech
{
    NSLog(@"onBeginOfSpeech");
    
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
    
}
- (void) onVolumeChanged: (int)volume
{
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    self.displayLabel.text = vol;
}



/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    if (error){
        NSLog(@"%d",[error errorCode]);
        NSLog(@"%@",[error errorDesc]);
    }
    
    
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSLog(@"结果数组= %@",results);
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    NSLog(@"zidian = %@",dic);
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSLog(@"result = %@",resultString);
    
    NSString * resultFromJson =  [VoiceViewController stringFromJson:resultString];
    if (isLast) {
        NSLog(@"JSON解析= %@",resultFromJson);
        
        if (results == nil) {
            self.resultLabel.text = @"无法识别";
            [self labelAnimationIn];
        }else {
            self.resultLabel.text = [NSString stringWithFormat:@"识别结果：%@",resultFromJson];
            [self labelAnimationIn];
            //拼接搜索链接
            
            resultFromJson = [resultFromJson stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSString *searchLink = [NSString stringWithFormat:@"https://www.baidu.com/s?wd=%@",resultFromJson];
            self.navigationController.navigationBarHidden = NO;
            VoiceSearchViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"voicesearch"];
            webVC.urlString = searchLink;
            webVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:webVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        

    }
    
}

#pragma mark - Json解析
+ (NSString *)stringFromJson:(NSString*)params
{
    if (params == NULL) {
        return nil;
    }
    
    NSMutableString *tempStr = [[NSMutableString alloc] init];//返回变量
    NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //返回的格式必须为utf8的,否则发生未知错误
                                [params dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if (resultDic!= nil) {
        NSArray *wordArray = [resultDic objectForKey:@"ws"];
        
        for (int i = 0; i < [wordArray count]; i++) {
            NSDictionary *wsDic = [wordArray objectAtIndex: i];
            NSArray *cwArray = [wsDic objectForKey:@"cw"];
            
            for (int j = 0; j < [cwArray count]; j++) {
                NSDictionary *wDic = [cwArray objectAtIndex:j];
                NSString *str = [wDic objectForKey:@"w"];
                [tempStr appendString: str];
            }
        }
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"!.。！？?"];
        tempStr = (NSMutableString*)[tempStr stringByTrimmingCharactersInSet:set];//去除结尾标点符号
    }
    return tempStr;
}


@end
