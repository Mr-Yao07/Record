//
//  RecordTimerBtn.h
//  RccordTest
//
//  Created by 张丽 on 2018/8/16.
//  Copyright © 2018年 ylh. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 结束录制状态

 - CompleteNormal: 正常结束
 - CompleteExit: 退出录制
 - CompleteAgain: 重新录制
 - CompleteNoMinTime: 没有达到最少录制时间
 */
typedef NS_ENUM(int,CompleteType)
{
    CompleteNormal,
    CompleteExit,
    CompleteAgain,
    CompleteNoMinTime,
};
@protocol RecordTimerBtnDelegate <NSObject>

- (void)completeRecordAndStatus:(CompleteType)completeType;
@end


@interface RecordTimerBtn : UIButton


/**
 跟新界面展示时间
 */
@property (nonatomic,copy)void (^updateLabTextBlock)(int num);



- (void)releaseBtnTimerAndResetBtnStatusWithType:(CompleteType)completeType;

/**
 根据按钮选中状态 创建或释放定时器

 @param selected 按钮状态
 */
- (void)updateTimerWithBtnStatus:(BOOL)selected;


/**
 重置按钮
 */
- (void)resetTimerBtnStatus;

@property (nonatomic,weak)id <RecordTimerBtnDelegate>delegate;

@end
