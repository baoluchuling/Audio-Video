//
//  BCPhotoAuthorization.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCPhotoAuthorization.h"
#import <Photos/Photos.h>

@implementation BCPhotoAuthorization

+ (void)authorizationWithCompleteHandler:(void(^)(void))completeHandler
{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        completeHandler();
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                completeHandler();
            } else {
                // 授权失败提示
            }
        }];
    }
}

@end
