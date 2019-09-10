//
//  BCControlView.m
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/6.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCControlView.h"

@interface BCControlView ()

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation BCControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self constructView];
    }
    
    return self;
}

- (void)constructView
{
    self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.playButton.frame = CGRectMake(0, 0, 50, 50);
    self.playButton.backgroundColor = [UIColor whiteColor];
    [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
    [self addSubview:self.playButton];
}

@end
