//
//  BCTransition.m
//  BCAudioApp
//
//  Created by 郭兆伟 on 2019/8/18.
//  Copyright © 2019 boluchuling. All rights reserved.
//

#import "BCPresentTransition.h"

@implementation BCPresentTransition

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if ([fromVC isKindOfClass:[UINavigationController class]]) {
        fromVC = ((UINavigationController *)fromVC).topViewController;
    }
    
    if (![fromVC performSelector:@selector(needCustomTransition)] || ![toVC performSelector:@selector(needCustomTransition)]) {
        return;
    }

    UIView *containerView = [transitionContext containerView];
    
    UIView *fromTargetView = [fromVC performSelector:@selector(targetViewForViewController)];
    UIView *toTargetView = [toVC performSelector:@selector(targetViewForViewController)];

    UIView *screenShot = [fromTargetView snapshotViewAfterScreenUpdates:NO];
    screenShot.backgroundColor = [UIColor clearColor];
    screenShot.frame = [containerView convertRect:fromTargetView.frame fromView:fromTargetView.superview];

    // 设置第二个控制器的位置和透明度
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.alpha = 0.5;
    toTargetView.hidden = YES;
    
    // 把动画前后的两个ViewController加到容器控制器中
    [containerView addSubview:toVC.view];
    [containerView addSubview:screenShot];
    
    // 注意添加顺序
    
    // 现在开始做动画
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        // 调用自动布局
        [containerView layoutIfNeeded];
        
        fromVC.view.alpha = 1.0;
        toVC.view.alpha = 1;

        // 布局坐标
        screenShot.frame = [containerView convertRect:toTargetView.frame toView:toTargetView.superview];
        
    } completion:^(BOOL finished) {
        toTargetView.hidden = NO;
        fromTargetView.hidden = NO;
        
        // 动画截图移除View
        [screenShot removeFromSuperview];
        
        // 动画结束
        
        // 一定不要忘记告诉系统动画结束
        // 执行
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(nullable id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

@end
