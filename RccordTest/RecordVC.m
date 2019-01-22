//
//  RecordVC.m
//  RccordTest
//
//  Created by 张丽 on 2018/8/16.
//  Copyright © 2018年 ylh. All rights reserved.
//

#import "RecordVC.h"

#import "RecordWindow.h"

#import <ReplayKit/ReplayKit.h>

#import "CustomShowRecordVC.h"

#import <objc/runtime.h>

@interface RecordVC ()<RPPreviewViewControllerDelegate,RecordWindowDelegate>
@property (nonatomic,strong)RecordWindow *recordWindow;

@end

@implementation RecordVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _recordWindow.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"1.png"];
    [self.view addSubview:imageView];
    
    
    _recordWindow = [[RecordWindow alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    _recordWindow.windowLevel = UIWindowLevelNormal;
    _recordWindow.delegate = self;
    _recordWindow.hidden = NO;
    
}


- (void)previewController:(RPPreviewViewController *)previewController didFinishWithActivityTypes:(NSSet <NSString *> *)activityTypes {
    //用户操作完成后，返回之前的界面
    
    [activityTypes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        
    }];
    
    __weak typeof(self)weakSelf = self;
    [previewController dismissViewControllerAnimated:YES completion:^{
        weakSelf.recordWindow.hidden = NO;
        if (activityTypes.count==0) {
            NSLog(@"没保存");
        }else{
            NSLog(@"保存到相册了");
        }
    }];
}

#pragma mark --- RecordWindowDelegate
- (void)exitRecordClick {
    
}

- (void)resetRecordClick {
    
}

- (void)stopRecordManagerWithRPPVC:(RPPreviewViewController *)previewViewController {
    __weak typeof(self)weakSelf = self;
    previewViewController.previewControllerDelegate = self;
    previewViewController.title=@"批工厂";
    ;
    
    
    
//    unsigned int count = 0;
//    objc_property_t *properties = class_copyPropertyList([previewViewController class], &count);
//    NSMutableArray *mArray = [NSMutableArray array];
//    for (int i = 0; i<count; i++) {
//        objc_property_t propert = properties[i];
//        const char *cName = property_getName(propert);
//        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
//        [mArray addObject:name];
//    }
    
//    NSLog(@"previewViewController: %@",mArray);

    
    NSString *movieStr =  [previewViewController valueForKey:@"movieURL"];
    NSObject *vcObj =  [previewViewController valueForKey:@"hostViewController"];
    NSObject *deleObj =  [previewViewController valueForKey:@"previewControllerDelegate"];
    
    NSLog(@"movieStr: %@    %@      %@",movieStr,vcObj,deleObj);
    
//    CustomShowRecordVC *showVC = [[CustomShowRecordVC alloc]init];
//    showVC.title = @"haha";
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:showVC];
//    [previewViewController setValue:nav forKey:@"hostViewController"];
    
    
    unsigned int count_vc = 0;
//    objc_property_t *properties_vc = class_copyPropertyList([vcObj class], &count_vc);
    Ivar *vars = class_copyIvarList([vcObj class], &count_vc);
    NSMutableArray *mArray_vc = [NSMutableArray array];
    for (int i = 0; i<count_vc; i++) {
//        objc_property_t propert = properties_vc[i];
//        const char *cName = property_getName(propert);
//        const char *cName = var[i];
        
        NSString *name = [NSString stringWithCString:ivar_getName(vars[i]) encoding:NSUTF8StringEncoding];
        [mArray_vc addObject:name];
    }
    
    NSLog(@"vcObj: %@",mArray_vc);
    
    
    
    
    
    [self presentViewController:previewViewController animated:YES completion:^{
        weakSelf.recordWindow.hidden = YES;
    }];
    
//    CustomShowRecordVC *showVC = [[CustomShowRecordVC alloc]init];
//    [showVC addChildViewController:previewViewController];
//    showVC.view.frame = CGRectMake(0, 0, showVC.view.frame.size.width, showVC.view.frame.size.height);
//    [showVC.view addSubview:previewViewController.view];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:showVC];
//    [self presentViewController:nav animated:YES completion:^{
//        weakSelf.recordWindow.hidden = YES;
//    }];
}
- (void)previewControllerDidFinish:(RPPreviewViewController *)previewController {
    
}


- (void)dealloc {
    [_recordWindow removeFromSuperview];
    _recordWindow = nil;
}

@end
