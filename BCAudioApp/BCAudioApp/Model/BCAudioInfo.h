//
//  BCAudioInfo.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+BCModel.h"

typedef NS_ENUM(NSUInteger, BCMusicStorageType) {
    BCMusicStorageTypeDefault,
    BCMusicStorageTypeSandbox,
    BCMusicStorageTypeNetwork,
};

@interface BCAudioInfo : NSObject

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *albumName;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *fileStyle;
@property (nonatomic, copy) NSString *creatDate;

@property (nonatomic, strong) NSData *artwork;

@property (nonatomic, assign) BCMusicStorageType storageType;

@property (readonly) NSDictionary *remoteInfo;

+ (void)batchObtainAudioInfoWithPaths:(NSArray *)paths complete:(void(^)(NSArray *))completeHandler;

+ (void)batchObtainAudioInfoWithPaths:(NSArray *)paths progress:(void(^)(BCAudioInfo *))progressHandler complete:(void(^)(NSArray *))completeHandler;

@end
