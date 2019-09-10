//
//  BCDateFormatter.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/8/6.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCDateFormatter.h"

static BCDateFormatter *formatter = nil;

@implementation BCDateFormatter

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[BCDateFormatter alloc] init];
    });
    return formatter;
}

- (NSString *)currentDate
{
    return [self stringFromDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss.SSS"];
}

- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    [self setDateFormat:format];
    
    return [self stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string format:(NSString *)format
{
    [self setDateFormat:format];
    
    return [self dateFromString:string];
}

@end
