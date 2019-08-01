//
//  BCImageLoader.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/8/1.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCImageLoader.h"
#import "NSString+Security.h"
#import "BCImageCache.h"

static BCImageLoader *loader = nil;

@interface BCImageLoader ()

@property (nonatomic, strong) NSOperationQueue *loaderQueue;

@end

@implementation BCImageLoader

#pragma mark class method

+ (instancetype)defaultLoader
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[BCImageLoader alloc] init];
    });
    
    return loader;
}

+ (UIImage *)bc_loadImageWithURL:(NSString *)url
{
    // 获取url的md5
    NSString *md5Key = url.md5;
    
    // 获取图片缓存
    NSData *imageData = [[BCImageCache defaultCache] objectForKey:md5Key];
    
    // 未找到缓存，重新下载
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        // 存入缓存
        [[BCImageCache defaultCache] setObject:imageData forKey:md5Key];
    }
    
    return [UIImage imageWithData:imageData];
}

#pragma mark instance method
- (void)bc_loadImageWithURL:(NSString *)url
                placeholder:(NSString *)placeholder
                     corner:(CGFloat)corner
                     bounds:(CGRect)bounds
                loadHandler:(void(^)(UIImage *))loadHandler
{
    if (!loadHandler) {
        return;
    }
    
    [self.loaderQueue addOperationWithBlock:^{
        // placeholder
        if (placeholder && placeholder.length > 0) {
            UIImage *tempImage = [UIImage imageNamed:placeholder];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                loadHandler(tempImage);
            });
        }
        
        UIImage *image = [BCImageLoader bc_loadImageWithURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadHandler(image);
        });
    }];
}

- (void)bc_loadImageWithData:(NSData *)data
                 placeholder:(NSString *)placeholder
                      corner:(CGFloat)corner
                      bounds:(CGRect)bounds
                 loadHandler:(void(^)(UIImage *))loadHandler
{
    if (!loadHandler) {
        return;
    }
    
    [self.loaderQueue addOperationWithBlock:^{
        // placeholder
        if (placeholder && placeholder.length > 0) {
            UIImage *tempImage = [UIImage imageNamed:placeholder];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                loadHandler(tempImage);
            });
        }
        
        UIImage *image = [BCImageLoader bc_cornerImageWithCorner:corner
                                                          bounds:bounds
                                                          source:[UIImage imageWithData:data]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadHandler(image);
        });
    }];
}

#pragma mark utils
+ (UIImage *)bc_cornerImageWithCorner:(CGFloat)corner bounds:(CGRect)bounds source:(UIImage *)source
{
    if (!source || corner == 0) {
        return nil;
    }
        
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(corner, corner)].CGPath);
    CGContextClip(context);
    
    [source drawInRect:bounds];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark setter & getter
- (NSOperationQueue *)loaderQueue
{
    if (!_loaderQueue) {
        _loaderQueue = [[NSOperationQueue alloc] init];
        _loaderQueue.maxConcurrentOperationCount = 1;
    }
    
    return _loaderQueue;
}
@end
