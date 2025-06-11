//
//  QAPMGrpcProfile.h
//  QAPM
//
//  Created by wxyawang on 2025/5/7.
//  Copyright © 2025 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMGrpcProfile : NSObject

/**
 单例使用
 */
+ (instancetype)getInstance;

/**
 * @brief 判断grpc网络是否启用,内部已经判断，直接调用
 *
 * @return 如果grpc网络已启用，则返回YES；否则返回NO。
 */
- (BOOL)enable;

@end

NS_ASSUME_NONNULL_END
