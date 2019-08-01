//
//  BCFPSMonitor.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/11.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BCFPSMonitor : NSObject

+ (instancetype)shareInstance;

- (void)start;

@end

NS_ASSUME_NONNULL_END
