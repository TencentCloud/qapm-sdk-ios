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
 deadlock检测功能、
 VC泄露功能、
 资源使用情况监控功能、
 内存最大使用值监控(触顶率、
 大块内存分配监控功能、
 Crash监控功能、
 HTTP监控功能 、
 JSError监控功能 、
 web页面性能监控功能 、
 用户行为监控功能、
 启动耗时监控功能
 @param factor 例如设置1/10抽样，则设置fatctor = 10
 */
- (void)getModelStable:(NSInteger)factor;

/**
 开启QAPM的所有功能,且设置本地功能抽样、所有功能包括
 deadlock检测功能、
 VC泄露功能、
 资源使用情况监控功能、
 内存最大使用值监控(触顶率、
 大块内存分配监控功能、
 Crash监控功能、
 HTTP监控功能 、
 JSError监控功能 、
 耗电监控功能
 检测内存对象泄露功能
 web页面性能监控功能 、
 用户行为监控功能、
 启动耗时监控功能

 @param factor 例如设置1/10抽样，则设置fatctor = 10
 */
- (void)getModelAll:(NSInteger)factor;
@end

NS_ASSUME_NONNULL_END
