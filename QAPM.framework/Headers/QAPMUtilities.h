//
//  QAPMUtilities.h
//  QAPM
//
//  Created by Cass on 2018/11/7.
//  Copyright © 2018 cass. All rights reserved.
//

#ifndef QAPMUtilities_h
#define QAPMUtilities_h

/**
 日志级别
 */
typedef NS_ENUM(NSInteger, QAPMLoggerLevel) {
    ///外发版本log
    QAPMLogLevel_Event,
    ///灰度和内部版本log
    QAPMLogLevel_Info,
    ///内部版本log
    QAPMLogLevel_Debug,
};

/**
 开启功能类型
 */

typedef enum {
    
    QAPMMonitorTypeNone                     = 1UL << 0,
    
    /// 掉帧率
    QAPMMonitorTypeFramedrop                = 1UL << 2,
    
    ///Blue(检测卡顿功能)
    QAPMMonitorTypeBlue                     = 1UL << 3,
    
    /// 大块内存分配监控功能
    QAPMMonitorTypeBigChunkMemoryMonitor    = 1UL << 4,

    /**
     QQLeak(检测内存对象泄露功能)
     开启后，会记录对象分配的堆栈，不支持模拟器。
     执行检测一次检测请调用: [QAPMQQLeakProfile executeLeakCheck];
     执行一次泄露检测，建议在主线程调用，该操作会挂起所有子线程进行泄露检测（该操作较耗时，平均耗时在1s以上，请限制调用频率）。
     建议研发流程内使用。
     */
    QAPMMonitorTypeQQLeak                   = 1UL << 5,
    
    /// Yellow(检测VC泄露功能)
    QAPMMonitorTypeYellow                   = 1UL << 6,
    
    /// 内存最大使用值监控(触顶率)
    QAPMMonitorTypeMaxMemoryStatistic       = 1UL << 7,
    
    
    /// 资源使用情况监控功能（每隔1s采集一次资源）
    QAPMMonitorTypeResourceMonitor          = 1UL << 9,
    
    /// normalCrash监控功能
    QAPMMonitorTypeCrash                    = 1UL << 10,
    
    /// foom监控功能
    QAPMMonitorTypeFoom                     = 1UL << 11,
    
    /// 网络监控
    QAPMMonitorTypeHTTPMonitor              = 1UL << 13,
            
    /// 用户行为监控功能
    QAPMMonitorTypeIUPMonitor               = 1UL << 15,
    
    //耗电监控功能
    QAPMMonitorTypePowerConsume             = 1UL << 16,
    
    /// deadlock监控功能
    QAPMMonitorTypeDeadlock                 = 1UL << 19,
    
    ///自定义卡顿
    QAPMMonitorTypeCustomStuck              = 1UL << 20,
    
    /// 启动个例监控功能
    QAPMMonitorTypeLaunch                   = 1UL << 22,
    
    ///crash指标数据
    QAPMMonitorTypeCrashIndicators          = 1UL << 31,
    
    ///webview的网络
    QAPMMonitorTypeWebViewNetWork           = 1UL << 32,
    
    /// WebView的启动
    QAPMMonitorTypeWebMonitor               = 1UL << 34,

    /// webview的JSError
    QAPMMonitorTypeJSError                  = 1UL << 35,

    ///webview的用户抽样率
    QAPMMonitorTypeWebViewSampleration      = 1UL << 36,

    ///webview的性能事件
    QAPMMonitorTypeWebViewIUPMonitor        = 1UL << 37,
    
} QAPMMonitorType;

/**
 上报事件类型
 */
typedef NS_ENUM(NSInteger, QAPMUploadEventType) {
    /// 卡顿
    QAPMUploadEventTypeLAG                  = 0,
    /// foom
    QAPMUploadEventTypeFoom                 = 1,
    /// deadlock
    QAPMUploadEventTypeDeadlock             = 2,
    //普通奔溃
    QAPMUploadEventTypeCrash                = 3,
    
};

/**
 用于输出SDK调试log的回调
 */
typedef void(*QAPM_Log_Callback)(QAPMLoggerLevel level, const char* log);

/**
 功能开启时的回调，用于所有输出上报事件标识的回调
 */
typedef void(*QAPMMonitorStartCallback)(NSMutableDictionary *dictionary) __attribute__((deprecated("已弃用该接口")));


/**
 用于输出卡顿、foom、deadlock 上报事件的回调
 */
typedef NSDictionary *(*QAPMUploadEventCallback)(QAPMUploadEventType eventType, id stackInfo);

extern QAPMUploadEventCallback uploadEventCallback;

extern QAPMMonitorStartCallback monitorStartCallback __attribute__((deprecated("已弃用该接口")));

#endif /* QAPMUtilities_h */
