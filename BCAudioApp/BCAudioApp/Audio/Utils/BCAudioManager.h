//
//  BCAudioManager.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/19.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCAudioManager : NSObject

+ (NSArray *)fetchSandboxAudioInfoWithDirector:(NSString *)director;
+ (NSArray *)fetchBundleAudioInfoWithType:(NSString *)type;

@end
