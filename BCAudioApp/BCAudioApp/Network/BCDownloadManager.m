//
//  BCDownloadManager.m
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCDownloadManager.h"
#import "BCUploadRequest.h"
#import "BCDateFormatter.h"

#import "BCCache.h"

#import "NSString+Security.h"

@implementation BCURLRequest

- (NSString *)fileName
{
    return self.URL.absoluteString.md5;
}

@end

@interface BCDownloadManager ()

@property (nonatomic, strong) BCUploadRequest *request;

@property (nonatomic, strong) NSMutableDictionary *taskPools;

@property (nonatomic, strong) BCCache *dataCache;

@end

static BCDownloadManager *manager = nil;

@implementation BCDownloadManager

+ (instancetype)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BCDownloadManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.taskPools = [NSMutableDictionary dictionary];
        self.request = [[BCUploadRequest alloc] init];
    }
    return self;
}

- (NSMutableDictionary *)taskPools
{
    if (!_taskPools) {
        _taskPools = [NSMutableDictionary dictionary];
    }
    
    return _taskPools;
}

- (BCCache *)dataCache
{
    if (!_dataCache) {
        _dataCache = [[BCCache alloc] init];
        _dataCache.cacheFolder = @"com.boluchuling.cache.upload";
    }
    return _dataCache;
}

- (NSString *)generateRequestIDWithURL:(NSString *)url
{
    NSString *dateString = [[BCDateFormatter shareInstance] currentDate];
    return [NSString stringWithFormat:@"%@-%@", url, dateString].SHA256;
}

- (NSString *)uploadWithRequest:(BCURLRequest *)URLRequest progress:(void(^)(double))progress complete:(void(^)(NSData *, NSError *))complete
{
    // 判断是否已经有了请求，进行重启
    {
        NSURLSessionDataTask *task = [self.taskPools objectForKey:URLRequest.requestID];
        
        if (task) {
            switch (task.state) {
                case NSURLSessionTaskStateSuspended:
                    [task resume];
                    return URLRequest.requestID;
    
                case NSURLSessionTaskStateRunning:
                    return URLRequest.requestID;
                    
                case NSURLSessionTaskStateCanceling:
                case NSURLSessionTaskStateCompleted:
                default:
                    @synchronized (self.taskPools) {
                        [self.taskPools removeObjectForKey:URLRequest.requestID];
                    }
                    break;
            }
        }
    }
    
    // 判断是否开启缓存。 开启缓存，字节返回缓存数据
    if (URLRequest.needCache) {
        NSData *data = [self.dataCache objectForKey:URLRequest.fileName];
        
        /*
         * 问题，没办法从中间进行缓存，一旦使用缓存就直接结束了，
         */
        if (data) {
            
            size_t offset = data.length;
            
            [URLRequest setValue:[NSString stringWithFormat:@"bytes=%zd-", offset] forHTTPHeaderField:@"Range"];
            
//            progress(1);
//            complete(data, nil);
//            return nil;
        }
    }
    
    // 重新请求，更新旧缓存
    [self.dataCache clearCacheForKey:URLRequest.fileName];
    
    /*
     * 1、生成requestID
     * 2、保存映射。  requestID --> 文件名 --> 文件数据
     * 3、设置回调block
     * 4、发起请求
     */
    URLRequest.requestID = [self generateRequestIDWithURL:URLRequest.fileName];
    
    
    // 回调
    __weak typeof(self) weakSelf = self;
    
    void(^progresssHandler)(NSData *, double) = ^(NSData *splitData, double value) {

        [weakSelf.dataCache appendObject:splitData forKey:URLRequest.fileName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            progress(value);
        });
    };
    
    void(^completeHandler)(NSError *) = ^(NSError *err) {
        @synchronized (weakSelf.taskPools) {
            if (weakSelf.taskPools[URLRequest.requestID]) {
               [weakSelf.taskPools removeObjectForKey:URLRequest.requestID];
            }
        }
        
        NSData *data = [weakSelf.dataCache objectForKey:URLRequest.fileName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(data, err);
        });
    };
    
    // 下载请求
    NSURLSessionDataTask *task = [self.request uploadWithRequest:URLRequest
                                                        progress:progresssHandler
                                                        complete:completeHandler];
    
    @synchronized (self.taskPools) {
        [self.taskPools setObject:task forKey:URLRequest.requestID];
    }
    
    return URLRequest.requestID;
}

- (BOOL)stopRequest:(NSString *)requestID
{
    NSURLSessionDataTask *task = [self.taskPools objectForKey:requestID];
    
    if (!task) {
        return NO;
    }
    
    [task suspend];
    
    return YES;
}

- (BOOL)cancelRequest:(NSString *)requestID
{
    NSURLSessionDataTask *task = [self.taskPools objectForKey:requestID];
    
    if (!task) {
        return NO;
    }
    
    @synchronized (self.taskPools) {
        [self.taskPools removeObjectForKey:requestID];
    }
    
    [task cancel];
    
    return YES;
}

@end
