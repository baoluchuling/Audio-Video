//
//  BCImageLoader.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/8/1.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCImageLoader.h"
#import "BCImageCache.h"
#import "BCImageOptions.h"

#import "NSString+Security.h"
#import "NSData+Security.h"

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
    if (url == nil || [url isEqualToString:@""]) {
        return nil;
    }
    
    // 获取url的md5
    NSString *md5Key = url.md5;
    
    // 获取图片缓存
    UIImage *image = [[BCImageCache defaultCache] objectForKey:md5Key];
    
    // 未找到缓存，重新下载
    if (!image) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        
        image = [UIImage imageWithData:imageData];
        
        // 存入缓存
        [[BCImageCache defaultCache] setObject:image forKey:md5Key];
    }
    
    // 个性化处理图片
    
    return image;
}

+ (UIImage *)bc_loadImageWithData:(NSData *)imageData
{
    if (imageData == nil) {
        return nil;
    }
    
    // 获取data的md5
    NSString *md5Key = imageData.md5;
    
    // 获取图片缓存
    UIImage *image = [[BCImageCache defaultCache] objectForKey:md5Key];
    
    // 未找到缓存，重新下载
    if (!image) {
        image = [UIImage imageWithData:imageData];
        
        // 存入缓存
        [[BCImageCache defaultCache] setObject:image forKey:md5Key];
    }
    
    // 个性化处理图片
    
    return image;
}

#pragma mark instance method
- (void)bc_loadImageWithURL:(NSString *)url
                     options:(BCImageOptions *)options
                loadHandler:(void(^)(UIImage *))loadHandler;
{
    if (!loadHandler) {
        return;
    }
    
    [self.loaderQueue addOperationWithBlock:^{
        // placeholder
        if (options && options.placeholder && options.placeholder.length > 0) {
            UIImage *tempImage = [UIImage imageNamed:options.placeholder];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                loadHandler(tempImage);
            });
        }
        
        UIImage *image = [BCImageLoader bc_processImage:[BCImageLoader bc_loadImageWithURL:url]
                                            withOptions:options];;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadHandler(image);
        });
    }];
}

- (void)bc_loadImageWithData:(NSData *)data
                    options:(BCImageOptions *)options
                 loadHandler:(void(^)(UIImage *))loadHandler
{
    if (!loadHandler) {
        return;
    }
    
    [self.loaderQueue addOperationWithBlock:^{
        // placeholder
        if (options && options.placeholder && options.placeholder.length > 0) {
            UIImage *tempImage = [UIImage imageNamed:options.placeholder];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                loadHandler(tempImage);
            });
        }
        
        UIImage *image = [BCImageLoader bc_processImage:[BCImageLoader bc_loadImageWithData:data]
                                            withOptions:options];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            loadHandler(image);
        });
    }];
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

#pragma mark utils
+ (UIImage *)bc_processImage:(UIImage *)source withOptions:(BCImageOptions *)options
{
    if (!source || ![source isKindOfClass:[UIImage class]]) {
        return nil;
    }
    
    if (!options || (!options.backgroundColor && !options.cornerRadius)) {
        return source;
    }
    
    BOOL needBackColor = !!(options.backgroundColor);
    
    // 有背景的话，设置不透明。无背景的话，按透明处理
    UIGraphicsBeginImageContextWithOptions(options.outputSize, needBackColor, 0.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 判断上下文是否存在
    if (!context) {
        return source;
    }
    
    CGRect bounds = CGRectMake(0, 0, options.outputSize.width, options.outputSize.height);

    // 设置背景
    if (needBackColor) {
        CGContextAddRect(context, bounds);
        CGContextSetFillColorWithColor(context, options.backgroundColor.CGColor);
        CGContextFillPath(context);
    }
    
    // 配置圆角值
    if (options.cornerRadius) {
        
        CGPathRef cornerPath = [self cornerRadiusPathWithSize:options.outputSize
                                                 cornerRadius:options.cornerRadius];
        
        CGContextAddPath(context, cornerPath);
        
        CGContextClip(context);
    }
        
    [source drawInRect:bounds];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CGPathRef)cornerRadiusPathWithSize:(CGSize)size cornerRadius:(NSArray<NSNumber *> *)cornerRadius
{
    // 设置圆角
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, h / 2)];
    //  上左
    CGFloat cr0 = cornerRadius[0].floatValue / 2;
    [path addLineToPoint:CGPointMake(0, 0 + cr0)];
    [path addQuadCurveToPoint:CGPointMake(0 + cr0, 0) controlPoint:CGPointMake(0, 0)];
    //  上右
    CGFloat cr1 = cornerRadius[1].floatValue / 2;
    [path addLineToPoint:CGPointMake(w - cr1, 0)];
    [path addQuadCurveToPoint:CGPointMake(w, 0 + cr1) controlPoint:CGPointMake(w, 0)];
    //  下右
    CGFloat cr2 = cornerRadius[2].floatValue / 2;
    [path addLineToPoint:CGPointMake(w, h - cr2)];
    [path addQuadCurveToPoint:CGPointMake(w - cr2, h) controlPoint:CGPointMake(w, h)];
    //  下左
    CGFloat cr3 = cornerRadius[3].floatValue / 2;
    [path addLineToPoint:CGPointMake(0 + cr3, h)];
    [path addQuadCurveToPoint:CGPointMake(0, h - cr3) controlPoint:CGPointMake(0, h)];
    
    [path addLineToPoint:CGPointMake(0, h / 2)];
    
    return path.CGPath;
}

@end
