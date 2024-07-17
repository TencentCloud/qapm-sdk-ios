//
//  QAPMCustomLagUploadCenter.h
//  QAPM
//
//  Created by v_wxyawang on 2020/03/16.
//  Copyright © 2020年 com.tencent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAPMCustomLagUploadCenter : NSObject

+ (instancetype)manager;

/**
 SDK内部调用,通过后台配置下发开启。
 */

- (void)start;

- (void)stop;

/**
 @param stage 自定义场景名，默认场景为当前VC类名。
 @param customStack 需要上报的堆栈信息
 @return 返回值为0表示上报失败，返回1表示成功。
 */
- (int)customLooperMeta:(NSString *)stage customStack:(NSArray *)customStack DEPRECATED_MSG_ATTRIBUTE("It is recommended to replace the call with the customLooper method");

/**
 @param stage 自定义场景名，默认场景为当前VC类名。
 @param duration   抓堆栈耗时时间，非必须参数。
 @param cpuUsage   当前cpu占比。
 @param mallocSize   当前malloc大小。
 @param mallocCount 当前malloc个数
 @param customStack   一个customStack为一个堆栈信息，格式如下
                        @[@"1 libsystem_c.dylib 0x18bf5c000 0x18bf69b30",
                         @"2 libsystem_c.dylib 0x18bf5c000 0x18bf69af0",
                         @"3 libsystem_c.dylib 0x18bf5c000 0x18bf6eb90",
                         @"4 libsystem_c.dylib 0x18bf5c000 0x18bf6c5f0",
                         @"5 QAPMDemo 0x104558000 0x1045c9ba0",
                         @"6 QAPMDemo 0x104558000 0x104607960",
                         @"7 QAPMDemo 0x104558000 0x10457d0b0",
                         @"8 QAPMDemo 0x104558000 0x10466ee90",
                         @"9 libsystem_malloc.dylib 0x1929e1000 0x1929e5f30",
                         @"10 CoreGraphics 0x1835ae000 0x1835b0f20",
                         @"11 CoreGraphics 0x1835ae000 0x183652d30",
                         @"12 CoreGraphics 0x1835ae000 0x183629cd0",
                         @"13 CoreGraphics 0x1835ae000 0x1835bf2f0",
                         @"14 CoreGraphics 0x1835ae000 0x1835e2be0"]。
 @param customField      业务需要添加的自定义上报的字段信息，比如当前CPU信息等。
 @return 返回值为0表示上报失败，返回1表示成功。
 */

- (int)customLooper:(NSString *)stage
           duration:(NSNumber *)duration
          cpuUsage :(NSNumber *)cpuUsage
        mallocSize :(NSNumber *)mallocSize
        mallocCount:(NSNumber *)mallocCount
        customStack:(NSArray*)customStack
        customField:(NSDictionary *)customField;

@end
