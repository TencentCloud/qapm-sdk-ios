//
//  APMYellowViewController.m
//  ApmDemo
//
//  Created by casscai on 2019/4/19.
//  Copyright © 2018年 testcgd. All rights reserved.
//

#import "APMYellowViewController.h"
#import "APMYellowNextViewController.h"
#import "UIButton+Utils.h"
//#import <QAPM/QAPMUITimeMonitor.h>

@interface APMYellowViewController ()

@property (nonatomic, strong) APMYellowNextViewController *leakVC;

@property (nonatomic, strong) UIButton *enterLeakVCBtn;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation APMYellowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    
//    [[QAPMUITimeMonitor shared] setCustomEndLaunchTimestamp];

}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnHeight = 50.;
    CGFloat btnWidth = 200.;
    CGFloat btnGap = 44.;
    CGFloat contentX = (self.view.frame.size.width - btnWidth) / 2;
    CGFloat contentY = (self.view.frame.size.height - (btnHeight * 4 + btnGap * 3)) / 2;
    
    _enterLeakVCBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_enterLeakVCBtn addTarget:self action:@selector(enterLeakVC) forControlEvents:UIControlEventTouchUpInside];
    [_enterLeakVCBtn setTitle:@"Make A Leak VC" forState:UIControlStateNormal];
    [self.view addSubview:_enterLeakVCBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    CGFloat labelWidth = 250;
    CGFloat labelHeight = 250;
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, contentY, labelWidth, labelHeight)];
    
    NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
    paragrahStyle.lineSpacing = 8;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"使用说明：\n点击按钮后，请等待30s。30s后将会触发检测VC泄露逻辑并且上报数据。\n如果想缩短检测时间请在配置中设置检测阈值。"];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragrahStyle
                             range:NSMakeRange(0, [attributedString length])];
    _descLabel.attributedText = attributedString;
    _descLabel.numberOfLines = 0;
    [_descLabel sizeToFit];

    [self.view addSubview:_descLabel];
}



#pragma mark - Button Action
- (void)enterLeakVC {
    self.leakVC = [[APMYellowNextViewController alloc] init];
    self.leakVC.view.backgroundColor = [UIColor whiteColor];
    self.leakVC.title = @"Leak VC";
    [self.navigationController pushViewController:self.leakVC animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
