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
 用于输出上报事件
 */
typedef NSDictionary *(*QAPMUploadEventCallback)(QAPMUploadEventType eventType, id stackInfo);

extern QAPMUploadEventCallback uploadEventCallback;

#endif /* QAPMUtilities_h */
