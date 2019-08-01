//
//  BCImageCache.h
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BCImageCacheType) {
    BCImageCacheTypeNone = 1,
    BCImageCacheTypeMemory,
    BCImageCacheTypeDisk,
};

@interface BCImageCache : NSObject

+ (instancetype)defaultCache;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

- (void)clearAllCaches;

@end
