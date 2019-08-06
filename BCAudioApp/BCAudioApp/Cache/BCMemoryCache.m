//
//  BCMemoryCache.m
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCMemoryCache.h"

#import <pthread.h>

//static pthread_mutex_t

@interface BCMemoryCache ()

@property (nonatomic, strong) dispatch_queue_t queue;

// 待修改
@property (nonatomic, strong) NSCache *cacheTable;

@end

@implementation BCMemoryCache

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memoryWarningProcessing) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

- (void)memoryWarningProcessing
{
    [self removeAllObjects];
}

- (__kindof NSObject*)objectForKey:(NSString *)key
{
    __block NSObject *obj = nil;
    
    dispatch_sync(self.queue, ^{
        obj = [self.cacheTable objectForKey:key];
    });
    return obj;
}

- (void)setObject:(__kindof NSObject *)object forKey:(NSString *)key
{
    if (object == nil) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_barrier_async(self.queue, ^{
        
        __strong typeof(weakSelf) self = weakSelf;
        
        [self.cacheTable setObject:object forKey:key];
    });
}

- (void)removeAllObjects
{
    dispatch_barrier_sync(self.queue, ^{
        [self.cacheTable removeAllObjects];
    });
}

#pragma mark setter & getter
- (dispatch_queue_t)queue
{
    if (!_queue) {
        _queue = dispatch_queue_create("com.boluchuling.cache.memory", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return _queue;
}

- (NSCache *)cacheTable
{
    if (!_cacheTable) {
        _cacheTable = [[NSCache alloc] init];
    }
    
    return _cacheTable;
}

@end
