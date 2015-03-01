//
//  FlipSquaresNavigationController.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 7/14/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "FlipSquaresNavigationController.h"
#import "FlipSquaresGridAnimator.h"

@implementation FlipSquaresNavigationController

- (BaseControllerAnimatedTransitioningDelegate *)createAnimatedTransitioningUsed {
    FlipSquaresGridAnimator *animator = [FlipSquaresGridAnimator new];
    [animator setSortMethod:ScanningSortMethodHorizontal];
    return animator;
}

@end
