//
//  NSObject+QAPMPerformSelector.h
//  ApmDemo
//
//  Created by Cass on 2019/7/8.
//  Copyright © 2019 testcgd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (QAPMPerformSelector)

- (id)qapm_performSelector:(SEL)aSelector withObjects:(NSArray *)objects;

@end

NS_ASSUME_NONNULL_END
