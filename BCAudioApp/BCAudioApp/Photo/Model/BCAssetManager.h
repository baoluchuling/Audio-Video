//
//  BCAssetManager.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@interface BCAssetManager : NSObject

+ (instancetype)defaultManager;

/*
 * 获取图片集合的Asset
 */
- (void)fetchAllPhotoAssetHandler:(void(^)(NSArray *))handler;

/*
 * 分次返回图片Data
 */
- (void)fetchAllPhotoDataWithAssets:(NSArray *)assets
                     resultHandler:(void(^)(NSData *))resultHandler;


- (UIImage *)originPhotoWithAsset:(PHAsset *)asset;
- (NSData *)originDataWithAsset:(PHAsset *)asset;

- (UIImage *)thumbnailWithAsset:(PHAsset *)asset size:(CGSize)size;
//- (NSData *)thumbnailDataWithAsset:(PHAsset *)asset size:(CGSize)size;

@end
