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

- (__kindof NSObject*)objectForKey:(NSString *)key;
- (void)setObject:(__kindof NSObject *)object forKey:(NSString *)key;

@end
