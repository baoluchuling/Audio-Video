//
//  BCImageLoader.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/8/1.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCImageOptions;

@interface BCImageLoader : NSObject

+ (instancetype)defaultLoader;

+ (UIImage *)bc_loadImageWithURL:(NSString *)url;

/*
 * 实例方法。使用多线程优化性能
 */
- (void)bc_loadImageWithURL:(NSString *)url
                    options:(BCImageOptions *)options
                loadHandler:(void(^)(UIImage *))loadHandler;

- (void)bc_loadImageWithData:(NSData *)data
                     options:(BCImageOptions *)options
                 loadHandler:(void(^)(UIImage *))loadHandler;

@end
