//
//  BCSlider.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/6/1.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCSlider.h"

@implementation BCSlider

- (CGRect)minimumValueImageRectForBounds:(CGRect)bounds
{
    return CGRectMake(CGRectGetMinX(bounds), (CGRectGetHeight(bounds) - 24) / 2, 24, 24);
}

@end
