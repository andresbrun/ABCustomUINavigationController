//
//  BaseNavigationController.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "BaseNavigationController.h"
#import "TransitionViewControllerDelegate.h"
#import "CubeAnimator.h"

@interface BaseNavigationControllerDelegate : NSObject <UINavigationControllerDelegate>
@property (nonatomic, strong) BaseControllerAnimatedTransitioningDelegate *transitionDelegate;
@end

@implementation BaseNavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    self.transitionDelegate.presenting = (operation == UINavigationControllerOperationPush);
    return [self transitionDelegate];
}

- (BaseControllerAnimatedTransitioningDelegate *)transitionDelegate {
    if (!_transitionDelegate) {
        //        _transitionDelegate = [BaseControllerAnimatedTransitioningDelegate new];
        _transitionDelegate = [CubeAnimator new];
    }
    
    return _transitionDelegate;
}

@end



@interface BaseNavigationController ()
@property (nonatomic, strong) id<UINavigationControllerDelegate> navigationDelegate;
@end

@implementation BaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationDelegate = [BaseNavigationControllerDelegate new];
        self.delegate = self.navigationDelegate;
    }
    
    return self;
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    [super setDelegate:delegate];
    //TODO: forward delegate. Bypassing BaseNavigationControllerDelegate
}

@end
