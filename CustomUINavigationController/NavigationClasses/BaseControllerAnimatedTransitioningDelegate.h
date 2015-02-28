//
//  BaseNavigationControllerDelegate.h
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseControllerAnimatedTransitioningDelegate : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, weak) UIView *fromView;
@property (nonatomic, weak) UIView *toView;

@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, assign, getter=isPresenting) BOOL presenting;

- (void)animateWithCompletion:(void(^)(void))completion;

@end
