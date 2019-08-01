//
//  BCAsset.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset;
@interface BCAsset : NSObject

@property (nonatomic, strong) PHAsset *asset;

@property (readonly) UIImage *originImage;  // 原图
@property (readonly) NSData *originData;    // 原图二进制数据

@property (readonly) UIImage *thumbnail;    // 缩略图
//@property (readonly) NSData *thumbnailData; // 缩略图二进制数据
@property (nonatomic, assign) CGSize thumbnailSize; // 缩略图宽高

- (instancetype)initWithAsset:(PHAsset *)asset;

@end
