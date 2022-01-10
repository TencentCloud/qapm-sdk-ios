//
//  APMYellowNextViewController.m
//  ApmDemo
//
//  Created by wakeen on 2018/4/10.
//  Copyright © 2018年 testcgd. All rights reserved.
//

#import "APMYellowNextViewController.h"

@interface APMYellowNextViewController ()

@end

@implementation APMYellowNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 100, 250, 400)];
    label.text = @"这是一个被强引用的界面，返回后请停留在上一个界面。默认30秒触发检测";
    label.numberOfLines = 0;
    label.textColor = [UIColor blackColor];
    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
