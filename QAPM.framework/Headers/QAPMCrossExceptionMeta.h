//
//  QAPMCrossExceptionMeta.h
//  QAPM
//
//  Created by 黄慰潼 on 2024/12/18.
//  Copyright © 2024 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QAPMCrossInfo.h"

typedef void (^ExceptionReportCallback)(BOOL success, NSString* uuid, NSInteger errorCode, NSString *errorMsg);


@interface QAPMCrossExceptionMeta : NSObject

@property (nonatomic, strong) NSString* uuid;
@property (nonatomic, assign) long long time; // 异常发生时间
@property (nonatomic, assign) QAPMCrossPlatform platform; // 跨端组件枚举
@property (nonatomic, copy) NSString *errorType; // 异常类型
@property (nonatomic, copy) NSString *pageId; // 页面信息
@property (nonatomic, copy) NSString *errorMsg; // 异常信息
@property (nonatomic, copy) NSArray* errorStack; // 异常堆栈
@property (nonatomic, copy) NSDictionary *extraInfo; // 额外信息
@property (nonatomic, copy) ExceptionReportCallback reportCallback;


@end
