//
//  APMMainListViewController.m
//  ApmDemo
//
//  Created by wakeen on 2018/4/10.
//  Copyright © 2018年 testcgd. All rights reserved.
//

#import "APMMainListViewController.h"
#import <QAPM/QAPM.h>
#import "APMBlueViewController.h"
#import "APMYellowViewController.h"
#import "APMQQLeakViewController.h"
#import <mach/mach_time.h>
@interface APMMainListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong) NSTimer *timer;


@end

@implementation APMMainListViewController {
    NSArray *_titleArray;
    NSArray *_vcArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"测试Demo";
    
    _titleArray = @[@"QAPMMonitorTypeYellow(VC泄露监控)", @"QAPMMonitorTypeBlue(卡顿与掉帧率)", @"QAPMMonitorTypeSigkill(FOOM与卡死Crash)", @"QAPMMonitorTypeQQLeak(内存泄露监控)", @"QAPMMonitorTypeBigChunkMemoryMonitor(大内存分配监控)",@"QAPMMonitorTypeResourceMonitor(资源监控)",@"QAPMMonitorTypeCrash(Crash监控)",@"WKWebView监控", @"HTTP监控"];
    _vcArray = @[@"APMYellowViewController", @"APMBlueViewController", @"QAPMSigkillViewController", @"APMQQLeakViewController", @"QAPMBigChunkMemoryViewController",@"QAPMResourceMonitorViewController",@"QAPMCrashViewController",@"QAPMWKWebViewViewController", @"QAPMHTTPViewController"];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    
 
    UIBarButtonItem *rightBarItem2 = [[UIBarButtonItem alloc] initWithTitle:@"满CPU3秒" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItemAction2)];
     
    self.navigationItem.rightBarButtonItem = rightBarItem2;
    
  
}


- (void)rightBarItemAction2 {
    
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        while (1) {};
    }];
    [thread start];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
  
}

#pragma mark - TableView datasource and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"UITableViewCellIdentifier%@", @(indexPath.row)]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Class vcClass = NSClassFromString(_vcArray[indexPath.row]);
    UIViewController *vc = [[vcClass alloc] init];
    vc.title = _titleArray[indexPath.row];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

