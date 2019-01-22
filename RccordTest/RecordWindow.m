//
//  RecordWindow.m
//  RccordTest
//
//  Created by 张丽 on 2018/8/16.
//  Copyright © 2018年 ylh. All rights reserved.
//

#import "RecordWindow.h"
#import "UIButton+ImagePosition.h"

@interface RecordWindow () <RecordTimerBtnDelegate>
{
    UILabel *timerLab;
    
}

@end
@implementation RecordWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.0f];
        [self setSubViews];
    }
    return self;
}
- (NSMutableAttributedString *)DifferentString1:(NSString *)string1 color1:(UIColor *)color1 font1:(NSInteger)font1  string2:(NSString *)string2 color2:(UIColor *)color2 font2:(NSInteger)font2 {
    NSString *str=[NSString stringWithFormat:@"%@%@",string1,string2];
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc]initWithString:str];
    [string addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, string1.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font1] range:NSMakeRange(0, string1.length)];
    [string addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(string1.length, string2.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font2] range:NSMakeRange(string1.length, string2.length)];
    return string;
}
- (void)setSubViews {
    
    timerLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
    timerLab.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    timerLab.textColor = [UIColor whiteColor];
    timerLab.hidden = YES;
    timerLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timerLab];
    
    __weak typeof(timerLab)weakTimerLab = timerLab;
    __weak typeof(self)weakSelf = self;
    _timerBtn = [RecordTimerBtn buttonWithType:UIButtonTypeCustom];
    [_timerBtn setImage:[UIImage imageNamed:@"btn_paly"] forState:UIControlStateNormal];
    [_timerBtn setImage:[UIImage imageNamed:@"btn_paly_cl"] forState:UIControlStateSelected];
    _timerBtn.frame = CGRectMake((self.frame.size.width-80)/2, self.frame.size.height-120, 80, 80);
    [_timerBtn addTarget:self action:@selector(timerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _timerBtn.updateLabTextBlock = ^(int num) {
//        weakTimerLab.text = [NSString stringWithFormat:@"录制了%d秒",num];
        weakTimerLab.attributedText = [weakSelf DifferentString1:@"• " color1:[UIColor redColor] font1:20 string2:[NSString stringWithFormat:@"录制了%d秒",num] color2:[UIColor whiteColor] font2:14.0f];
        
    };
    _timerBtn.delegate = self;
    [self addSubview:_timerBtn];
    [_timerBtn addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.frame = CGRectMake(20, _timerBtn.frame.origin.y, 40, 80);
    [resetBtn setImage:[UIImage imageNamed:@"btn_resetting"] forState:UIControlStateNormal];
    [resetBtn setTitle:@"重录" forState:UIControlStateNormal];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [resetBtn setImagePosition:LXMImagePositionTop spacing:5];
    [resetBtn addTarget:self action:@selector(resetClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetBtn];
    
    UIButton *exitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitBtn.frame = CGRectMake(self.frame.size.width-20-40, _timerBtn.frame.origin.y, 40, 80);
    [exitBtn setImage:[UIImage imageNamed:@"btn_close"] forState:UIControlStateNormal];
    [exitBtn setTitle:@"退出" forState:UIControlStateNormal];
    exitBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [exitBtn setImagePosition:LXMImagePositionTop spacing:5];
    [exitBtn addTarget:self action:@selector(exitClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:exitBtn];
    
    
}

#pragma mark ---  self view  clicks
- (void)timerBtnClick:(RecordTimerBtn *)btn {
    if ([RPScreenRecorder sharedRecorder].available) {
        btn.selected = !btn.selected;
        
        if (btn.selected == YES) {
            [self startRecordManager];
        }else{
            [_timerBtn releaseBtnTimerAndResetBtnStatusWithType:0];
        }
        
    }else{
        NSLog(@"录制功能不可用");
    }
    
   
}

- (void)resetClick:(UIButton *)btn {
    [_timerBtn releaseBtnTimerAndResetBtnStatusWithType:CompleteAgain];
    [self.delegate resetRecordClick];
}

- (void)exitClick:(UIButton *)btn {
    [_timerBtn releaseBtnTimerAndResetBtnStatusWithType:CompleteExit];
    [self.delegate exitRecordClick];
}


#pragma mark ----  RecordTimerBtnDelegate
- (void)completeRecordAndStatus:(CompleteType)completeType {
    [self stopRecordManagerWithStopType:completeType];
}


#pragma mark ---  监听按钮状态，控制顶部时间的显示
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    //    NSLog(@"keyPath=%@,object=%@,change=%@,context=%@",keyPath,object,change,context);
    BOOL status = [change[@"new"] boolValue];
    timerLab.hidden = !status;
    if (timerLab.hidden == YES) {
        timerLab.text = [NSString stringWithFormat:@"录制了%d秒",0];
    }
}

#pragma mark -- 开启录制
- (void)startRecordManager {
    [[RPScreenRecorder sharedRecorder]startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"录制出错%@", error);
            [self.timerBtn updateTimerWithBtnStatus:NO];
        }else if ([RPScreenRecorder sharedRecorder].isRecording) {
            [self.timerBtn updateTimerWithBtnStatus:YES];
        }
    }];
}

#pragma mark -- 结束录制
- (void)stopRecordManagerWithStopType:(CompleteType)completeType {
    [[RPScreenRecorder sharedRecorder]stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        NSLog(@"结束录制,重置按钮状态");
        if (error) {
            NSLog(@"%@", error);
        }
        
        switch (completeType) {
            case CompleteNormal://录制完成
            {
                if (previewViewController) {
                    //设置预览页面到代理
//                    self.stopRecordManagerBlock(previewViewController);
                    [self.delegate stopRecordManagerWithRPPVC:previewViewController];
                }
            }
                break;
            case CompleteNoMinTime://录制时间不够
                NSLog(@"录制时间不足5秒");
                break;
            case CompleteExit://退出
                NSLog(@"退出录制");
                break;
            case CompleteAgain://
                NSLog(@"重置录制");
                break;
                
            default:
                break;
        }
        
    }];
}






@end
