//
//  BCCatonMonitor.m
//  BCCatonMonitor
//
//  Created by boluchuling on 2019/5/25.
//  Copyright © 2019 boluchuling. All rights reserved.
//

/*
 * 总的来说，要检测卡顿，其实就是检测相关代码的执行时间，而界面的卡顿一般就是在source0的响应区域，在runloop中source0主要用来负责界面的绘制，事件的响应
 */
#import "BCCatonMonitor.h"
#import "BCCPUMonitor.h"

static BCCatonMonitor *catonMonitor = nil;

@interface BCCatonMonitor ()

@property (nonatomic, assign) CFRunLoopObserverRef observerRef;
@property (nonatomic, assign) CFRunLoopActivity runloopActivity;

@property (nonatomic, strong) dispatch_queue_t queue_t;
@property (nonatomic, strong) dispatch_semaphore_t semaphore;
@property (nonatomic, assign) dispatch_time_t timeout;

@property (nonatomic, strong) dispatch_source_t timer;
@end

@implementation BCCatonMonitor

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        catonMonitor = [[BCCatonMonitor alloc] init];
    });
    
    return catonMonitor;
}

- (void)startMonitor
{
    // 获取cpu
    if (!self.timer) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, 100 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timer, ^{
            [BCCPUMonitor obtainCPUUsage];
        });
    }
    
//    dispatch_resume(self.timer);
    
    if (self.observerRef) { // 已存在
        return;
    }
    
    self.observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        self.runloopActivity = activity;
        
        dispatch_semaphore_t temp = self.semaphore;
        dispatch_semaphore_signal(temp);
    });
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), self.observerRef, kCFRunLoopDefaultMode);
    
    dispatch_async(self.queue_t, ^{
        while (YES) {
            // 该处执行时
            long semaphoreValue = dispatch_semaphore_wait(self.semaphore, self.timeout); // 默认20ms
            if (semaphoreValue != 0) { // 0 代表在指定时间内信号量变回了0，其他值代表超时了，也就是页面卡顿
                if (!self.observerRef) { // 回调通知是否存在
                    return;
                }
                
                // 如果信号量回来后，runloop状态仍然为kCFRunLoopBeforeSources或kCFRunLoopAfterWaiting，那就表明有卡顿
                // 也就是说，都等了20ms了，你的kCFRunLoopBeforeSources和kCFRunLoopAfterWaiting状态还没过去，那不就表明有卡顿吗？
                // kCFRunLoopBeforeSources 是用户的一些东西, kCFRunLoopAfterWaiting 端口操作
                if (self.runloopActivity == kCFRunLoopBeforeSources || self.runloopActivity == kCFRunLoopAfterWaiting) {// 卡顿
                    
//                    NSLog(@"卡顿：%@", [NSThread callStackSymbols]);
                }
            }
        }
    });
}

- (void)stopMonitor
{
    dispatch_suspend(self.timer);
    
    if (_runloopActivity > 0) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self.observerRef, kCFRunLoopDefaultMode);
    CFRelease(self.observerRef);
    _runloopActivity = -1;
}

#pragma mark getter
- (dispatch_time_t)timeout
{
    if (_timeout > 0) {
        return _timeout;
    } else {
        return dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_MSEC);
    }
}

- (dispatch_queue_t)queue_t
{
    if (!_queue_t) {
        _queue_t = dispatch_queue_create("com.boluchuling.monitor.caton", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return _queue_t;
}

- (dispatch_semaphore_t)semaphore
{
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    
    return _semaphore;
}

@end
