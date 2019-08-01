//
//  BCAsset.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCAsset.h"
#import "BCAssetManager.h"

#import <Photos/Photos.h>

@implementation BCAsset

- (instancetype)initWithAsset:(PHAsset *)asset
{
    self = [super init];
    
    if (self) {
        self.asset = asset;
    }
    
    return self;
}

#pragma mark readonly
- (UIImage *)originImage
{
    return [[BCAssetManager defaultManager] originPhotoWithAsset:self.asset];
}

- (NSData *)originData
{
    return [[BCAssetManager defaultManager] originDataWithAsset:self.asset];
}

- (UIImage *)thumbnail
{
    return [[BCAssetManager defaultManager] thumbnailWithAsset:self.asset size:self.thumbnailSize];
}

@end
