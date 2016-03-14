//
//  VoiceViewController.h
//  EasyLife
//
//  Created by 易仁 on 16/2/15.
//  Copyright © 2016年 易仁. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iflyMSC/iflyMSC.h"
#import "iflyMSC/IFlySpeechRecognizerDelegate.h"

@interface VoiceViewController : UIViewController<IFlySpeechRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *displayLabel;//文字显示label
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;
@property (strong, nonatomic) IBOutlet UIButton *startListen;
- (IBAction)startListening:(UIButton *)sender;
- (IBAction)stopListening:(UIButton *)sender;
@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径

@property (nonatomic, strong) IFlySpeechRecognizer *iflySpeechRecognizer;
@property (nonatomic, weak)   UITextView           *resultView;
//@property (nonatomic, strong) PopupView           *popUpView;
@property (nonatomic, strong) IFlyDataUploader     *uploader;
@property (nonatomic)         BOOL                 isCanceled;
@property (nonatomic,strong) UIImageView *backImageView;
@property (nonatomic,strong) UIImageView *animatedImageView;
@property (nonatomic,strong) NSMutableArray *imageArray;

@end
