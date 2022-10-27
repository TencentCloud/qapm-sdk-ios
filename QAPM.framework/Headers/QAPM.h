//
//  QAPM.h
//  QAPM
//
//  SDK Version 5.2.5 Inner_Version
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
@param callBack  返回对应类型的堆栈信息
@return 代表的依次是blame_team和blame_reason，根据QAPMUploadEventType的功能类型来自定义返回值
*/

+ (NSDictionary<NSString *, NSString *> *)eventUpSendEventWithTyped:(QAPMUploadEventCallback)callBack;

/**
 监控功能开启状态回调。提供用于Athena的使用
 
 @param callback state 功能状态, type 功能类相关。
 */
+ (void)monitorStartCallback:(QAPMMonitorStartCallback)callback __attribute__((deprecated("已弃用该接口")));

/**
 监控功能开启状态回调。
 
 @param type state 功能状态, type 功能类相关。
 */
+ (BOOL)monitorEnableWithType:(QAPMMonitorType)type;

@end

NS_ASSUME_NONNULL_END
