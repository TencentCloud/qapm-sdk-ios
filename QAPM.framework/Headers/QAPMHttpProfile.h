//
//  QAPMHttpProfile.h
//  QAPM
//
//  Created by wxy on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMHttpProfile : NSObject

/**
 单例使用
 */
+ (instancetype)getInstance;

/**
 是否允许移动网络进行上报，默认移动网络允许上报。
 */
@property (nonatomic,assign) BOOL allowsCellularAccess __attribute__((deprecated("It is deprecated and distributed by QAPM background configuration instead")));

/**
 @param traceRoute  需要解析url的地址，例如解析的地址是https://www.baidu.com，写www.baidu.com即可
 @param maxTtl   目标的跳转的最大数目
 注意：traceRoute功能的开启不受QAPM后台的配置下发控制
 */
- (void)traceRoute:(NSString *)traceRoute maxTtl:(NSInteger)maxTtl;

@end

NS_ASSUME_NONNULL_END
