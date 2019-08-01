//
//  UIImageView+NetImg.m
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "UIImageView+NetImg.h"
#import "BCImageLoader.h"

@implementation UIImageView (NetImg)

- (void)bc_setImageUrl:(NSString *)imgurl
{
    [self bc_setImageUrl:imgurl placeholder:nil];
}

- (void)bc_setImageUrl:(NSString *)imgurl placeholder:(NSString *)placeholder
{
    [[BCImageLoader defaultLoader] bc_loadImageWithURL:imgurl placeholder:placeholder corner:0 bounds:CGRectZero loadHandler:^(UIImage *image) {
        [self setImage:image];
    }];
}

- (void)bc_setImageData:(NSData *)data
{
    [self bc_setImageData:data withCorner:0 placeholder:nil];
}

- (void)bc_setImageData:(NSData *)data placeholder:(NSString *)placeholder
{
    [self bc_setImageData:data withCorner:0 placeholder:placeholder];
}

- (void)bc_setImageData:(NSData *)data withCorner:(CGFloat)corner placeholder:(NSString *)placeholder
{
    [[BCImageLoader defaultLoader] bc_loadImageWithData:data placeholder:placeholder corner:corner bounds:self.bounds loadHandler:^(UIImage *image) {
        [self setImage:image];
    }];
}

@end
