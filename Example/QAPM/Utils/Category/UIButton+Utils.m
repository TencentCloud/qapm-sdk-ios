//
//  UIButton+Utils.m
//  ApmDemo
//
//  Created by Cass on 2019/4/18.
//  Copyright © 2019 testcgd. All rights reserved.
//

#import "UIButton+Utils.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation UIButton (Utils)

+ (UIButton *)genBigGreenButtonWithFrame:(CGRect)btnFrame
{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [btn setBackgroundColor:UIColorFromRGB(0x07C160)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    return btn;
}

+ (UIButton *)genBigRedButtonWithFrame:(CGRect)btnFrame
{
    UIButton *btn = [[UIButton alloc] initWithFrame:btnFrame];
    [btn setBackgroundColor:UIColorFromRGB(0xE64340)];
    [btn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    btn.layer.cornerRadius = 4;
    btn.clipsToBounds = YES;
    return btn;
}

@end
