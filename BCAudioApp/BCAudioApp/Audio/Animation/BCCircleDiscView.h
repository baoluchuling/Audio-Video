//
//  BCCircleDiscView.h
//  BCAudioApp
//
//  Created by boluchuling on 2019/6/1.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BCCircleDiscView : UIView

@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, copy) NSString *imageFile;

- (void)refreshAnimation;
- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
