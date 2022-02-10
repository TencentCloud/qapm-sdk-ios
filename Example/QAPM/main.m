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
        [QAPMLaunchProfile setupLaunchMonitor];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([QAPMAppDelegate class]));
    }
}
