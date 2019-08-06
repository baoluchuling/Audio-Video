//
//  BCAudioManager.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/19.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCAudioManager.h"

@implementation BCAudioManager

+ (NSArray *)fetchSandboxAudioInfoWithDirector:(NSString *)director
{
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *musicPath = [document stringByAppendingPathComponent:director];
    
    BOOL isDir = NO;
    NSArray *musicPaths;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:musicPath isDirectory:&isDir] && isDir) {
        musicPaths = [fileManager subpathsAtPath:musicPath];
    }
    
    [musicPaths enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL * _Nonnull stop) {
        fileName = [musicPath stringByAppendingPathComponent:fileName];
    }];

    return musicPaths;
}

+ (NSArray *)fetchBundleAudioInfoWithType:(NSString *)type
{
    return [[NSBundle mainBundle] pathsForResourcesOfType:type inDirectory:nil];
}

@end
