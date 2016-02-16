//
//  VoiceViewController.m
//  EasyLife
//
//  Created by 易仁 on 16/2/15.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import "VoiceViewController.h"


@interface VoiceViewController ()

@end

@implementation VoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //demo录音文件保存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    _pcmFilePath = [[NSString alloc] initWithFormat:@"%@",[cachePath stringByAppendingPathComponent:@"asr.pcm"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 开始听
- (IBAction)startListening:(UIButton *)sender {
    self.isCanceled = NO;
    if (self.iflySpeechRecognizer == nil) {
        [self initRecognizer];
    }
    
    [self.iflySpeechRecognizer cancel];
    //设置音频来源为麦克风
    [self.iflySpeechRecognizer setParameter:@"1" forKey:@"audio_source"];
    //设置听写结果格式为json
    [self.iflySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [self.iflySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [self.iflySpeechRecognizer setDelegate:self];
    [self.iflySpeechRecognizer startListening];
}

- (IBAction)stopListening:(UIButton *)sender {
    [self.iflySpeechRecognizer stopListening];
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
    
    //NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    
    
//    if (isLast){
//        NSLog(@"听写结果(json)：%@测试",  resultString);
//    }
//    NSLog(@"_result=%@",resultString);
//    NSLog(@"resultFromJson=%@",resultFromJson);
    
}

@end
