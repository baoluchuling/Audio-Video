//
//  BCAudioInfo.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCAudioInfo.h"
#import "BCAudioUtil.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation BCAudioInfo

+ (void)batchObtainAudioInfoWithPaths:(NSArray *)paths complete:(void(^)(NSArray *))completeHandler;
{
    [self batchObtainAudioInfoWithPaths:paths progress:nil complete:completeHandler];
}

+ (void)batchObtainAudioInfoWithPaths:(NSArray *)paths progress:(void(^)(BCAudioInfo *))progressHandler complete:(void(^)(NSArray *))completeHandler
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *musicInfos = [NSMutableArray array];
        
        [paths enumerateObjectsUsingBlock:^(NSString *filePath, NSUInteger idx, BOOL *stop) {
            
            NSDictionary *musicInfo = [BCAudioUtil transformSingleAudioInfoWithFilePath:filePath];

            BCAudioInfo *info = [BCAudioInfo modelSetWithDictionary:musicInfo];
            
            if (progressHandler) {
                progressHandler(info);
            }
            
            [musicInfos addObject:info];
        }];
        
        if (musicInfos.count > 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completeHandler) {
                    completeHandler(musicInfos);
                }
            });
        }
    });
}

- (NSDictionary *)remoteInfo
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (self.title) {
        [dict setObject:self.title forKey:MPMediaItemPropertyTitle];
    }
    
    if (self.artist) {
        [dict setObject:self.artist forKey:MPMediaItemPropertyArtist];
    }
    
    if (self.albumName) {
        [dict setObject:self.artist forKey:MPMediaItemPropertyAlbumTitle];
    }
    
    if (self.artwork) {
        __weak typeof(self) weakSelf = self;
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithBoundsSize:CGSizeZero
                                                                      requestHandler:^UIImage * _Nonnull(CGSize size) {
            return [UIImage imageWithData:weakSelf.artwork];
        }];
        
        [dict setObject:artwork forKey:MPMediaItemPropertyArtwork];
    }
    
    return dict;
}
@end
