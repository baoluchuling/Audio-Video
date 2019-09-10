//
//  BCUploadRequest.m
//  BCDownloadDemo
//
//  Created by 郭兆伟 on 2019/8/17.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCUploadRequest.h"
#import "objc/runtime.h"

// 为什么afnetworking要转发delegate？因为当复用urlSession时，所有task的delegate都会是同一个对象，需要转发来区分不同task的回调
// 通过每个task创建一个对应的delegate相关信息，以保证回调能够正确地转发
@interface BCTaskHandler : NSObject

@property (nonatomic, copy) void(^progress)(NSData *data, double);
@property (nonatomic, copy) void(^complete)(NSError *);

@end

@implementation BCTaskHandler

@end


@interface BCUploadRequest() <NSURLSessionDataDelegate>

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSOperationQueue *httpQueues;

@property (nonatomic, strong) NSMutableDictionary *taskHandlers;
@property (nonatomic, strong) NSMutableDictionary *taskPools;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation BCUploadRequest

- (NSOperationQueue *)httpQueues
{
    if (!_httpQueues) {
        _httpQueues = [[NSOperationQueue alloc] init];
        _httpQueues.maxConcurrentOperationCount = 5;
        _httpQueues.name = @"com.boluchuling.net.request";
    }
    return _httpQueues;
}

- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _session = [NSURLSession sessionWithConfiguration:configuration
                                                 delegate:self
                                            delegateQueue:self.httpQueues];
    }
    
    return _session;
}

- (NSMutableDictionary *)taskHandlers
{
    if (!_taskHandlers) {
        _taskHandlers = [NSMutableDictionary dictionary];
    }
    
    return _taskHandlers;
}

- (NSLock *)lock
{
    if (!_lock) {
        _lock = [[NSLock alloc] init];
    }
    
    return _lock;
}

- (NSURLSessionDataTask *)uploadWithRequest:(NSURLRequest *)URLRequest progress:(void(^)(NSData *, double))progress complete:(void(^)(NSError *))complete
{
    BCTaskHandler *handler = [[BCTaskHandler alloc] init];
    
    handler.progress = progress;
    handler.complete = complete;
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:URLRequest];
    
    [self.lock lock];
    [self.taskHandlers setObject:handler forKey:@(dataTask.taskIdentifier)];
    [self.lock unlock];
    
    [dataTask resume];
    
    return dataTask;
}

#pragma mark -- NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    double progress = (double)dataTask.countOfBytesReceived/dataTask.countOfBytesExpectedToReceive;
    
    [self.lock lock];
    BCTaskHandler *taskInfo = [self.taskHandlers objectForKey:@(dataTask.taskIdentifier)];
    [self.lock unlock];
    
    taskInfo.progress(data, progress);
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    [self.lock lock];
    BCTaskHandler *taskInfo = [self.taskHandlers objectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
    
    taskInfo.complete(error);
    
    [self.lock lock];
    [self.taskHandlers removeObjectForKey:@(task.taskIdentifier)];
    [self.lock unlock];
}

@end

