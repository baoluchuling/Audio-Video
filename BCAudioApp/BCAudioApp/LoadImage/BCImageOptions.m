//
//  BCImageOptions.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/8/1.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCImageOptions.h"

@implementation BCImageOptions

- (instancetype)initWithPlaceholder:(NSString *)placeholder
{
    self = [super init];
    if (self) {
        self.placeholder = placeholder;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cornerTypes = UIRectCornerAllCorners;
    }
    return self;
}

- (void)setCornerRadius:(NSArray<NSNumber *> *)cornerRadius
{
    if (_cornerRadius != cornerRadius) {
        NSArray<NSNumber *> * cornerArray = @[@0, @0, @0, @0];

        if (cornerRadius.count == 1) {
            cornerArray = @[
                cornerRadius[0],
                cornerRadius[0],
                cornerRadius[0],
                cornerRadius[0]
            ];
        } else if (cornerRadius.count == 2) {
            cornerArray = @[
                cornerRadius[0],
                cornerRadius[0],
                cornerRadius[1],
                cornerRadius[1]
            ];
        } else if (cornerRadius.count == 3) {
            cornerArray = @[
                cornerRadius[0],
                cornerRadius[1],
                cornerRadius[2],
                cornerRadius[2]
            ];
        } else {
            cornerArray = cornerRadius;
        }
        
        _cornerRadius = cornerArray;
    }
}

@end
