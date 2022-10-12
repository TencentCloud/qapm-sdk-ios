//
//  APMBlueViewController.m
//  ApmDemo
//
//  Created by wakeen on 2018/4/10.
//  Copyright © 2018年 testcgd. All rights reserved.
//

#import "APMBlueViewController.h"
#import <QAPM/QAPMBlueProfile.h>

 
@interface APMBlueViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation APMBlueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.rowHeight = 40;
    [self.view addSubview:self.tableView];
    
    CGFloat labelWidth = self.view.bounds.size.width;
    CGFloat labelHeight = 250;
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    CGFloat labelY = 0;
    
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelWidth, labelHeight)];
    
    NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
    paragrahStyle.lineSpacing = 8;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"使用说明：\n 1、卡顿测试请点击右上角按钮，检测到卡顿后会立刻上报数据。\n 2、掉帧率统计：在页面代码打点后，反复滑动此页面，kill掉app后，数据会在下次启动后上报。掉帧率数据第二天才能在页面上展示。"];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragrahStyle
                             range:NSMakeRange(0, [attributedString length])];
    _descLabel.attributedText = attributedString;
    _descLabel.numberOfLines = 0;
    _descLabel.backgroundColor = [UIColor whiteColor];
    
    [self.tableView addSubview:_descLabel];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"卡顿2秒" style:UIBarButtonItemStylePlain target:self action:@selector(stuckMethod)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [QAPMBlueProfile stopTrackingWithStage:NSStringFromClass([self class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"UITableViewCellIdentifier%@", @(indexPath.row)]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (NSInteger i=0; i<60; i++)
    {
        UIImage *image = [self imageWithColor:[UIColor blueColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(i*6, 12.5, 5, 5);
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 2.5;
        [cell addSubview:imageView];
    }
    return cell;
}

- (void)drawCircleImage:(UIImage *)image {
    
    CGFloat side = MIN(image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), false, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(),
                     [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, side, side)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    CGFloat marginX = -(image.size.width - side) / 2.f;
    CGFloat marginY = -(image.size.height - side) / 2.f;
    [image drawInRect:CGRectMake(marginX, marginY, image.size.width, image.size.height)];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [QAPMBlueProfile beginTrackingWithStage:NSStringFromClass([self class])];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate){
        [QAPMBlueProfile stopTrackingWithStage:NSStringFromClass([self class])];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [QAPMBlueProfile stopTrackingWithStage:NSStringFromClass([self class])];
}

#pragma mark - NavigationBarItem Action
- (void)stuckMethod {
    sleep(2);
    NSLog(@"卡顿2秒");
  
}

@end
