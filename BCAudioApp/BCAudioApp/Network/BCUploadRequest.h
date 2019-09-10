//
//  BCUploadRequest.h
//  BCDownloadDemo
//
//  Created by 郭兆伟 on 2019/8/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCUploadRequest : NSObject


- (NSURLSessionDataTask *)uploadWithRequest:(NSURLRequest *)URLRequest progress:(void(^)(NSData *, double))progress complete:(void(^)(NSError *))complete;

@end
