//
//  RecordWindow.h
//  RccordTest
//
//  Created by 张丽 on 2018/8/16.
//  Copyright © 2018年 ylh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordTimerBtn.h"
#import <ReplayKit/ReplayKit.h>

@protocol RecordWindowDelegate <NSObject>
- (void)exitRecordClick;
- (void)resetRecordClick;
@required
- (void)stopRecordManagerWithRPPVC:(RPPreviewViewController *)previewViewController;
@end

@interface RecordWindow : UIWindow

@property (nonatomic,strong)RecordTimerBtn *timerBtn;
@property (nonatomic,weak)id <RecordWindowDelegate>delegate;
@end
