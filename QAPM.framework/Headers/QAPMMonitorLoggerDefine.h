//
//  QAPMonitorLoggerDefine.h
//  QAPM
//
//  Created by wxy on 2023/2/6.
//  Copyright © 2021 cass. All rights reserved.
//

#ifndef QAPMMonitorLoggerDefine_h
#define QAPMMonitorLoggerDefine_h

#ifdef __cplusplus
extern "C" {
#endif

/**
 日志级别
 */
typedef enum QAPMLoggerLevel {
    ///外发版本log
    QAPMLogLevel_Event = 0,
    ///灰度和内部版本log
    QAPMLogLevel_Info = 1,
    ///内部版本log
    QAPMLogLevel_Debug = 2,
} QAPMLoggerLevel;

/**
 用于输出SDK调试log的回调
 */
typedef void (*QAPM_Log_Callback)(QAPMLoggerLevel level, const char* log);

#ifdef __cplusplus
}  // extern "C"
#endif

#endif /* QAPMonitorLoggerDefine_h */
