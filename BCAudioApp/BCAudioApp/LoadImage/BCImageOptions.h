//
//  BCImageOptions.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/8/1.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BCImageOptions : NSObject

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) CGSize outputSize;

@property (nonatomic, strong) NSArray<NSNumber *> *cornerRadius;
@property (nonatomic, assign) UIRectCorner cornerTypes;

- (instancetype)initWithPlaceholder:(NSString *)placeholder;

@end

