//
//  BCDiskCache.h
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCDiskCache : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (NSData*)objectForKey:(NSString *)key;
- (void)setObject:(NSData *)object forKey:(NSString *)key;
- (void)appendObject:(NSData *)object forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;
- (void)removeAllObjects;

- (size_t)sizeOfFileWithKey:(NSString *)key;

@end
