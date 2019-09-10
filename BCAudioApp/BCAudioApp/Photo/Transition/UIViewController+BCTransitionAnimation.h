//
//  UIViewController+BCTransitionAnimation.h
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCCustomTransitionProtocol <NSObject>

@optional
- (BOOL)needCustomTransition;
- (UIView *)targetViewForViewController;

@end

@interface UIViewController (BCTransitionAnimation) <UIViewControllerTransitioningDelegate, BCCustomTransitionProtocol>

@end
