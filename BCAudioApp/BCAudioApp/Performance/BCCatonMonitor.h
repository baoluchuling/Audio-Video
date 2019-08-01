//
//  BCCatonMonitor.h
//  BCCatonMonitor
//
//  Created by boluchuling on 2019/5/25.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCCatonMonitor : NSObject

+ (instancetype)shareInstance;

- (void)startMonitor;

- (void)stopMonitor;

@end
