//
//  BCAudioPlayer.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

static BCAudioPlayer *playerManager = nil;

@interface BCAudioPlayer ()

@property (nonatomic, strong) dispatch_queue_t playerQueue;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation BCAudioPlayer

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerManager = [[BCAudioPlayer alloc] init];
    });
    
    return playerManager;
}

+ (void)setAudioSession
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
}

- (void)playWithFile:(NSString *)fileName
{
    dispatch_async(self.playerQueue, ^{
        NSError *playError;
        
        NSURL *fileUrl = [NSURL URLWithString:[fileName stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        if (![self.player.url.absoluteString isEqualToString:fileUrl.absoluteString]) {
            self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:&playError];
        }
        
        self.player.volume = self.volume;
        
        [self.player play];
    });
}

- (void)play
{
    [self changePlayStatus];
}

- (void)pause
{
    [self changePlayStatus];
}

- (void)changePlayStatus
{
    if (![self.player isPlaying]) {
        [self.player play];
    } else {
        [self.player pause];
    }
}

- (dispatch_queue_t)playerQueue
{
    if (!_playerQueue) {
        _playerQueue = dispatch_queue_create("com.boluchuling.player", DISPATCH_QUEUE_SERIAL);
    }
    
    return _playerQueue;
}

- (NSTimeInterval)duration
{
    if (!self.player) {
        return 0;
    }
    
    return [self.player duration];
}

- (void)setVolume:(CGFloat)volume
{
    _volume = volume;
    
    if (self.player) {
        self.player.volume = volume;
    }
}

@end
