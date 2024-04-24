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
 开启QAPM的常用功能包括卡顿功能、
 deadlock检测功能
 foom监控功能、App Store环境下有0.02的抽样
 Crash监控功能
 JSError监控功能
 web页面性能监控功能
 启动耗时监控功能
 掉帧率监控功能
 @param sampleFactor 本地功能采样，例如设置为1就是100%命中，一次命中后会持续命中，请保证设置的值在0~1之间。
 */
- (void)setupModelStable:(float)sampleFactor __attribute__((deprecated("Deprecated, use the setupModelStable interface in the QAPMModelStableConfig.h file instead")));
- (void)setupModelStable;

/**
 开启QAPM的所有功能,且设置本地功能抽样、所有功能包括
 deadlock检测功能
 foom监控功能、App Store环境下有0.02的抽样
 Crash监控功能
 HTTP监控功能
 JSError监控功能
 web页面性能监控功能
 启动耗时监控功能
 掉帧率监控功能
 @param sampleFactor 本地功能采样，例如设置为1就是100%命中，一次命中后会持续命中，请保证设置的值在0~1之间。
 */
- (void)setupModelAll:(float)sampleFactor __attribute__((deprecated("Deprecated, use the setupModelAll interface in the QAPMModelStableConfig.h file instead")));
- (void)setupModelAll;

/**
 @param wrappedPropertyDicts 设置AS字段，根据业务设置的字段，QAPM后台会进行开启功能的抽样率配置、该操作属于特殊设置、无特殊要求的用户不用设置，调用前请先和QAPM研发联系
 调用方式如下、需要调整哪个功能的特殊抽样就写哪个功能的，可在SDK初始化的地方进行如下操作：
 NSDictionary *wrappedPropertyDicts = @{
     [NSNumber numberWithUnsignedLongLong:QAPMMonitorTypeBlue]: @{@"as": @"AS42203"},
     [NSNumber numberWithUnsignedLongLong:QAPMMonitorTypeFramedrop]: @{@"as": @"AS42203"},
 };
[[QAPMModelStableConfig getInstance] setExtraConfigWithWrappedPropertyDicts:wrappedPropertyDicts];
 */
- (void)setExtraConfigWithWrappedPropertyDicts:(NSDictionary<NSNumber *, NSDictionary<NSString *, NSString *> *> *)wrappedPropertyDicts;
@end

NS_ASSUME_NONNULL_END
