//
//  QAPMHTTPViewController.m
//  ApmDemo
//
//  Created by Cass on 2019/6/19.
//  Copyright © 2019 testcgd. All rights reserved.
//

#import "QAPMHTTPViewController.h"
@interface QAPMHTTPViewController () <UITableViewDelegate, UITableViewDataSource,NSURLSessionDelegate,NSURLSessionTaskDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSString *> *mArray;

@property (strong,nonatomic)NSURLSessionTask * task;

@property (strong,nonatomic)NSURLSession * session;


@end

@implementation QAPMHTTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"HTTP监控Demo";

    [self setupSubviews];
    
    self.mArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"A_QAPM_HTTPMonitorURLList"];
 
    [self.tableView reloadData];
}

- (void)setupSubviews {
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Tableview datasource and delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:@"HTTPCell"];
    NSString *url = self.mArray[indexPath.row];
    cell.textLabel.text = url;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *url = self.mArray[indexPath.row];
    
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

                NSString *content;
                if (data) {
                    content = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                }

                NSLog(@"HTTP请求URL: %@, 请求返回内容: %@", request.URL.absoluteString, content);

    }];

      self.task = task;

        if (self.task.state == NSURLSessionTaskStateSuspended) {
               [self.task resume];
        }
    
    
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)mArray {
    if (!_mArray) {
        _mArray = [NSMutableArray array];
    }
    return _mArray;
}

@end
