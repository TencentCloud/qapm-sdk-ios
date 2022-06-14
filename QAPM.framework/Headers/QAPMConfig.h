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

#pragma mark - Launch(检测启动耗时功能)配置
@interface QAPMLaunchConfig : NSObject
/**
 设置堆内存监控抽样因子
 如factor=10，则按照1/10抽样,factor=100,则按照1/100抽样。默认1。
 */
@property (nonatomic, assign) uint32_t launchSampleFactor;

/**
 设置启动耗时默认阈值， threshold 默认4000ms。
 */
@property (nonatomic, assign) NSTimeInterval launchthreshold;
/**
 设置Debug模式，Debug模式下连接Xcode也会进行上报启动耗时，默认为NO.
 由于Debug下Xcode可能会额外加载一些动态库，导致启动耗时不准确，建议不调试进行上报数据。
 */
@property (nonatomic, assign) BOOL debugEnable;

@end

#pragma mark - Blue(检测卡顿功能)配置
@interface QAPMBlueConfig : NSObject

/**
 设置blue卡顿检测阈值(单位：s)，默认是0.2s
 */
@property (nonatomic, assign) NSTimeInterval stuckThreshold;

/**
 设置blue系统方法堆栈记录开关，默认开启
 */
@property (nonatomic, assign) BOOL systemStackTraceEnable;

@end


#pragma mark - Yellow(检测VC泄露功能)配置
@interface QAPMYellowConfig : NSObject

/**
设置检测VC泄露阈值(单位：s)
 */
@property (nonatomic, assign) NSTimeInterval leakInterval;

/**
 设置开启UIView泄漏监控，将记录UIView泄漏对象。
 默认关闭功能。
 */
@property (nonatomic, assign) BOOL UIViewLeakEnable;

@end

#pragma mark - Sigkill(检测FOOM功能)配置
@interface QAPMSigkillConfig : NSObject


/**
 设置开启堆内存堆栈监控，将记录堆对象分配堆栈,默认开启。
 */
@property (nonatomic, assign) BOOL mallocMemoryDetectorEnable;

/**
 设置堆内存监控分配阈值 threshholdInBytes(bytes)，默认30M。
 */
@property (nonatomic, assign) size_t mallocMemoryThreshholdInByte;

/**
 设置VM内存监控分配阈值 threshholdInBytes(bytes)，默认30M。
 */
@property (nonatomic, assign) size_t vmMemoryThreshholdInByte;

/**
 设置堆内存监控抽样因子
 请将此值设置范围在0~1之间，默认值为0.02。
 */
@property (nonatomic, assign) float mallocSampleFactor;

/**
设置不进行抽样的内存阀值（bytes）
如sampleThreshhold=1024*1024，则超过1Mb的内存分配不进行抽样,默认30*1024。
 */
@property (nonatomic, assign) uint32_t mallocNoSampleThreshold;


/**
 设置开启VM堆栈监控，将记录堆对象分配堆栈。设置私有API __syscall_logger会带来app store审核不通过的风险，切记在提交关闭该监控，否则可能会审核不通过。
 该功能会影响Instruments的Allocation工具无法使用。
 设置方法：
 typedef void (malloc_logger_t)(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t num_hot_frames_to_skip);
 extern malloc_logger_t* __syscall_logger;
 [[QAPMConfig getInstance].sigkillConfig setVMLogger:(void**)&__syscall_logger];
 */
- (void)setVMLogger:(void *_Nonnull *_Nonnull)logger;

@end

#pragma mark - QQLeak(检测内存对象泄露功能)配置
@interface QAPMQQLeakConfig : NSObject


@end

#pragma mark - 资源使用情况监控功能配置
@interface QAPMResourceMonitorConfig : NSObject


@end

#pragma mark - 内存最大使用值监控(触顶率)配置
@interface QAPMMaxMemoryStatisticConfig : NSObject


@end

#pragma mark - 大块内存分配监控配置
@interface QAPMBigChunkMemoryMonitorConfig : NSObject


/**
 设置单次超大堆内存监控阈值（bytes)，阀值设置较大时，性能开销几乎影响不计。默认阈值50M。
 */
@property (nonatomic, assign) size_t singleChunkMallocThreadholdInByte;

@end

@interface QAPMHTTPMonitorConfig : NSObject

/**
 是否允许移动网络进行上报，默认移动网络允许上报。
 */
@property (nonatomic) BOOL allowsCellularAccess;

@end

#pragma mark - JSError功能配置
@interface QAPMJSErrorConfig : NSObject

- (BOOL)enable;

@end

#pragma mark - Web Monitor功能配置
@interface QAPMWebMonitorConfig : NSObject

- (BOOL)enable;

@end

#pragma mark - PowerConsume Monitor 耗电监控配置
@interface QAPMPowerConsumeMonitorConfig : NSObject

@end

#pragma mark - 全局配置
@interface QAPMConfig : NSObject

/**
 取得QAPM配置的共享实例，修改实例的属性必须在调用QAPM启动函数之前执行
 
 @return QAPMConfig的共享实例
 */
+ (instancetype)getInstance;

/**
自定义上传crash业务日志接口,该业务接口为文件路径
*/
@property (nonatomic, copy) NSString *customCrashUploadFilePath;

/**
 设置app自定义版本号,建议设置业务APP的版本号，不设置则取值业务APP的CFBundleShortVersionString版本号
 */
@property (nonatomic, copy) NSString *customerAppVersion;

/**
 设置用户Id，建议设置业务APP登录的第三方账号(QQ、手机号、微信号等)
 */
@property (nonatomic, copy) NSString *userId;

/**
 设置移动监控上报数据域名(非腾讯系产品用户使用：https://qapm.qq.com，内网用户无需设置)
 */
@property (nonatomic, copy) NSString *host;
/**
 设置appconfig的上报host，主要针对私有云设置，默认和host相同，不用额外填写
 */
@property (nonatomic, copy) NSString *appconfigHost;


/**
 设置符号表uuid，默认读取的是业务app符号表的uuid
 */
@property (nonatomic, copy) NSString *dysmUuid;

/**
 设置设备ID，应隐私合规要求不再默认取值QAPMOpenUDID，默认值为10000
 */
@property (nonatomic, copy) NSString *deviceID;

/**
 如果是在腾讯内部蓝盾流水线使用蓝盾插件自动上传符号表、或者本地使用shell自动上传符号表脚本，请设置为NO,上传符号表方式请参照接入文档。
 */
@property (nonatomic, assign) BOOL uuidFromDsym;

/**
 Appkey
 */
@property (nonatomic, copy) NSString *appKey;

/**
 如果没有接QAPMMonitorTypeCrash功能，请在发生normal_crash发生后调用，否则将影响整体crash指标的计算。
 */

- (void)appDidCrashed;
/**
设置abfactor，用于abtest的区分，string类型，默认是0，
*/
- (void)addABfactor:(NSString *)abfactor;

/**
 移除单个桶
 */
- (void)removeABfactor:(NSString *)abfactor;

/**
 移除所有的桶
 */
- (void)removeAllabfactor;

/**
 获取已经添加的所有的桶的信息
 
 @return 默认返回值为0
 */
- (NSString *)getABfactor;

/**
 获取Pid

 @return pid
 */
- (NSString *)pid;


/**
 设置开启的功能
 */
@property (nonatomic, assign) QAPMMonitorType enableMonitorTypeOptions;


/**
 设置launch功能
 */
@property (nonatomic, strong) QAPMLaunchConfig *launchConfig;


/**
 设置blue功能
 */
@property (nonatomic, strong) QAPMBlueConfig *blueConfig;

/**
 设置yellow功能
 */
@property (nonatomic, strong) QAPMYellowConfig *yellowConfig;

/**
 设置sigkill功能
 */
@property (nonatomic, strong) QAPMSigkillConfig *sigkillConfig;

/**
 设置QQLeak功能
 */
@property (nonatomic, strong) QAPMQQLeakConfig *qqleakConfig;

/**
 设置资源使用情况监控功能
 */
@property (nonatomic, strong) QAPMResourceMonitorConfig *resourceMonitorConfig;

/**
 设置内存最大使用值监控(触顶率)功能
 */
@property (nonatomic, strong) QAPMMaxMemoryStatisticConfig *maxMemoryStatisticConfig;

/**
 设置大块内存分配功能
 */
@property (nonatomic, strong) QAPMBigChunkMemoryMonitorConfig *bigChunkMemoryMonitorConfig;


/**
 设置HTTP监控功能
 */
@property (nonatomic, strong) QAPMHTTPMonitorConfig *httpConfig;

/**
 设置js error监控功能
 */
@property (nonatomic, strong) QAPMJSErrorConfig *jsErrorConfig;

/**
 设置web monitor监控功能
 */
@property (nonatomic, strong) QAPMWebMonitorConfig *webMonitorConfig;

/**
 设置耗电监控功能
 */
@property (nonatomic, strong) QAPMPowerConsumeMonitorConfig  *powerConsumeConfig;

@end

NS_ASSUME_NONNULL_END
