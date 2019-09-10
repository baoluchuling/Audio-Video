//
//  BCGridViewCell.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/7/22.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCGridViewCell.h"
#import "BCAsset.h"
#import "UIImageView+Photo.h"
#import "Masonry.h"

@interface BCGridViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation BCGridViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView.frame = CGRectMake(2, 5, CGRectGetWidth(frame) - 4, CGRectGetWidth(frame) - 4);
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageView);
            make.bottom.equalTo(self.imageView);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(40);
        }];
        
        self.layer.cornerRadius = 3;
    }
    
    return self;
}

- (void)updateImage:(BCAsset *)info
{
    [self.imageView bc_setImageAsset:info.asset];
}

- (void)clickButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectPreviewButton:)]) {
        [self.delegate didSelectPreviewButton:self.index];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 3;
        [self.contentView addSubview:_imageView];
    }
    
    return _imageView;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.backgroundColor = [UIColor orangeColor];
        _button.layer.cornerRadius = 3;
        [_button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return _button;
}

- (void)setIsSelect:(BOOL)isSelect
{
    if (_isSelect != isSelect) {
        _isSelect = isSelect;
        self.backgroundColor = isSelect == YES ? [UIColor greenColor] : [UIColor whiteColor];
    }
}

@end
