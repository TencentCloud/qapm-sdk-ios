//
//  QAPMLaunchProfile.h
//  QAPM
//
//  Created by v_wxyawang on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMLaunchProfile : NSObject

/**
 单例使用
 */
+ (instancetype)getInstance;

/**
 设置堆内存监控抽样因子
 如factor=10，则按照1/10抽样,factor=100,则按照1/100抽样。默认1。
 */
@property (nonatomic, assign) uint32_t launchSampleFactor __attribute__((deprecated("It is deprecated and distributed by QAPM background configuration instead")));

/**
 设置启动耗时默认阈值， threshold 默认4000ms。
 */
@property (nonatomic, assign) NSTimeInterval launchthreshold __attribute__((deprecated("It is deprecated and distributed by QAPM background configuration instead")));
/**
 设置Debug模式，Debug模式下连接Xcode也会进行上报启动耗时，默认为NO.
 由于Debug下Xcode可能会额外加载一些动态库，导致启动耗时不准确，建议不调试进行上报数据。
 */
@property (nonatomic, assign) BOOL debugEnable __attribute__((deprecated("Deprecated and at the discretion of the SDK")));

/**
 开启启动耗时监控的调用
 */
+ (void)setupLaunchMonitor DEPRECATED_MSG_ATTRIBUTE("Replace it with the didEnterMain method");

+ (void)didEnterMain;

/**
 【必须调用API】请在AppDidFinishLaunch开始调用时设置。
*/
+ (void)setAppDidFinishLaunchBeginTimestamp __attribute__((deprecated("Deprecated, the applicationDidFinishLaunching function start timestamp has been counted by the SDK itself")));

/**
 【必须调用API】请在第一个页面ViewDidApppear开始调用时设置。
*/
+ (void)setFirtstViewDidApppearTimestamp __attribute__((deprecated("It is deprecated, and the SDK judges at its own discretion, and the end point of starting monitoring is the end point of the screen time of the first frame of the UI of the app")));

/**
 设置自定义打点区间开始，该区间需要在启动时间区间内。begin与end的scene需要一致。
 当设置了 setFirtstViewDidApppearTimestamp 后，后面设置的自定义打点区间将不会被统计。
 
 @param scene 场景名
 */
+ (void)setBeginTimestampForScene:(NSString *)scene;

/**
 设置自定义打点区间结束，该区间需要在启动时间区间内。begin与end的scene需要一致。
 当设置了 setFirtstViewDidApppearTimestamp 后，后面设置的自定义打点区间将不会被统计。
 
 @param scene 场景名
 */
+ (void)setEndTimestampForScene:(NSString *)scene;


/**
 设置自定义启动结束点， 可在业务认为启动结束的位置调用
 */
+ (void)customLaunchEnd;

@end

NS_ASSUME_NONNULL_END
