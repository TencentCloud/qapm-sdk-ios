//
//  main.m
//  QAPM
//
//  Created by wxyawang on 01/10/2022.
//  Copyright (c) 2022 wxyawang. All rights reserved.
//

@import UIKit;
#import "QAPMAppDelegate.h"
#import <QAPM/QAPM.h>
int main(int argc, char * argv[])
{
    @autoreleasepool {
#ifdef DEBUG
        [QAPMConfig getInstance].sigkillConfig.mallocSampleFactor = 1;
        [QAPMConfig getInstance].launchConfig.debugEnable = YES;
        [QAPMConfig getInstance].launchConfig.launchSampleFactor = 1;
        [QAPMConfig getInstance].launchConfig.launchthreshold = 100;
#endif
        [QAPMLaunchProfile setupLaunchMonitor];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([QAPMAppDelegate class]));
    }
}
