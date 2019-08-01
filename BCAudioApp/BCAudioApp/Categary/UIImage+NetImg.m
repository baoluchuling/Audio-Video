//
//  UIImage+NetImg.m
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "UIImage+NetImg.h"
#import "BCImageLoader.h"

@implementation UIImage (NetImg)

+ (UIImage *)bc_imageWithUrl:(NSString *)url
{
    return [BCImageLoader bc_loadImageWithURL:url];
}

@end
