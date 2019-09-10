//
//  BCCache.m
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCCache.h"
#import "BCMemoryCache.h"
#import "BCDiskCache.h"

static NSString *const kBCCacheDefaultFolder = @"com.boluchuling.cache.default";

@interface BCCache ()

@property (nonatomic, strong) BCMemoryCache *memoryCache;
@property (nonatomic, strong) BCDiskCache *diskCache;

@end

@implementation BCCache

+ (void)load
{
    NSLog(@"GZW: load----BCCache");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheFolder = kBCCacheDefaultFolder;
        
        self.memoryCache = [[BCMemoryCache alloc] init];
    }
    
    return self;
}

- (BCDiskCache *)diskCache
{
    if (!_diskCache) {
        NSString *fileFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        _diskCache = [[BCDiskCache alloc] initWithPath:[fileFolder stringByAppendingPathComponent:self.cacheFolder]];
    }
    
    return _diskCache;
}

- (id)objectForKey:(NSString *)key
{
    id cacheData = nil;
    
    cacheData = [self.memoryCache objectForKey:key];
    
    if (!cacheData) {
        cacheData = [self.diskCache objectForKey:key];
        
        // 保存到内存缓存中
        if (cacheData) {
            [self.memoryCache setObject:cacheData forKey:key];
        }
    } else // 防止缓存被删后无法正常显示缓存数据
        if ([self.diskCache sizeOfFileWithKey:key] != ((NSData *)cacheData).length) {
        [self.diskCache setObject:cacheData forKey:key];
    }
    
    return cacheData;
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [self.memoryCache setObject:object forKey:key];
    
    [self.diskCache setObject:object forKey:key];
}

- (void)appendObject:(id)object forKey:(NSString *)key
{
    [self.memoryCache appendObject:object forKey:key];
    
    [self.diskCache appendObject:object forKey:key];
}

- (void)clearCacheForKey:(NSString *)key
{
    [self.memoryCache removeObjectForKey:key];
    [self.diskCache removeObjectForKey:key];
}

- (void)clearAllCaches
{
    [self.memoryCache removeAllObjects];
}

@end
