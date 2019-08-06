//
//  BCAudioUtil.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCAudioUtil.h"
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, BCAudioType) {
    BCAudioTypeMP3,
    BCAudioTypeFLAC,
};

@interface BCAudioUtil ()

@property (nonatomic, weak) id<BCAudioUtilProtocol> protocol;

@end

@implementation BCAudioUtil

+ (instancetype)defaultWithFilePath:(NSString *)filePath
{
    NSString *typeName = [[filePath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]] lastObject].lowercaseString;

    if ([typeName isEqualToString:@"mp3"]) {
        return [[BCAudioTypeMP3Util alloc] init];
    } else if ([typeName isEqualToString:@"flac"]) {
        return [[BCAudioTypeFLACUtil alloc] init];
    } else {
        return nil;
    }
}

+ (NSDictionary *)transformSingleAudioInfoWithFilePath:(NSString *)filePath
{
    BCAudioUtil *utils = [BCAudioUtil defaultWithFilePath:filePath];
    
    if ([utils respondsToSelector:@selector(transformAudioInfoWithFilePath:)]) {
        return [utils.protocol transformAudioInfoWithFilePath:filePath];
    }
    
    return nil;
}

@end

@implementation BCAudioTypeMP3Util

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.protocol = self;
    }
    return self;
}

- (NSDictionary *)transformAudioInfoWithFilePath:(NSString *)filePath
{
    NSMutableDictionary *musicInfo = [NSMutableDictionary dictionary];
    [musicInfo addEntriesFromDictionary:@{@"filePath": filePath}];
    
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    NSArray *metadataFormats = urlAsset.availableMetadataFormats;
    
    [metadataFormats enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *metadataItems = [urlAsset metadataForFormat:obj];
        
        [metadataItems enumerateObjectsUsingBlock:^(AVMetadataItem  *metadata, NSUInteger idx, BOOL *stop) {
            if (metadata.commonKey != nil) {
                [musicInfo setObject:metadata.value forKey:metadata.commonKey];
            }
        }];
    }];
    
    return musicInfo;
}

@end

@implementation BCAudioTypeFLACUtil

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.protocol = self;
    }
    return self;
}

- (NSDictionary *)transformAudioInfoWithFilePath:(NSString *)filePath
{
    return nil;
}

@end
