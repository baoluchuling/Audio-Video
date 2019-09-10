//
//  UIViewController+BCTransitionAnimation.m
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "UIViewController+BCTransitionAnimation.h"
#import "BCPresentTransition.h"
#import "BCDismissTransition.h"

@implementation UIViewController (BCTransitionAnimation)

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [[BCPresentTransition alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[BCDismissTransition alloc] init];
}

@end
