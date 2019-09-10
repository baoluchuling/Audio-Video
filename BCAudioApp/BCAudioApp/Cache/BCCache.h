//
//  BCCache.h
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BCCache : NSObject

@property (nonatomic, copy) NSString *cacheFolder;

- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

- (void)appendObject:(id)object forKey:(NSString *)key;

- (void)clearCacheForKey:(NSString *)key;
- (void)clearAllCaches;

@end

NS_ASSUME_NONNULL_END
