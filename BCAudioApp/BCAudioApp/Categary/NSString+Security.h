//
//  NSString+Security.h
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Security)

- (NSString *)md5;
- (NSString *)SHA256;

@end
