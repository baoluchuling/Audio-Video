//
//  BCMemoryCache.h
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCMemoryCache : NSObject

- (id)objectForKey:(NSString *)key;

- (void)setObject:(id)object forKey:(NSString *)key;
- (void)appendObject:(id)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;

@end
