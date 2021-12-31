//
//  QAPMBigChunkMemoryViewController.m
//  ApmDemo
//
//  Created by Cass on 2018/12/14.
//  Copyright © 2018 testcgd. All rights reserved.
//

#import "QAPMBigChunkMemoryViewController.h"
#import <mach/mach.h>
#import "UIButton+Utils.h"

@interface QAPMBigChunkMemoryViewController ()

@property (nonatomic, strong) UIButton *makeLargeMemoryBtn;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation QAPMBigChunkMemoryViewController

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
    
    _makeLargeMemoryBtn = [UIButton genBigGreenButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_makeLargeMemoryBtn addTarget:self action:@selector(mallocBigMemory) forControlEvents:UIControlEventTouchUpInside];
    [_makeLargeMemoryBtn setTitle:@"触发大块内存分配（100M）" forState:UIControlStateNormal];
    [self.view addSubview:_makeLargeMemoryBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    CGFloat labelWidth = 300;
    CGFloat labelHeight = 250;
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, contentY, labelWidth, labelHeight)];
    
    NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
    paragrahStyle.lineSpacing = 8;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"使用说明：\n1、点击触发申请大内存操作。\n2、监控到超过阈值申请内存会立刻上报数据。"];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragrahStyle
                             range:NSMakeRange(0, [attributedString length])];
    _descLabel.attributedText = attributedString;
    _descLabel.numberOfLines = 0;
    [_descLabel sizeToFit];
    
    [self.view addSubview:_descLabel];
}

- (void)mallocBigMemory
{
    int size = 100 * 1024 * 1024;
    char *info = malloc(size);
    memset(info, 1, size);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        free(info);
    });
}

@end
