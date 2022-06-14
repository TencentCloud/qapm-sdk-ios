//
//  QAPMAppDelegate.m
//  QAPM
//
//  Created by wxyawang on 01/10/2022.
//  Copyright (c) 2022 wxyawang. All rights reserved.
//

#import "QAPMAppDelegate.h"
#import <QAPM/QAPM.h>
#import "APMMainListViewController.h"
@implementation QAPMAppDelegate

#if defined(DEBUG) || defined(RDM)

#define USE_VM_LOGGER

#ifdef USE_VM_LOGGER

/// 私有API请不要在发布APPSotre时使用。
typedef void (malloc_logger_t)(uint32_t type, uintptr_t arg1, uintptr_t arg2, uintptr_t arg3, uintptr_t result, uint32_t num_hot_frames_to_skip);
extern malloc_logger_t* __syscall_logger;

#endif

#endif


void loggerFunc(QAPMLoggerLevel level, const char* log) {

#ifdef RELEASE
    if (level <= QAPMLogLevel_Event) { ///外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif

#ifdef GRAY
    if (level <= QAPMLogLevel_Info) { ///灰度和外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif

#ifdef DEBUG
    if (level <= QAPMLogLevel_Debug) { ///内部版本、灰度和外发版本log
        NSLog(@"%@", [NSString stringWithUTF8String:log]);
    }
#endif
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //请在同意相应的隐私合规政策后进行QAPM的初始化
    [self setupQapm];
    [self setupFlex];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    APMMainListViewController *viewController = [[APMMainListViewController alloc] init];
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = naviController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupQapm {
    //启动耗时监控的第一个打点
  //  [QAPMLaunchProfile setAppDidFinishLaunchBeginTimestamp];
    
    //启动耗时自定义打点开始,业务自行打点
    [QAPMLaunchProfile setBeginTimestampForScene:@"finish"];
    
    [QAPM registerLogCallback:loggerFunc];
#ifdef DEBUG
    //设置开启QAPM所有监控功能
    [[QAPMModelStableConfig getInstance] setupModelAll:1];
    //开启全量堆内存抽样
    [QAPMConfig getInstance].sigkillConfig.mallocSampleFactor = 1;
#else
    [[QAPMModelStableConfig getInstance] setupModelAll:2];
#endif
    //用于查看当前SDK版本号信息
    NSLog(@"qapm sdk version : %@", [QAPM sdkVersion]);
        
    //自动上传符号表步骤，请根据接入文档进行相关信息的配置
    [QAPMConfig getInstance].uuidFromDsym = NO;
    NSString *uuid = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"com.tencent.qapm.uuid"];
    if(!uuid){
        uuid = @"请检查run script里面上传符号表的shell路径是否正确";
    }
    
    NSLog(@"uuid::::%@",uuid);
    [QAPMConfig getInstance].dysmUuid = uuid;
    
    
    //手动上传符号表设置，请二选一操作
   // [QAPMConfig getInstance].uuidFromDsym = YES;
    
#ifdef USE_VM_LOGGER
/// ！！！Sigkill功能私有API请不要在发布APPSotre时使用。开启这个功能可以监控到VM内存的分配的堆栈。
[[QAPMConfig getInstance].sigkillConfig setVMLogger:(void**)&__syscall_logger];
#endif

    
    [QAPMConfig getInstance].host = @"https://qapm.qq.com";

    // 设置用户标记
    [QAPMConfig getInstance].userId = @"qapmtest";
    
    // 设置设备唯一标识
    [QAPMConfig getInstance].deviceID = @"qapmdevideId";
    // 设置App版本号
    [QAPMConfig getInstance].customerAppVersion = @"1.0.1";
    [QAPM startWithAppKey:@"55a11d57-4116"];
    
    //启动耗时自定义打点结束，业务自行打点
    [QAPMLaunchProfile setEndTimestampForScene:@"finish"];
}

- (void)setupFlex {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"A_QAPM_HTTPMonitorURLList"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@[@"https://gank.io",@"https://www.baidu.com",@"http://w-63209-28716-59529.479064108.sites.hk36.qifeiye.com/",@"http://www.gdlaser.cn",@"https://cloud.tencent.com/product/qapm"] forKey:@"A_QAPM_HTTPMonitorURLList"];
    }
        
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    sleep(3);
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
