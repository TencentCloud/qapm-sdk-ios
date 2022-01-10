//
//  QAPMCrashViewController.m
//  ApmDemo
//
//  Created by Cass on 2019/4/1.
//  Copyright © 2019 testcgd. All rights reserved.
//

#import "QAPMCrashViewController.h"
#import "Crasher.h"
//#import <QAPM/QAPM.h>

@interface QAPMCrashViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation QAPMCrashViewController
{
    NSArray *_titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titleArray = @[@"throwUncaughtNSException",
                    @"dereferenceBadPointer",
                    @"dereferenceNullPointer",
                    @"useCorruptObject",
                    @"spinRunloop",
                    @"causeStackOverflow",
                    @"doAbort",
                    @"doDiv0",
                    @"doIllegalInstruction",
                    @"accessDeallocatedObject",
                    @"accessDeallocatedPtrProxy",
                    @"zombieNSException",
                    @"corruptMemory",
                    @"deadlock",
                    @"pthreadAPICrash",
                    @"userDefinedCrash",
                    @"throwUncaughtCPPException",
                    @"recursivelyUnfairLock",
                    @"beyondary"
                    ];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    self.tableView.rowHeight = 60;
    [self.view addSubview:self.tableView];
    
    [self.tableView reloadData];
    
}

#pragma mark - Tableview DataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CrashCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *methodName = _titleArray[indexPath.row];
    SEL selector = NSSelectorFromString(methodName);
    [[[Crasher alloc] init] performSelector:selector withObject:nil afterDelay:0.1];
}

#pragma mark - Crash Test Method
//- (void)makeCrash {
//    NSMutableArray   *test = [NSMutableArray array];
//    [test addObject:nil];
//}
//
//- (void)machCrash {
////    int i = 1;
////    *(int *)i = 1234;
//
//    char* ptr = (char*)-1;
//    *ptr = 10;
//}
//
//- (void)causeStackOverflow {
////    [[Crasher new] causeStackOverflow];
////    [[Crasher new] corruptMemory];
//}

@end
