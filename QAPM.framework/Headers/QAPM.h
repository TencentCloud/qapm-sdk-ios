//
//  QAPM.h
//  QAPM
//
//  SDK Version 5.2.2 Inner_Version
//
//  Created by Cass on 2018/5/18.
//  Copyright © 2018年 cass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QAPMConfig.h"
#import "QAPMModelStableConfig.h"
#import "QAPMUtilities.h"

NS_ASSUME_NONNULL_BEGIN

@interface QAPM : NSObject

/**
 使用指定配置初始化QAPM
 
 * @param appKey 注册QAPM分配的唯一标识
 */
+ (void)startWithAppKey:(NSString * __nonnull)appKey;

/**
 注册SDK内部日志回调，用于输出SDK内部日志
 
 @param logger 外部的日志打印方法
 */
+ (void)registerLogCallback:(QAPM_Log_Callback)logger;

/**
 APP使用过程中需要更新用id
 @param userId  重新设置用户ID
 */
+ (void)updateUserIdentifier:(NSString * __nonnull)userId;
/**
 SDK 版本信息

 @return SDK版本号
 */
+ (NSString *)sdkVersion;

/**
@return 代表的依次是blame_team和blame_reason，根据QAPMUploadEventType的功能类型来自定义返回值
*/

+ (NSDictionary<NSString *, NSString *> *)eventUpSendEventWithTyped:(QAPMUploadEventCallback)callBack;


@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface QAPMLaunchProfile : NSObject

/**
 开启启动耗时监控的调用
 */
+ (void)didEnterMain;

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


@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface QAPMBlueProfile : NSObject

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

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@interface QAPMWebViewProfile : NSObject

/**
 @param breadCrumbBuckets  自定义上报webview移动分析部分的分桶
 @return 返回注入的基本信息，包含QAPM的初始化信息
*/
+ (NSString *)qapmBaseInfo:(NSString *) breadCrumbBuckets;


/**
 @return 注入启动js监控的信息，请在resetConfig方法调用完之后调用
*/
+ (NSString *)qapmJsStart;

@end

NS_ASSUME_NONNULL_END
