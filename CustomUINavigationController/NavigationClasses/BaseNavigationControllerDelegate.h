//
//  TransitionViewControllerDelegate.h
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseControllerAnimatedTransitioningDelegate;

@interface BaseNavigationControllerDelegate : NSObject <UINavigationControllerDelegate>

- (instancetype)initWithAnimatedTransitioning:(BaseControllerAnimatedTransitioningDelegate *)animatedTransitioningUsed;

@property (weak) id<UINavigationControllerDelegate> forwardDelegate;
@property (nonatomic, strong) BaseControllerAnimatedTransitioningDelegate *transitionDelegate;

@end
