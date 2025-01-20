//
//  QAPMCrossApi.h
//  QAPM
//
//  Created by winter on 2024/12/17.
//  Copyright © 2024 Tencent. All rights reserved.
//
// 跨端回调

#import <Foundation/Foundation.h>
#import "QAPMCrossInfo.h"
#import "QAPMCrossExceptionMeta.h"

typedef void (^QAPMCrossSdkLaunchCallback)(BOOL success,unsigned long long switchValue, NSString *msg);



@interface QAPMCrossApi: NSObject

+(void)initNativeSDKWithAppKey:(NSString*)appKey
                      platform:(QAPMCrossPlatform)platform
                     crossInfo:(QAPMCrossInfo*)crossInfo
                      callback:(QAPMCrossSdkLaunchCallback)callback;


+(void)crashReport:(QAPMCrossExceptionMeta*)exceptionMeta;

+(void)onPageStart:(QAPMCrossPlatform)platform
         lastPage:(NSString*)lastPage
          curPage:(NSString*)curPage
lastPageStartTime:(NSString*)lastPageStartTime
  lastPageEndTime:(NSString*)lastPageEndTime
 curPageStartTime:(NSString*)curPageStartTime;
        

+(void)onSceneChange:(NSString*)scene;

+(void)notifyNativeCrashed:(NSString*)uuid;

+(NSString*)getRnLinkId;

@end
