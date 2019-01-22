//
//  ViewController.m
//  RccordTest
//
//  Created by ylh on 2018/7/18.
//  Copyright © 2018年 ylh. All rights reserved.
//

#import "ViewController.h"


#import "RecordVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *beginRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    beginRecordBtn.backgroundColor = [UIColor orangeColor];
    beginRecordBtn.frame = CGRectMake(100, 100, 100, 100);
    [beginRecordBtn addTarget:self action:@selector(beginRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:beginRecordBtn];

    
}

- (void)beginRecordBtnClick:(UIButton *)btn {
    RecordVC *vc = [[RecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
