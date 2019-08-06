//
//  BCImageCache.m
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCImageCache.h"
#import "BCMemoryCache.h"
#import "BCDiskCache.h"

static NSString *const kBCImageFolderName = @"com.boluchuling.cache.image";

#define BCCacheFolder

@interface BCImageCache ()

@property (nonatomic, strong) BCMemoryCache *memoryCache;
@property (nonatomic, strong) BCDiskCache *diskCache;

@end

static BCImageCache *imageCache = nil;
@implementation BCImageCache

+ (instancetype)defaultCache
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[BCImageCache alloc] init];
    });
    
    return imageCache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.memoryCache = [[BCMemoryCache alloc] init];
        
        NSString *fileFolder = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        self.diskCache = [[BCDiskCache alloc] initWithPath:[fileFolder stringByAppendingPathComponent:kBCImageFolderName]];
    }
    
    return self;
}

- (id)objectForKey:(NSString *)key
{
    id imgData = nil;
    
    imgData = [self.memoryCache objectForKey:key];

    if (!imgData) {
        NSData *originData = [self.diskCache objectForKey:key];

        imgData = [UIImage imageWithData:originData scale:[UIScreen mainScreen].scale];
        // 保存到内存缓存中
        if (imgData) {
            [self.memoryCache setObject:imgData forKey:key];
        }
    }
    
    return imgData;
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    [self.memoryCache setObject:object forKey:key];
    
    NSData *data = UIImagePNGRepresentation(object);
    [self.diskCache setObject:data forKey:key];
}

- (void)clearAllCaches
{
    [self.memoryCache removeAllObjects];
}

@end
