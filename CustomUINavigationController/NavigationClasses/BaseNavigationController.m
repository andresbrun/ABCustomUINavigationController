//
//  BaseNavigationController.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseNavigationControllerDelegate.h"

@interface BaseNavigationController ()
@property (nonatomic, strong) BaseNavigationControllerDelegate *navigationDelegate;
@end

@implementation BaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.navigationDelegate = [[BaseNavigationControllerDelegate alloc] initWithAnimatedTransitioning:[self createAnimatedTransitioningUsed]];
        self.delegate = self.navigationDelegate;
    }
    return self;
}

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    if (!self.delegate) {
        [super setDelegate:delegate];
    }
    
    if (delegate!=self.delegate) {
        [self.navigationDelegate setForwardDelegate: delegate];
    }
}

- (BaseControllerAnimatedTransitioningDelegate *)createAnimatedTransitioningUsed {
    NSAssert(YES, @"Abstract method, it should be inherated");
    return nil;
}

@end
