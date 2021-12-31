//
//  QAPMResourceMonitorViewController.m
//  ApmDemo
//
//  Created by Cass on 2018/10/15.
//  Copyright © 2018 testcgd. All rights reserved.
//

#import "QAPMResourceMonitorViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <arpa/inet.h>
#import <netdb.h>
#import "UIButton+Utils.h"
#import <QAPM/QAPM.h>

@interface QAPMResourceMonitorViewController ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) UIButton *startTagBtn;

@property (nonatomic, strong) UIButton *stopTagBtn;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation QAPMResourceMonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat btnHeight = 50.;
    CGFloat btnWidth = 300;
    CGFloat btnGap = 44.;
    CGFloat contentX = (self.view.frame.size.width - btnWidth) / 2;
    CGFloat contentY = 2 * btnGap;
    
    _startTagBtn = [UIButton genBigRedButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_startTagBtn addTarget:self action:@selector(setBeginTag) forControlEvents:UIControlEventTouchUpInside];
    [_startTagBtn setTitle:@"设置资源采集开始tag" forState:UIControlStateNormal];
    [self.view addSubview:_startTagBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    _stopTagBtn = [UIButton genBigRedButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_stopTagBtn addTarget:self action:@selector(setEndTag) forControlEvents:UIControlEventTouchUpInside];
    [_stopTagBtn setTitle:@"设置资源监控结束tag" forState:UIControlStateNormal];
    [self.view addSubview:_stopTagBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    CGFloat labelWidth = 300;
    CGFloat labelHeight = 250;
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, contentY, labelWidth, labelHeight)];
    
    NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
    paragrahStyle.lineSpacing = 8;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"使用说明：\n1、开启资源采集功能后，会每秒采集CPU、内存等信息，一分钟上一次。\n2、设置tag可以作为某个区间段的标记，会在上报时附带进去。"];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragrahStyle
                             range:NSMakeRange(0, [attributedString length])];
    _descLabel.attributedText = attributedString;
    _descLabel.numberOfLines = 0;
    [_descLabel sizeToFit];
    
    [self.view addSubview:_descLabel];
}


- (void)setBeginTag {
    [QAPMResourceMonitorProfile setBeginTag:@"playVideo"];
}

- (void)setEndTag {
    [QAPMResourceMonitorProfile setStopTag:@"playVideo"];
}

@end
