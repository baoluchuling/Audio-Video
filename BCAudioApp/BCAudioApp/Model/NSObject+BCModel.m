//
//  NSObject+BCModel.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/5/20.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "NSObject+BCModel.h"
#import <objc/runtime.h>

@implementation NSObject (BCModel)

+ (instancetype)modelSetWithDictionary:(NSDictionary *)dictionary
{
    Class cls = [self class];
    
    NSObject *obj = [cls new];
    
    if ([obj modelSetWithDictionary:dictionary]) {
        return obj;
    }
    
    return nil;
}

- (BOOL)modelSetWithDictionary:(NSDictionary *)dictionary
{
    Class cls = [self class];
    
    unsigned int ivarCount = 0;
    Ivar *ivars = class_copyIvarList(cls, &ivarCount);

    if (ivarCount == 0) {
        return NO;
    }

    for (int i = 0; i < ivarCount; i++) {
        Ivar ivar = ivars[i];
        const char *ivarName = ivar_getName(ivar);
        
        NSString *propertyName = [NSString stringWithUTF8String:++ivarName];

        id obj = [dictionary objectForKey:propertyName];
        if (obj != nil) {
            object_setIvar(self, ivar, obj);
        }
    }
    
    return YES;
}

@end
