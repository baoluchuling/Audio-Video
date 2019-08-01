//
//  BCAssetManager.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCAssetManager.h"
#import "BCAsset.h"
#import <Photos/Photos.h>

@interface BCAssetManager ()

@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

@property (nonatomic, strong) NSOperationQueue *transQueue;

@end

static BCAssetManager *manager = nil;

@implementation BCAssetManager

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BCAssetManager alloc] init];
    });
    
    return manager;
}

- (void)fetchAllPhotoAssetHandler:(void(^)(NSArray *))handler
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"creationDate" ascending:NO]];
            
            PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithOptions:options];
            
            NSMutableArray *photoArr = [NSMutableArray array];

            [result enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL *stop) {
                
                [photoArr addObject:[[BCAsset alloc] initWithAsset:obj]];
                
            }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                handler([photoArr copy]);
            });
        }
    });
}

/*
 * 开始想要在这里限制block回调执行的并发数量，后来发现，队列无法控制block内部新建队列的执行逻辑（除非添加依赖，但是这样耦合有点大），
 * 所以对内存的优化，还是需要在外界真正处理的时候进行，这里只保证返回的数据不会堆积造成对内存的消耗。
 */
- (void)fetchAllPhotoDataWithAssets:(NSArray *)assets
                      resultHandler:(void(^)(NSData *))resultHandler
{
    if (!resultHandler) {
        return;
    }
        
    [assets enumerateObjectsUsingBlock:^(BCAsset *obj, NSUInteger idx, BOOL *stop) {
        
        [self.transQueue addOperationWithBlock:^{
            @autoreleasepool {
                NSData *data = obj.originData;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    resultHandler(data);
                });
            }
        }];
        
    }];
}

- (UIImage *)originPhotoWithAsset:(PHAsset *)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    __block UIImage *originImage = nil;
    [self.cachingImageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        originImage = result;
    }];
    
    return originImage;
}

- (NSData *)originDataWithAsset:(PHAsset *)asset
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    __block NSData *originData = nil;
    [self.cachingImageManager requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, CGImagePropertyOrientation orientation, NSDictionary *info) {
        originData = imageData;
    }];
    
    return originData;
}

- (UIImage *)thumbnailWithAsset:(PHAsset *)asset size:(CGSize)size
{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast; // 小图快

    // 直接获取UIImage的API虽然会造成内存的增大，但是在设置ImageView时不会再重新解码，滑动时不会卡顿，所以在列表中小图情况下使用能获得较好的体验
    // 如果是页面固定静态图片的话，则可以使用返回NSData的方式来减少内存占用
    __block UIImage *image = nil;
    [self.cachingImageManager requestImageForAsset:asset targetSize:CGSizeMake(size.width * [UIScreen mainScreen].scale, size.height * [UIScreen mainScreen].scale) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
        image = result;
    }];
    
    return image;
}

- (PHCachingImageManager *)cachingImageManager
{
    if (!_cachingImageManager) {
        _cachingImageManager = [[PHCachingImageManager alloc] init];
    }
    
    return _cachingImageManager;
}

- (NSOperationQueue *)transQueue
{
    if (!_transQueue) {
        _transQueue = [[NSOperationQueue alloc] init];
        _transQueue.maxConcurrentOperationCount = 3;
    }

    return _transQueue;
}

@end
