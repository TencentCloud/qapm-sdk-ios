//
//  QAPMResourceMonitorProfile.h
//  QAPM
//
//  Created by v_wxyawang on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMResourceProfile : NSObject

/**
 设置资源使用监控起始标记

 @param tag tag名称
 */
+ (void)setBeginTag:(NSString * __nonnull)tag;

/**
 设置资源使用监控结束标记

 @param tag tag名称
 */
+ (void)setStopTag:(NSString * __nonnull)tag;

@end

NS_ASSUME_NONNULL_END
