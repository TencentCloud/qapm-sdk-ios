//
//  QAPMConfig.h
//  QAPM
//
//  Created by Cass on 2018/11/29.
//  Copyright © 2018 cass. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAPMUtilities.h"

NS_ASSUME_NONNULL_BEGIN
 
#pragma mark - 全局配置
@interface QAPMConfig : NSObject

/**
 取得QAPM配置的共享实例，修改实例的属性必须在调用QAPM启动函数之前执行
 
 @return QAPMConfig的共享实例
 */
+ (instancetype)getInstance;

/**
 【必须调用API】设置app自定义版本号,建议设置业务APP的版本号
 */
@property (nonatomic, copy) NSString *customerAppVersion;

/**
 【必须调用API】设置用户Id，建议设置业务APP登录的第三方账号(QQ、手机号、微信号等)
 */
@property (nonatomic, copy) NSString *userId;

/**
 【必须调用API】设置设备ID，一般情况下建议设置为IDFV，此参数作为计算各功能的指标值，请谨慎设置
 */
@property (nonatomic, copy) NSString *deviceID;

/**
 设置移动监控上报数据域名(公有云非腾讯系产品用户使用：https://qapm.qq.com，内网用户无需设置，私有云用户请按实际情况填写)
 */
@property (nonatomic, copy) NSString *host;

/**
 设置appconfig的上报host，公有云情况下默认和host相同，不用额外填写，私有云环境以实际情况为准
 */
@property (nonatomic, copy) NSString *appconfigHost;

/**
 设置符号表uuid，默认读取的是业务app符号表的uuid，腾讯云内网产品如果用到自动上传符号表脚本，请根据蓝盾插件进行正确赋值,否则影响自动上传符号表功能。
 */
@property (nonatomic, copy) NSString *dysmUuid;

/**
 如果是在腾讯内部蓝盾流水线使用蓝盾插件自动上传符号表、或者本地使用shell自动上传符号表脚本，请设置为NO,
 */
@property (nonatomic, assign) BOOL uuidFromDsym __attribute__((deprecated("Deprecated and at the discretion of the SDK")));

/**
 内部调用，用户在web页面申请到的Appkey
 */
@property (nonatomic, copy) NSString *appKey;

/**
 内部调用，appKey截取后的数值

 @return pid
 */
- (NSString *)pid;

/**
自定义上传crash业务日志接口,该业务接口为文件路径
*/
@property (nonatomic, copy) NSString *customCrashUploadFilePath __attribute__((deprecated("Deprecated, use the setCrashEventCallback interface in the QAPM.h file instead")));

/**
 设置开启的功能
 */
@property (nonatomic, assign) QAPMMonitorType enableMonitorTypeOptions;

/**
 该设置用于告知监控是否可以进行可选个人信息的采集，默认可以采集。设置为false则不采集。该设置需要最先配置，一旦设置则全局生效。
 该设置置为false，部分信息将不再获取，可能会影响到前端的搜索、展示等，请知悉！
 */
@property (nonatomic, assign) BOOL collectOptionalFields;
@end

NS_ASSUME_NONNULL_END
