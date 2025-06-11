//
//  QAPMSSERequestContext.h
//  QAPM
//
//  Created on 2025/4/1.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface QAPMSSERequestContext : NSObject

// 该次SSE请求相关上下文信息
@property (nonatomic, copy, readonly) NSString *url;
@property (nonatomic, copy, readonly) NSURLRequest *request;
@property (nonatomic, copy, readonly) NSURLResponse *response;
@property (nonatomic, strong) NSMutableArray<NSString *> *receivedMessages;

// 是否卡死了
@property (nonatomic, assign) BOOL isStalled;

// 请求发生的错误， 如果请求正常则为空
@property (nonatomic, strong) NSError *error;

/** 开放字段d15-d19，用于指标聚合*/
@property (nonatomic, strong) NSString *d15;
@property (nonatomic, strong) NSString *d16;
@property (nonatomic, strong) NSString *d17;
@property (nonatomic, strong) NSString *d18;
@property (nonatomic, strong) NSString *d19;


/** 开放字段d20-d29，用于日志上下文展示*/
@property (nonatomic, strong) NSString *d20;
@property (nonatomic, strong) NSString *d21;
@property (nonatomic, strong) NSString *d22;
@property (nonatomic, strong) NSString *d23;
@property (nonatomic, strong) NSString *d24;
@property (nonatomic, strong) NSString *d25;
@property (nonatomic, strong) NSString *d26;
@property (nonatomic, strong) NSString *d27;
@property (nonatomic, strong) NSString *d28;
@property (nonatomic, strong) NSString *d29;


/** 开放字段v20-v29，用于日志上下文展示*/
@property (nonatomic, assign) NSInteger v20;
@property (nonatomic, assign) NSInteger v21;
@property (nonatomic, assign) NSInteger v22;
@property (nonatomic, assign) NSInteger v23;
@property (nonatomic, assign) NSInteger v24;
@property (nonatomic, assign) NSInteger v25;
@property (nonatomic, assign) NSInteger v26;
@property (nonatomic, assign) NSInteger v27;
@property (nonatomic, assign) NSInteger v28;
@property (nonatomic, assign) NSInteger v29;

- (instancetype)initWithURL:(NSString *)url request:(NSURLRequest *)request response:(NSURLResponse *)response;
@end


typedef void (^QAPMOnSSEMessageCallback)(QAPMSSERequestContext *context);
typedef void (^QAPMOnSSECompletionCallback)(QAPMSSERequestContext *context);
