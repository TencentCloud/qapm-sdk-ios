//
//  QAPM.h
//  QAPM
//
//  SDK Version 5.3.4 Inner_Version
//
//  Created by Cass on 2018/5/18.
//  Copyright © 2018年 cass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QAPMConfig.h"
#import "QAPMModelStableConfig.h"
#import "QAPMUtilities.h"
#include "QAPMMonitorLoggerDefine.h"

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
@param callBack 表示的是发生卡顿、foom、deadlock、普通崩溃其中一种后上报QAPM后台，返回业务设置自定义字段，输出堆栈信息。
*/
+ (void)eventUpSendEventWithTyped:(QAPMUploadEventCallback)callBack;

/**
 @param callback 上报成功后返回信息、主要包含后台返回的唯一标识符和各功能的唯一标识、供用户统计使用。
 */
+ (void)monitorStartCallback:(QAPMMonitorStartCallback)callback;

/**
 发生crash的现场回调
 
 @param callback 发生crash时的回调， 其返回值为自定义文件路径， 该文件会在app下一次启动时与崩溃信息一起上报到后台， qapm sdk仅上传该文件，不会删除。
*/
+ (void)setCrashEventCallback:(QAPMUploadCrashEventCallback)callback;

/**
 监控功能开启状态回调。
 
 @param type state 功能状态, type 功能类相关。
 */
+ (BOOL)monitorEnableWithType:(QAPMMonitorType)type;

@end

NS_ASSUME_NONNULL_END
