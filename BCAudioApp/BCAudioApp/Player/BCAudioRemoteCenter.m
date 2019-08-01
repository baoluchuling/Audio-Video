//
//  BCAudioRemoteCenter.m
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/7/26.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCAudioRemoteCenter.h"
#import "BCAudioPlayer.h"

#import <MediaPlayer/MediaPlayer.h>

static BCAudioRemoteCenter *center = nil;

@implementation BCAudioRemoteCenter

+ (instancetype)defaultCenter
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[BCAudioRemoteCenter alloc] init];
    });
    return center;
}

- (void)setAudioRemotePlayingInfo:(NSDictionary *)info
{
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:info];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDelegateReceiveRemoteEventsNotification:) name:@"AppDelegateReceiveRemoteEventsNotification" object:nil];
    }
    
    return self;
}

- (void)appDelegateReceiveRemoteEventsNotification:(NSNotification *)notify
{
    UIEvent *event = notify.object;
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay: // 播放
            [[BCAudioPlayer shareInstance] play];
            break;
        case UIEventSubtypeRemoteControlPause:
        case UIEventSubtypeRemoteControlStop: // 暂停
            [[BCAudioPlayer shareInstance] pause];
            break;
        case UIEventSubtypeRemoteControlNextTrack: // 下一首
            
            break;
        case UIEventSubtypeRemoteControlPreviousTrack: // 上一首
            
            break;
        default:
            break;
    }
}

@end
