//
//  QAPMBlueProfile.h
//  QAPM
//
//  Created by v_wxyawang on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMBlueProfile : NSObject

/**
 单例使用
 */
+ (instancetype)getInstance;

/**
 设置卡顿检测阈值(单位：s)，默认是0.2s
 */
@property (nonatomic, assign) NSTimeInterval stuckThreshold __attribute__((deprecated("It is deprecated and distributed by QAPM background configuration instead")));

/**
 设置blue系统方法堆栈记录开关，默认开启
 */
@property (nonatomic, assign) BOOL systemStackTraceEnable __attribute__((deprecated("The interface is deprecated")));

/**
 开始记录掉帧，建议滑动开始时调用
 
 * @param stage 用来标识当前页面(一般为当前VC类名）
 */
+ (void)beginTrackingWithStage:(NSString *)stage;

/**
 结束记录掉帧，滑动结束时调用
 
 * @param stage 用来标识当前页面(一般为当前VC类名）
 */
+ (void)stopTrackingWithStage:(NSString *)stage;

/**
 滑动场景区分，如果不需要则设置为0
 滑动结束时调用
 
 * @param type 设置为0时只有“Normal_Scroll"的数据，当设置为其他值时，掉帧数据里面会多一个类型为"UserDefineScollType_x"的数据
 */
+ (void)setScrollType:(int32_t)type __attribute__((deprecated("This interface is deprecated")));

@end

NS_ASSUME_NONNULL_END
