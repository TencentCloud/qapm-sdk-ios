//
//  QAPMSigkillViewController.m
//  ApmDemo
//
//  Created by Cass on 2018/12/14.
//  Copyright © 2018 testcgd. All rights reserved.
//

#import "QAPMSigkillViewController.h"
#import "YYWeakProxy.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <mach/mach.h>
#import "UIButton+Utils.h"

@interface QAPMSigkillViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSTimer *memLabelTimer;
@property (nonatomic, strong) UILabel *memLabel;

@property (nonatomic, strong) UIButton *makeMallocBtn;

@property (nonatomic, strong) UIButton *makeVMMallocBtn;

@property (nonatomic, strong) UIButton *makeDeadlockBtn;

@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation QAPMSigkillViewController

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
    
    _makeMallocBtn = [UIButton genBigRedButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_makeMallocBtn addTarget:self action:@selector(mallocStackMemoryOOM) forControlEvents:UIControlEventTouchUpInside];
    [_makeMallocBtn setTitle:@"触发Malloc内存申请导致FOOM" forState:UIControlStateNormal];
    [self.view addSubview:_makeMallocBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    _makeVMMallocBtn = [UIButton genBigRedButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_makeVMMallocBtn addTarget:self action:@selector(vmMallocStackMemoryOOM) forControlEvents:UIControlEventTouchUpInside];
    [_makeVMMallocBtn setTitle:@"触发vm内存申请(需设置私有api)" forState:UIControlStateNormal];
    [self.view addSubview:_makeVMMallocBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    _makeDeadlockBtn = [UIButton genBigRedButtonWithFrame:CGRectMake(contentX, contentY, btnWidth, btnHeight)];
    [_makeDeadlockBtn addTarget:self action:@selector(runDeadLockCode) forControlEvents:UIControlEventTouchUpInside];
    [_makeDeadlockBtn setTitle:@"触发卡死" forState:UIControlStateNormal];
    [self.view addSubview:_makeDeadlockBtn];
    
    contentY = contentY + btnHeight + btnGap;
    
    _memLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentX, contentY, btnWidth, 30)];
    [self.view addSubview:self.memLabel];
    
    self.memLabelTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(updateMemLabel) userInfo:nil repeats:YES];
    self.arr = [NSMutableArray new];
    
    contentY = contentY + btnHeight + btnGap;
    
    CGFloat labelWidth = 300;
    CGFloat labelHeight = 250;
    CGFloat labelX = (self.view.frame.size.width - labelWidth) / 2;
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, contentY, labelWidth, labelHeight)];

    NSMutableParagraphStyle *paragrahStyle = [NSMutableParagraphStyle new];
    paragrahStyle.lineSpacing = 8;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"使用说明：\n1、点击内存申请按钮后，请等待FOOM，Crash后，将在下次启动后上报数据。\n2、触发卡死后，请手动kill掉app，数据将在下次启动后上报"];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragrahStyle
                             range:NSMakeRange(0, [attributedString length])];
    _descLabel.attributedText = attributedString;
    _descLabel.numberOfLines = 0;
    [_descLabel sizeToFit];

    [self.view addSubview:_descLabel];
}

- (void)mallocStackMemoryOOM {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                  target:[YYWeakProxy proxyWithTarget:self]
                                                selector:@selector(increaseMallocMemory)
                                                userInfo:nil repeats:YES];
}

- (void)vmMallocStackMemoryOOM {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:[YYWeakProxy proxyWithTarget:self]
                                                selector:@selector(increaseVMMallocMemory)
                                                userInfo:nil repeats:YES];
}

- (void)increaseMallocMemory {
    int i = 0;
        //测试最到数量 61371000
        while (i < 3000) {
            if (arc4random() % 2 == 0) {
                NSMutableArray *array = @[@"123",@"jhlj",@"kjahsdkahsdjkahsd",@"098",@"klal;a",@"1234567890awertyuiosdfghjkvbnmsdfghjkl;wertyuiop"].mutableCopy;
                [self.arr addObject:array];
            } else {
                [self.arr addObject:[NSObject new]];
            }
            ++i;
        }
}

- (void)increaseVMMallocMemory {
    vm_address_t adress;
    vm_size_t size = 1024 * 1024 * 100;
    vm_allocate((vm_map_t)mach_task_self(), &adress, size, VM_MAKE_TAG(200) | VM_FLAGS_ANYWHERE);
    
    for (int i = 0 ; i < 1024 * 1024 * 100; i++) {
        *((char *)adress + i) = 0x00;
    }
}

- (void)runDeadLockCode {
    while (YES);
}

- (void)updateMemLabel
{
    self.memLabel.text = [NSString stringWithFormat:@"当前内存: %.2fMB", [self memoryUsage] / 1024.0 / 1024.0];
    
}

- (int64_t)memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
    }
    return memoryUsageInByte;
}

- (float)usedSizeOfMemory {
    task_vm_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_VM_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(), TASK_VM_INFO_PURGEABLE, (task_info_t)&taskInfo, &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return 0.0f;
    }
    return ((taskInfo.internal + taskInfo.compressed - taskInfo.purgeable_volatile_pmap) / (1024.0 * 1024.0));
}

- (int64_t)vm_memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.virtual_size;
    }
    return memoryUsageInByte;
}

- (int64_t)rs_memoryUsage {
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.resident_size;
    }
    return memoryUsageInByte;
}

@end
