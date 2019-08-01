//
//  BCAudioUtil.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BCAudioUtilProtocol <NSObject>

- (NSDictionary *)transformAudioInfoWithFilePath:(NSString *)filePath;

@end

@interface BCAudioUtil : NSObject

+ (NSDictionary *)transformSingleAudioInfoWithFilePath:(NSString *)filePath;

@end

@interface BCAudioTypeMP3Util : BCAudioUtil <BCAudioUtilProtocol>

@end

@interface BCAudioTypeFLACUtil : BCAudioUtil <BCAudioUtilProtocol>

@end
