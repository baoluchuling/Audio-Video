//
//  BCFPSMonitor.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/11.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCFPSMonitor.h"
#import <QuartzCore/QuartzCore.h>

static BCFPSMonitor *fpsMonitor = nil;

@interface BCFPSMonitor ()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval lastTimestamp;
@property (nonatomic, assign) NSInteger displayCount;

@end

@implementation BCFPSMonitor

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fpsMonitor = [[BCFPSMonitor alloc] init];
    });
    
    return fpsMonitor;
}

- (void)start {
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stop {
    [self.displayLink setPaused:YES];
}

- (void)refreshDisplayLink:(CADisplayLink *)displayLink
{
    // 记录上次开始时间，为0就重新记录
    if (self.lastTimestamp <= 0) {
        self.lastTimestamp = displayLink.timestamp;
    }

    // 记录次数
    self.displayCount += 1;
    
    // 计算间隔时间，大于等于1秒的话就计算帧率
    CFTimeInterval interval = displayLink.timestamp - self.lastTimestamp;
    if (interval >= 1) {
        // 求每秒内次数
        double fps = self.displayCount / interval;
        NSLog(@"%f", fps);
        
        // 重置
        self.displayCount = 0;
        self.lastTimestamp = displayLink.timestamp;
    }
}

- (CADisplayLink *)displayLink
{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(refreshDisplayLink:)];
        _displayLink.preferredFramesPerSecond = 60;
    }
    
    return _displayLink;
}

- (void)dealloc
{
    [self.displayLink setPaused:YES];
    [self.displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

@end
