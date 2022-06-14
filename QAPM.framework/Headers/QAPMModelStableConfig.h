//
//  QAPMModelStableConfig.h
//  QAPM-WithCrash-WithAthena
//
//  Created by wxy on 2021/9/17.
//  Copyright © 2021 cass. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMModelStableConfig : NSObject
+ (instancetype)getInstance;

/**
 开启QAPM的所有稳定性功能,且设置本地功能抽样，稳定性功能包括卡顿功能、
 deadlock检测功能
 foom监控功能、release环境下有0.02的抽样
 VC泄露功能
 资源使用情况监控功能
 内存最大使用值监控(触顶率)
 大块内存分配监控功能
 Crash监控功能
 HTTP监控功能
 JSError监控功能
 web页面性能监控功能
 启动耗时监控功能
 @param sampleFactor 本地功能采样，例如设置为1就是100%命中，一次命中后会持续命中，请保证设置的值在0~1之间。
 */
- (void)setupModelStable:(float)sampleFactor;

/**
 开启QAPM的所有功能,且设置本地功能抽样、所有功能包括
 deadlock检测功能
 foom监控功能、release环境下有0.02的抽样
 VC泄露功能
 资源使用情况监控功能
 内存最大使用值监控(触顶率)
 大块内存分配监控功能
 Crash监控功能
 HTTP监控功能
 JSError监控功能
 检测内存对象泄露功能
 web页面性能监控功能
 启动耗时监控功能
 @param sampleFactor 本地功能采样，例如设置为1就是100%命中，一次命中后会持续命中，请保证设置的值在0~1之间。
 */
- (void)setupModelAll:(float)sampleFactor;
@end

NS_ASSUME_NONNULL_END
