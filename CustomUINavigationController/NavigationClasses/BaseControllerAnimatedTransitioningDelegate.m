//
//  BaseNavigationControllerDelegate.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "BaseControllerAnimatedTransitioningDelegate.h"
#import "UIView+ABExtras.h"

@implementation BaseControllerAnimatedTransitioningDelegate

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return [self animationDuration];
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self captureViewsInContext:transitionContext];
    
    [self animateWithCompletion:^{
        [self setFinalStateForTransitionContext:transitionContext];
        [transitionContext completeTransition:YES];
    }];
}

- (void)setFinalStateForTransitionContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [fromVC.view setFrame:[transitionContext finalFrameForViewController:fromVC]];
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [toVC.view setFrame:[transitionContext finalFrameForViewController:toVC]];
    
    [self.containerView addSubview:toVC.view];
}

- (void)animateWithCompletion:(void(^)(void))completion {
    NSAssert(YES, @"Abstract method, shouldn't be call directly");
}

- (NSTimeInterval)animationDuration {
    return 1;
}

- (void)captureViewsInContext:(id <UIViewControllerContextTransitioning>)transitionContext {
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        self.toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        self.fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    } else {
        self.toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        self.fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    }
    
    self.containerView = [transitionContext containerView];
}

@end
