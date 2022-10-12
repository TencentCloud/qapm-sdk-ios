//
//  QAPMFoomProfile.h
//  QAPM
//
//  Created by v_wxyawang on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMFoomProfile : NSObject

/**
 单例使用
 */
+ (instancetype)getInstance;

/**
 设置开启堆内存堆栈监控，将记录堆对象分配堆栈,默认开启。
 */
@property (nonatomic, assign) BOOL mallocMemoryDetectorEnable __attribute__((deprecated("已弃用，改由QAPM后台配置下发")));

/**
 设置堆内存监控分配阈值 threshholdInBytes(bytes)，默认30M。
 */
@property (nonatomic, assign) size_t mallocMemoryThreshholdInByte __attribute__((deprecated("已弃用，改由QAPM后台配置下发")));

/**
 设置VM内存监控分配阈值 threshholdInBytes(bytes)，默认30M。
 */
@property (nonatomic, assign) size_t vmMemoryThreshholdInByte __attribute__((deprecated("已弃用，改由QAPM后台配置下发")));

/**
 设置堆内存监控抽样因子
 请将此值设置范围在0~1之间，默认值为0.02。
 */
@property (nonatomic, assign) float mallocSampleFactor __attribute__((deprecated("已弃用，改由QAPM后台配置下发")));

/**
设置不进行抽样的内存阀值（bytes）
如sampleThreshhold=1024*1024，则超过1Mb的内存分配不进行抽样,默认30*1024。
 */
@property (nonatomic, assign) uint32_t mallocNoSampleThreshold __attribute__((deprecated("已弃用，改由QAPM后台配置下发")));

/**
 设置开启VM堆栈监控，将记录堆对象分配堆栈。设置私有API __syscall_logger会带来app store审核不通过的风险，切记在提交关闭该监控，否则可能会审核不通过。
 该功能会影响Instruments的Allocation工具无法使用。
 设置方法：
 typedef void (malloc_logger_t)(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t num_hot_frames_to_skip);
 extern malloc_logger_t* __syscall_logger;
 [[QAPMConfig getInstance].sigkillConfig setVMLogger:(void**)&__syscall_logger];
 */
- (void)setVMLogger:(void *_Nonnull *_Nonnull)logger;

@end

NS_ASSUME_NONNULL_END
