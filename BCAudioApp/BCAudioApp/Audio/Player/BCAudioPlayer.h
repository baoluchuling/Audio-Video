//
//  BCAudioPlayer.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCAudioPlayer : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval duration;

@property (nonatomic, assign) CGFloat volume;

+ (instancetype)shareInstance;
+ (void)setAudioSession;

- (void)playWithFile:(NSString *)fileName;
- (void)play;
- (void)pause;
- (void)changePlayStatus;

@end
