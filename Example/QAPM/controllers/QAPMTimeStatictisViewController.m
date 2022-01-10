//
//  QAPMTimeStatictisViewController.m
//  ApmDemo
//
//  Created by Cass on 2018/12/14.
//  Copyright © 2018 testcgd. All rights reserved.
//

#import "QAPMTimeStatictisViewController.h"
#import "UIButton+Utils.h"
//#import <QAPM/QAPM.h>

@interface QAPMTimeStatictisViewController ()

@property (nonatomic, strong) UIButton *startBtn;

@property (nonatomic, strong) UIButton *stopBtn;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation QAPMTimeStatictisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
   
    [self setupSubviews];
}

- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnHeight = 50.;
    CGFloat btnWidth = 250.;
    CGFloat btnGap = 44.;
    CGFloat contentX = (self.view.frame.size.width - btnWidth) / 2;
    CGFloat contentY = 2 * btnGap;
    
    _startBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_startBtn addTarget:self action:@selector(beginTimeStatictis) forControlEvents:UIControlEventTouchUpInside];
    [_startBtn setTitle:@"开始耗时打点" forState:UIControlStateNormal];
    [self.view addSubview:_startBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    _stopBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_stopBtn addTarget:self action:@selector(stopTimeStatictis) forControlEvents:UIControlEventTouchUpInside];
    [_stopBtn setTitle:@"结束耗时打点" forState:UIControlStateNormal];
    [self.view addSubview:_stopBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    CGFloat labelWidth = 300;
    CGFloat labelHeight = 250;
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, contentY, labelWidth, labelHeight)];
    
    NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
    paragrahStyle.lineSpacing = 8;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"使用说明：\n1、点击开始耗时计时的起点。\n2、点击结束耗时计时的终点。会立刻上报时差数据。"];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragrahStyle
                             range:NSMakeRange(0, [attributedString length])];
    _descLabel.attributedText = attributedString;
    _descLabel.numberOfLines = 0;
    [_descLabel sizeToFit];
    
    [self.view addSubview:_descLabel];
}

//- (void)beginTimeStatictis {
//    /// 开始耗时打点
//    [QAPMTimeStatisticProfile beginStatisticTimeWithStage:NSStringFromClass([self class])];
//}
//
//- (void)stopTimeStatictis {
//    /// 结束耗时打点
//    [QAPMTimeStatisticProfile stopStatisticTimeWithStage:NSStringFromClass([self class])];
//}

@end
