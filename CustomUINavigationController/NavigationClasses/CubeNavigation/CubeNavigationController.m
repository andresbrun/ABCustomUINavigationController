//
//  CubeNavigationController.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "CubeNavigationController.h"
#import "CubeAnimator.h"

@implementation CubeNavigationController

- (BaseControllerAnimatedTransitioningDelegate *)createAnimatedTransitioningUsed {
    // TODO: configure here the animator
    return [CubeAnimator new];
}

@end
