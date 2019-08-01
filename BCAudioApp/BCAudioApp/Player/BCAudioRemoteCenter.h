//
//  BCAudioRemoteCenter.h
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/7/26.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCAudioRemoteCenter : NSObject

+ (instancetype)defaultCenter;

- (void)setAudioRemotePlayingInfo:(NSDictionary *)info;

@end
