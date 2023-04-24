//
//  QAPMYellowProfile.h
//  QAPM
//
//  Created by v_wxyawang on 2022/10/8.
//  Copyright © 2022 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QAPMYellowProfileDelegate <NSObject>

/**
 VC发生泄漏时的回调接口

 @param vc VC类名
 @param seq VC操作序列
 @param stack 内存方法的堆栈信息
 */
- (void)handleVCLeak:(UIViewController *)vc oprSeq:(NSString *)seq stackInfo:(NSString *)stack __attribute__((deprecated("This method is deprecated")));;

/**
 VC发生泄漏时的回调接口

 @param vc VC类名
 @param seq VC操作序列
 @param stack 内存方法的堆栈信息
 */
- (void)handleViewControllerLeak:(UIViewController *)vc oprSeq:(NSArray *)seq stackInfo:(NSString *)stack;

/**
 UIView发生泄漏时的回调接口
 
 @param view   类名
 @param detail   UIView详细信息
 @param hierarchy 发生泄漏的UIView的层级信息
 @param stack 内存方法的堆栈信息
 */

- (void)handleUIViewLeak:(UIView *)view detail:(NSString *)detail hierarchyInfo:(NSString *)hierarchy stackInfo:(NSString *)stack;

@end

@interface QAPMYellowProfile : NSObject

/**
 单例使用
 */
+ (instancetype)getInstance;

/**
设置检测VC泄露阈值(单位：s)
 */
@property (nonatomic, assign) NSTimeInterval leakInterval __attribute__((deprecated("It is deprecated and distributed by QAPM background configuration instead")));

/**
 设置开启UIView泄漏监控，将记录UIView泄漏对象。
 默认关闭功能。
 */
@property (nonatomic, assign) BOOL UIViewLeakEnable;

/**
 设置VC白名单类(对于需要在VC退出后驻留内存的VC)

 @param set 白名单VC，set中的对象为NSString对象，是白名单VC类名，如果没有白名单则不设置
 @param array 白名单基类VC，array中的对象为NSString对象，是白名单VC基类名，这些基类对象的所有子类都添加白名单
 */
+ (void)setWhiteVCList:(NSSet *)set baseVCArray:(NSArray *)array;

/**
 针对白名单VC，可自定义检测时机，非白名单VC无需实现
 注意：该方法在VC退出后调用，注意不要在dealloc方法中调用改方法，因为VC内存泄漏时无法执行dealloc

 @param VC 白名单VC
 */
+ (void)startVCLeakObservation:(UIViewController *)VC;

/**
 设置该对象为白名单对象，无需监控

 @param obj 白名单对象
 */
+ (void)markedAsWhiteObj:(NSObject *)obj;

/**
 设置QAPMYellowProfileDelegate

 @param delegate delegate
 */
+ (void)setYellowProfileDelegate:(id<QAPMYellowProfileDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
