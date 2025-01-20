//
//  QAPMCrossInfo.h
//  QAPM
//
//  Created by winter on 2024/12/18.
//  Copyright © 2024 Tencent. All rights reserved.
//

typedef NS_ENUM(NSInteger, QAPMCrossPlatform) {
    QAPMCrossPlatformRN,
    QAPMCrossPlatformFlutter,
    QAPMCrossPlatformCocos,
    QAPMCrossPlatformUnity
};


@interface QAPMCrossInfo : NSObject

@property QAPMCrossPlatform platform;

@property NSString* sdkVersion;

@property NSString* crossAppVersion;

@property NSString* crossLibraryVersion;

@end
