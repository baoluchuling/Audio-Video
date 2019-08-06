//
//  BCCircleDiscView.m
//  BCAudioApp
//
//  Created by boluchuling on 2019/6/1.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCCircleDiscView.h"
#import "Masonry.h"

@interface BCCircleDiscView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CFTimeInterval timeOffset;

@end

@implementation BCCircleDiscView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_width);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置path
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:150].CGPath;
}

- (void)updateBackImage
{
    if (_imageData) {
        [self.imageView setImage:[UIImage imageWithData:_imageData]];
    }
    
    if (_imageFile) {
        [self.imageView setImage:[UIImage imageNamed:_imageFile]];
    }
}

- (void)refreshAnimation
{
    if (self.layer.speed == 0) {
        CFTimeInterval pausedTime = self.layer.timeOffset;
        self.layer.speed = 1;
        self.layer.timeOffset = 0.0f;
        self.layer.beginTime = 0.0f;
        
        self.layer.beginTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime + 0.05;

    } else {
        CFTimeInterval pausedTime0 = CACurrentMediaTime();
        CFTimeInterval pausedTime = [self.layer convertTime:pausedTime0 fromLayer:nil];
        self.layer.speed = 0;
        self.layer.timeOffset = pausedTime + 0.05; // 加0.05,中间间隔的
    }
}

- (void)start
{
    [self refreshAnimation];
}

- (void)stop
{
    [self refreshAnimation];
}

- (CAAnimation *)generateAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(0);
    animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    animation.repeatCount = MAXFLOAT;
    animation.duration = 6.0f;
    animation.removedOnCompletion = NO;
    
    return animation;
}

- (void)constructViewLayer
{
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.shadowColor = [UIColor grayColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 5.0f;
    self.layer.borderWidth = 3;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark -- setter & getter
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if (_cornerRadius != cornerRadius) {
        _cornerRadius = cornerRadius;
        
        self.imageView.layer.cornerRadius = cornerRadius;
        [self constructViewLayer];
    }
}

- (void)setImageData:(NSData *)imageData
{
    if (_imageData != imageData) {
        _imageData = imageData;
        _imageFile = nil;
        
        [self updateBackImage];
    }
}

- (void)setImageFile:(NSString *)imageFile
{
    if (_imageFile != imageFile) {
        _imageFile = imageFile;
        _imageData = nil;
        
        [self updateBackImage];
    }
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFit];
        [_imageView.layer setMasksToBounds:YES];
        [_imageView.layer addAnimation:[self generateAnimation] forKey:@"transform.rotation.z"];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

@end
