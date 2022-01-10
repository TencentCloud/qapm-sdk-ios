//
//  QAPMUBSMonitor.h
//  QAPM
//
//  Created by Cass on 2019/10/10.
//  Copyright © 2019 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAPMUBSMonitor : NSObject

+ (instancetype)manager;

/**
 额外传入信息
 */
@property (nonatomic, strong) NSDictionary<NSString *, NSString *> *map;

/**
 自定义传入业务APP的打开渠道,不设置则默认情况下为App Store
 */
@property (nonatomic, copy) NSString *channel_open;

/**
 自定义传入业务APP的安装渠道，不设置则通过sandboxReceipt进行区分
 */
@property (nonatomic, copy) NSString *channel_install;


/**
 内部调用，是否完成初始化的唯一标识
 */
@property (nonatomic, strong) NSString *identifier;


/**
 SDK内部调用
 */

- (void)start;
/**
 用户自定义用户行为操作调用,外部用户接口，调用该接口时请完成QAPM的一系列初始化操作，设置完QAPM的appKey后调用。
 @param category  类别
 @param label     事件标签
 @param action    操作
 @param value     数据值
 @param tags      字符串的map标记
 @param values    数值的map标记
 @return 用户行为event uuid
*/
- (NSString *)generateUserEvent:(NSString *)category
                    label:(NSString *)label
                   action:(NSString *)action
                    value:(NSNumber *)value
                     tags:(NSDictionary<NSString *, NSString *> *)tags
                   values:(NSDictionary<NSString *, NSNumber *> *)values;


/**
 添加分桶实验(例如A/B test)，可添加多个，多次调用即可.
*/
- (void)addBucket:(NSString *)bucket;


/**
 移除单个bucket.
*/
- (void)removeBucket:(NSString *)bucket;

/**
 移除所有bucket.
*/
- (void)removeAllBuckets;

@end

NS_ASSUME_NONNULL_END

