//
//  NSData+Security.m
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/2.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "NSData+Security.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation NSData (Security)

- (NSString *)md5 {
    
    CC_MD5_CTX md5;
    
    CC_MD5_Init(&md5);
    
    CC_MD5_Update(&md5, self.bytes, (CC_LONG)self.length);
    
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(buffer, &md5);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", buffer[i]];
    }
    
    return result;
}

- (NSString *)SHA256 {
    
    CC_SHA256_CTX SHA256;
    
    CC_SHA256_Init(&SHA256);
    
    CC_SHA256_Update(&SHA256, self.bytes, (CC_LONG)self.length);
    
    unsigned char buffer[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256_Final(buffer, &SHA256);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH];
    for(int i = 0; i<CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02X", buffer[i]];
    }
    
    return result;
}

@end
