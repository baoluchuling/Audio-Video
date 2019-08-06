//
//  NSObject+BCModel.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/20.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (BCModel)

+ (instancetype)modelSetWithDictionary:(NSDictionary *)dictionary;

- (BOOL)modelSetWithDictionary:(NSDictionary *)dictionary;

@end
