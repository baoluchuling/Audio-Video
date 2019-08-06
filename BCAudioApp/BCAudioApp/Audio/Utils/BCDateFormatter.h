//
//  BCDateFormatter.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/8/6.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCDateFormatter : NSObject

+ (instancetype)shareInstance;

- (NSString *)stringFromDate:(NSDate *)date;
- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format;

- (NSDate *)dateFromString:(NSString *)string;
- (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;

@end
