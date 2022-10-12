//
//  main.m
//  QAPM
//
//  Created by wxyawang on 01/10/2022.
//  Copyright (c) 2022 wxyawang. All rights reserved.
//

@import UIKit;
#import "QAPMAppDelegate.h"
#import <QAPM/QAPMLaunchProfile.h>
int main(int argc, char * argv[])
{
    @autoreleasepool {
        [QAPMLaunchProfile didEnterMain];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([QAPMAppDelegate class]));
    }
}
