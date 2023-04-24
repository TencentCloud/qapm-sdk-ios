//
//  QAPMBigChunkMemoryProfile.h
//  QAPM
//
//  Created by wxy on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMBigChunkMemoryProfile : NSObject

/**
 单例使用
 */
+ (instancetype)getInstance;

/**
 设置单次超大堆内存监控阈值（bytes)，阀值设置较大时，性能开销几乎影响不计。默认阈值50M。
 */
@property (nonatomic, assign) size_t singleChunkMallocThreadholdInByte __attribute__((deprecated("It is deprecated and distributed by QAPM background configuration instead")));

@end

NS_ASSUME_NONNULL_END
