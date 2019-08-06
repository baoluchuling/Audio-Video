//
//  NSData+Security.h
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/2.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Security)

- (NSString *)md5;
- (NSString *)SHA256;

@end

