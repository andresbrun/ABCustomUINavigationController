//
//  TransitionViewControllerDelegate.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "BaseNavigationControllerDelegate.h"
#import "BaseControllerAnimatedTransitioningDelegate.h"

@implementation BaseNavigationControllerDelegate

- (instancetype)initWithAnimatedTransitioning:(BaseControllerAnimatedTransitioningDelegate *)animatedTransitioningUsed {
    self = [super init];
    if (self) {
        self.transitionDelegate = animatedTransitioningUsed;
    }
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    self.transitionDelegate.presenting = (operation == UINavigationControllerOperationPush);
    return self.transitionDelegate;
}

@end
