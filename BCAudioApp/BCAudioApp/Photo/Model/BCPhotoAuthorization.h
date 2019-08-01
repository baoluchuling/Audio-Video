//
//  BCPhotoAuthorization.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCPhotoAuthorization : NSObject

+ (void)authorizationWithCompleteHandler:(void(^)(void))completeHandler;

@end
