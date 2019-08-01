//
//  BCDiskCache.m
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCDiskCache.h"

@interface BCDiskCache ()

@property (nonatomic, strong) NSString *basePath;

@property (nonatomic, strong) dispatch_queue_t ioQueue;

@end

@implementation BCDiskCache

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    
    if (self) {
        self.basePath = path;
    }
    
    return self;
}

#pragma mark utils

- (void)createDirectoryWithPath:(NSString *)path {
    dispatch_sync(self.ioQueue, ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if (![fileManager fileExistsAtPath:path]) {
            NSError *error;
            BOOL result = [fileManager createDirectoryAtPath:path
                                 withIntermediateDirectories:YES
                                                  attributes:nil
                                                       error:&error];
            if (!result) {
                NSLog(@"creat Directory Failed:%@",[error localizedDescription]);
            }
        }
    });
}

- (NSString *)filePathWithName:(NSString *)name
{
    return [self.basePath stringByAppendingPathComponent:name];
}

#pragma mark public
- (__kindof NSObject*)objectForKey:(NSString *)key
{
    if (!key) {
        return nil;
    }
    
    NSString *filePath = [self filePathWithName:key];
    
    __block NSData *data = nil;

    dispatch_sync(self.ioQueue, ^{
        BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:filePath];

        if (hasFile) {
            data = [NSData dataWithContentsOfFile:filePath];
        }
    });
    
    return data;
}

- (void)setObject:(__kindof NSObject *)object forKey:(NSString *)key
{
    if (!key) {
        return;
    }
    
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    
    NSString *filePath = [self filePathWithName:key];

    dispatch_barrier_async(self.ioQueue, ^{
        [object writeToFile:filePath atomically:NO];
    });
}

- (void)removeObjectForKey:(NSString *)key
{
    NSString *filePath = [self filePathWithName:key];
    
    dispatch_barrier_async(self.ioQueue, ^{
        BOOL hasFile = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        
        if (hasFile) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        }
    });
}

- (void)removeAllObjects
{
    dispatch_barrier_async(self.ioQueue, ^{
        BOOL hasFolder = [[NSFileManager defaultManager] fileExistsAtPath:self.basePath];
        
        if (hasFolder) {
            [[NSFileManager defaultManager] removeItemAtPath:self.basePath error:nil];
        }
    });
}

#pragma mark getter & setter
- (dispatch_queue_t)ioQueue
{
    if (!_ioQueue) {
        _ioQueue = dispatch_queue_create("com.boluchuling.cache.disk", DISPATCH_QUEUE_SERIAL);
    }
    return _ioQueue;
}

- (void)setBasePath:(NSString *)basePath
{
    if (!basePath || basePath.length <= 0) {
        NSLog(@"cache need current folder。");
        return;
    }
    
    _basePath = basePath;
    
    [self createDirectoryWithPath:_basePath];
}

@end

