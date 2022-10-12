//
//  APMQQLeakViewController.m
//  ApmDemo
//
//  Created by cass on 2018/4/10.
//  Copyright © 2018年 testcgd. All rights reserved.
//

#import "APMQQLeakViewController.h"
#import "UIButton+Utils.h"
#import <QAPM/QAPMQQLeakProfile.h>

@interface APMQQLeakViewController ()

@property (nonatomic, strong) UIButton *startLogginBtn;

@property (nonatomic, strong) UIButton *makeLeakObjBtn;

@property (nonatomic, strong) UIButton *checkLeakBtn;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation APMQQLeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubviews];
    
    
}

- (void)setupSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnHeight = 50.;
    CGFloat btnWidth = 200.;
    CGFloat btnGap = 44.;
    CGFloat contentX = (self.view.frame.size.width - btnWidth) / 2;
    CGFloat contentY = 2 * btnGap;
    
    _startLogginBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_startLogginBtn addTarget:self action:@selector(startStackLogging) forControlEvents:UIControlEventTouchUpInside];
    [_startLogginBtn setTitle:@"开启记录对象内存分配" forState:UIControlStateNormal];
    [self.view addSubview:_startLogginBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    _makeLeakObjBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_makeLeakObjBtn addTarget:self action:@selector(makeALeakObject) forControlEvents:UIControlEventTouchUpInside];
    [_makeLeakObjBtn setTitle:@"创建一个泄露对象" forState:UIControlStateNormal];
    [self.view addSubview:_makeLeakObjBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    _checkLeakBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_checkLeakBtn addTarget:self action:@selector(checkLeak) forControlEvents:UIControlEventTouchUpInside];
    [_checkLeakBtn setTitle:@"检测内存泄漏" forState:UIControlStateNormal];
    [self.view addSubview:_checkLeakBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    CGFloat labelWidth = 300;
    CGFloat labelHeight = 250;
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, contentY, labelWidth, labelHeight)];
    
    NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
    paragrahStyle.lineSpacing = 8;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"使用说明：\n1、使用内存泄露检测功能，需要先开启记录对象内存分配。\n2、点击创建一个泄露对象。\n3、点击检测内存泄露。检测到泄露则数据会立刻上报。"];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragrahStyle
                             range:NSMakeRange(0, [attributedString length])];
    _descLabel.attributedText = attributedString;
    _descLabel.numberOfLines = 0;
    [_descLabel sizeToFit];
    
    [self.view addSubview:_descLabel];
}

- (void)startStackLogging {
    [QAPMQQLeakProfile startStackLogging];
}
    
- (void)stopStackLogging {
    [QAPMQQLeakProfile stopStackLogging];
}
    
- (void)checkLeak {
    [QAPMQQLeakProfile executeLeakCheck];
}

- (void)makeALeakObject
{

    char *p = (char *)malloc(5*1024);
    printf("p:\n%s",p);
    printf("p1:\n%p",&p);
}

@end
