//
//  QAPMCrashMonitorProfile.h
//  QAPM
//
//  Created by v_wxyawang on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMCrashProfile : NSObject

/**
 Crash监控是否在运行

 @return YES or NO
 */
+ (BOOL)isRunnning;

@end

NS_ASSUME_NONNULL_END
