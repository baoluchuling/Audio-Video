//
//  BCDownloadManager.h
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BCRequestID NSString*

@interface BCURLRequest : NSMutableURLRequest

@property (nonatomic, copy) NSString *requestID;
@property (nonatomic, assign) BOOL needCache;

@property (nonatomic, readonly) NSString *fileName;

@end

@interface BCDownloadManager : NSObject

+ (instancetype)defaultManager;

- (BCRequestID)uploadWithRequest:(BCURLRequest *)URLRequest progress:(void(^)(double))progress complete:(void(^)(NSData *, NSError *))complete;

- (BOOL)stopRequest:(NSString *)requestID;
- (BOOL)cancelRequest:(NSString *)requestID;

@end
