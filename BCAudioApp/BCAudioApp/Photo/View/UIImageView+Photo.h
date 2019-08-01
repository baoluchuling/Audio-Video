//
//  UIImageView+Photo.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Photo)

- (void)bc_setImageAsset:(id)asset;
- (void)bc_setImageAsset:(id)asset size:(CGSize)size;

@end
