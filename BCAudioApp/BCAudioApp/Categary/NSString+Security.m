//
//  NSString+Security.m
//  BCDownloadDemo
//
//  Created by boluchuling on 2019/7/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "NSString+Security.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSString (Security)

- (NSString *)md5 {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), buffer);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", buffer[i]];
    }
    
    return result;
}

- (NSString *)SHA256 {
    const char *str = self.UTF8String;
    uint8_t buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(str, (CC_LONG)strlen(str), buffer);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", buffer[i]];
    }
    
    return result;
}

@end
