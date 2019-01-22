//
//  RecordTimerBtn.m
//  RccordTest
//
//  Created by 张丽 on 2018/8/16.
//  Copyright © 2018年 ylh. All rights reserved.
//

#import "RecordTimerBtn.h"
@interface RecordTimerBtn ()

/**
 定时器
 */
@property (nonatomic,strong)dispatch_source_t btnTimer;

/**
 定时器当前秒数，根据此更新UI
 */
@property (nonatomic,assign)int updatingCount;
@end
@implementation RecordTimerBtn
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
        _updatingCount = 0;
    }
    return self;
}

/**
 初始化定时器
 */
- (void)setUpBtnTimer {
    
    if (!_btnTimer) {
        __block int count = 0;
        __weak typeof(self)weakSelf = self;
        dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
        _btnTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, globalQueue);
        dispatch_source_set_timer(_btnTimer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_btnTimer, ^{
            count++;
            if (count<=1000) {
                weakSelf.updatingCount = count;
//                NSLog(@"我是定时器，我执行到了第 %d 次，开始重绘圆喽",weakSelf.updatingCount);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNeedsDisplay];
                    if (count%100==0) {
                        self.updateLabTextBlock(count/100);
                    }
                });
            }else{
                [self releaseBtnTimerAndResetBtnStatusWithType:0];
            }
        });
        dispatch_resume(_btnTimer);
    }
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线的宽度
    CGContextSetLineWidth(context, 3);
    //设置线颜色
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    //画曲线
    CGContextAddArc(context, self.frame.size.width/2.0, self.frame.size.height/2.0, self.bounds.size.width/2.0-3.5, 0 , 2*M_PI*_updatingCount/1000, 0);
    CGContextStrokePath(context);
}



- (void)updateTimerWithBtnStatus:(BOOL)selected {
    if (selected == YES) {
        [self setUpBtnTimer];
    }else{
        [self releaseBtnTimerAndResetBtnStatusWithType:CompleteNormal];
    }
}


- (void)releaseBtnTimerAndResetBtnStatusWithType:(CompleteType)completeType {
    switch (completeType) {
        case CompleteNormal:
        {
            //进行录制时间是否有效的判断
            if (self.updatingCount>=5*100) {
                [self.delegate completeRecordAndStatus:CompleteNormal];
            }else{
                [self.delegate completeRecordAndStatus:CompleteNoMinTime];
            }
        }
            break;
            
        default:
            [self.delegate completeRecordAndStatus:completeType];
            break;
    }
    [self resetTimerBtnStatus];
    
    
}
- (void)resetTimerBtnStatus {
    //重置按钮
    self.updatingCount = 0;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
        self.selected = NO;
    });
    
    //释放定时器
    if (_btnTimer) {
        dispatch_cancel(_btnTimer);
        _btnTimer = nil;
    }
}

@end
