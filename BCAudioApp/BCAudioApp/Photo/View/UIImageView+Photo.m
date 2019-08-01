//
//  UIImageView+Photo.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "UIImageView+Photo.h"
#import "BCAssetManager.h"

@implementation UIImageView (Photo)

- (void)bc_setImageAsset:(id)asset
{
    [self bc_setImageAsset:asset size:self.frame.size];
}

- (void)bc_setImageAsset:(id)asset size:(CGSize)size
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [[BCAssetManager defaultManager] thumbnailWithAsset:asset size:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    });
}

@end
