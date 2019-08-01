//
//  UIImageView+netImg.h
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIImageView (NetImg)

- (void)bc_setImageUrl:(NSString *)imgurl;
- (void)bc_setImageUrl:(NSString *)imgurl placeholder:(NSString *)placeholder;

- (void)bc_setImageData:(NSData *)data;
- (void)bc_setImageData:(NSData *)data placeholder:(NSString *)placeholder;
- (void)bc_setImageData:(NSData *)data withCorner:(CGFloat)corner placeholder:(NSString *)placeholder;

@end

