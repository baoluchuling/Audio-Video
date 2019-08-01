//
//  UIImageView+NetImg.m
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "UIImageView+NetImg.h"
#import "BCImageLoader.h"
#import "BCImageOptions.h"

@implementation UIImageView (NetImg)

- (void)bc_setImageUrl:(NSString *)imgurl
{
    [self bc_setImageUrl:imgurl options:nil];
}

- (void)bc_setImageUrl:(NSString *)imgurl placeholder:(NSString *)placeholder
{
    BCImageOptions *options = [[BCImageOptions alloc] initWithPlaceholder:placeholder];
    
    [self bc_setImageUrl:imgurl options:options];
}

- (void)bc_setImageUrl:(NSString *)imgurl options:(BCImageOptions *)options
{
    if (options && CGSizeEqualToSize(options.outputSize, CGSizeZero)) {
        options.outputSize = self.bounds.size;
    }
    
    [[BCImageLoader defaultLoader] bc_loadImageWithURL:imgurl
                                               options:options
                                           loadHandler:^(UIImage *image) {
        [self setImage:image];
    }];
}

- (void)bc_setImageData:(NSData *)data
{
    [self bc_setImageData:data options:nil];
}

- (void)bc_setImageData:(NSData *)data placeholder:(NSString *)placeholder
{
    BCImageOptions *options = [[BCImageOptions alloc] initWithPlaceholder:placeholder];
    
    [self bc_setImageData:data options:options];
}

- (void)bc_setImageData:(NSData *)data options:(BCImageOptions *)options
{
    if (options && CGSizeEqualToSize(options.outputSize, CGSizeZero)) {
        options.outputSize = self.bounds.size;
    }
    
    [[BCImageLoader defaultLoader] bc_loadImageWithData:data
                                                options:options
                                            loadHandler:^(UIImage *image) {
        [self setImage:image];
    }];
}

@end
