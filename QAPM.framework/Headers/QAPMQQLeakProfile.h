//
//  QAPMQQLeakProfile.h
//  QAPM
//
//  Created by v_wxyawang on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMQQLeakProfile : NSObject

/**
 开始记录内存分配堆栈，需要开启后才能进行检测。
 */
+ (void)startStackLogging;
    
/**
 停止记录内存分配堆栈
 */
+ (void)stopStackLogging;
    
/**
 执行一次泄露检测，建议在主线程调用，该操作会挂起所有子线程进行泄露检测（该操作较耗时，平均耗时在1s以上，请限制调用频率）
 */
+ (void)executeLeakCheck;

@end

NS_ASSUME_NONNULL_END
