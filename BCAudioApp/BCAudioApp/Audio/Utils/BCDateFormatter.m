//
//  BCDateFormatter.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/8/6.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCDateFormatter.h"

@interface BCDateFormatter ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

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

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    return self;
}

- (NSString *)stringFromDate:(NSDate *)date format:(NSString *)format
{
    [self.dateFormatter setDateFormat:format];
    
    return [self stringFromDate:date];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    return [self.dateFormatter stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)string format:(NSString *)format
{
    [self.dateFormatter setDateFormat:format];
    
    return [self dateFromString:string];
}

- (NSDate *)dateFromString:(NSString *)string
{
    return [self.dateFormatter dateFromString:string];
}

@end
