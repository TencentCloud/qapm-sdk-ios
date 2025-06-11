//
//  QAPMNetworkTransaction.h
//  QAPM
//
//  Created on 2025/3/26.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  自定义网络上报， 使用方式：
 *   1. 创建transaction QAPMNetworkTransaction* trannsaction = [[QAPMNetworkTransaction alloc] initWithUrl:@"http://www.qq.com"];
 *   2. 在请求开始时调用 [trannsaction start];
 *   3. 设置请求的相关信息，如：[trannsaction setMethod:@"GET"];  [trannsaction setCode:200];  等
 *   4. 在请求结束时调用 [trannsaction finish]; 之后该请求结束， SDK会自动进行上报
 *
 *   注意：
 *      1. 请求的耗时为 start 到 finish 的时间差， 所以必须在请求开始时调用 start 方法
 *      2. 在请求结束时，必须调用 finish 方法，否则该请求不会被上报
 *
 *   使用示例：
 *   ```
 *   QAPMNetworkTransaction* transaction = [[QAPMNetworkTransaction alloc] initWithUrl:@"http://www.qq.com"];
 *   [trannsaction start];
 *   [trannsaction setMethod:@"GET"];
 *   [trannsaction setCode:200];
 *   [trannsaction finish];
 *   ```
 */
@interface QAPMNetworkTransaction : NSObject

/**
 * @brief 使用指定的 URL 初始化对象
 *
 * 使用给定的 URL 来初始化一个对象实例。
 *
 * @param url 对象的 URL 地址
 *
 * @return 初始化后的对象实例
 */
-(instancetype)initWithUrl:(NSString*)url;

/**
 * @brief 通过URL和库名进行初始化
 *
 * 该函数通常不需要被直接使用。
 *
 * @param url 初始化的URL
 * @param library 库名
 */
-(instancetype)initWithUrl:(NSString *)url library:(NSString*)library;

// 请求开始
-(void)start;

/**
 * @brief 生成sw8协议的traceId， 用于全链路上报，生成traceId后， 需要手动将traceId设置到真实请求的header中
 *
 * 根据提供的路径和主机生成一个Sw8 TraceId。
 *
 * @param requestPath 请求路径
 * @param requestHost 请求主机
 *
 * @return 返回生成的SW8 TraceId字符串
 */
- (NSString *)generateSw8TraceId :(NSString *)requestPath requestHost:(NSString *) requestHost;

/**
 * @brief 生生成traceparent协议的traceId， 用于全链路上报。 生成traceId后， 需要手动将traceId设置到真实请求的header中
 *
 * 生成一个用于Sw8追踪的唯一标识符（Trace ID）。
 *
 * @return 返回生成的Sw8追踪ID，类型为NSString
 */
-(NSString*)generateTraceparentTraceId;

/**
 * @brief 设置服务端IP地址
 *
 * 设置服务端IP地址。
 *
 * @param ip 要设置的IP地址字符串
 */
-(void)setIP:(NSString*)ip;

/**
 * @brief 设置协议
 *
 * 设置当前使用的协议。
 *
 * @param protocol 协议字符串
 */
- (void)setProtocol:(NSString*)protocol;

/**
 * @brief 设置请求方法
 *
 * 设置HTTP请求的方法，例如GET、POST等。
 *
 * @param method 请求方法，例如@"GET"或@"POST"
 */
-(void)setMethod:(NSString*)method;

/**
 * @brief 设置DNS解析开始的时间戳
 *
 * 设置DNS解析开始的时间戳，用于后续计算DNS解析时间。
 *
 * @param timestamp uint64_t类型，表示DNS解析开始的时间戳
 */
-(void)setDnsStart:(uint64_t)timestamp;

/**
 * @brief 设置DNS解析结束的时间戳
 *
 * 设置DNS解析结束的时间戳，用于记录DNS解析完成的时间。
 *
 * @param timestamp 时间戳，表示DNS解析结束的时间
 */
-(void)setDnsEnd:(uint64_t)timestamp;

/**
 * @brief 设置TCP启动时间戳
 *
 * 设置TCP启动的时间戳，以便进行后续的时间相关计算或操作。
 *
 * @param timestamp TCP启动的时间戳，以微秒为单位
 */
-(void)setTCPStart:(uint64_t)timestamp;

/**
 * @brief 设置TCP连接结束的时间戳
 *
 * 设置TCP连接结束的时间戳。
 *
 * @param timestamp 结束的时间戳
 */
-(void)setTCPEnd:(uint64_t)timestamp;

/**
 * @brief 设置HTTP请求头
 *
 * 设置HTTP请求的请求头信息。
 *
 * @param header 请求头信息，使用NSDictionary表示，其中键为请求头字段名，值为请求头字段值。
 */
-(void)setRequestHeader:(NSDictionary*)header;

/**
 * @brief 设置响应头
 *
 * 设置HTTP响应头信息。
 *
 * @param header 响应头信息，以NSDictionary形式传递，键为HTTP头名称，值为对应的值。
 */
-(void)setResponseHeader:(NSDictionary*)header;

/**
 * @brief 设置响应状态码值
 *
 * 设置响应状态码值。
 *
 * @param code 需要设置的响应状态码值
 */
-(void)setCode:(NSInteger)code;

/**
 * @brief 设置请求详细信息
 *
 * 设置请求的详细信息，例如请求头、请求参数等。
 *
 * @param info 请求的详细信息，使用NSDictionary类型存储
 */
-(void)setRequestDetailInfo:(NSDictionary*)info;

/**
 * @brief 设置请求体的大小
 *
 * 设置请求体的最大字节数。
 *
 * @param size 请求体的最大字节数
 */
-(void)setRequestBodySize:(NSInteger)size;

/**
 * @brief 设置响应体的大小
 *
 * 设置响应体的大小。
 *
 * @param size 响应体的大小，以字节为单位
 */
-(void)setResponseBodySize:(NSInteger)size;

/**
 * @brief 结束当前操作或任务 ，请求正常完成时调用， 完成请求， 调用该函数后，会结束该请求并进行上报， 在finish之后设置的请求信息不会再被记录
 *
 * 该函数用于结束当前正在进行的操作或任务。具体行为可能依赖于上下文或类的实现。
 */
-(void)finish;

/**
 * @brief 完成操作并处理错误，请求发生错误时调用， 完成请求， 调用该函数后，会结束该请求并进行上报， 在finish之后设置的请求信息不会再被记录
 *
 * 此方法用于在完成某项操作后，如果有错误发生，则通过参数error传递错误信息。
 *
 * @param error 错误信息，如果操作成功，则为nil
 */
-(void)finishWithError:(NSError*)error;

/**
 * @brief 设置自定义字段，目前函数只供grpc的协议调用，且对应的key的值的范围只能是int型为uv1~uv10,字符串型为ud1~ud5
 *
 * 设置一个字典类型的自定义字段，该字段可以被用来存储一些额外的信息或配置。
 *
 * @param field 一个包含自定义字段的字典，字典中的键和值可以为任意类型。
 */
- (void)setCustomField:(NSDictionary *)field;


@end
