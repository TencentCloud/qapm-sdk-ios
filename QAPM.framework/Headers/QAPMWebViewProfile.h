//
//  QAPMWebViewProfile.h
//  QAPM
//
//  Created by v_wxyawang on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMWebViewProfile : NSObject

/**
 @param breadCrumbBuckets  自定义上报webview移动分析部分的分桶
 @return 返回注入的基本信息，包含QAPM的初始化信息
*/
+ (NSString *)qapmBaseInfo:(NSString *) breadCrumbBuckets;

/**
 @return 注入启动js监控的信息，请在resetConfig方法调用完之后调用
*/
+ (NSString *)qapmJsStart;

@end

NS_ASSUME_NONNULL_END
