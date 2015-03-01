//
//  CubeNavigationController.h
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControllerAnimatedTransitioningDelegate.h"

typedef enum {
    CubeAnimationTypeHorizontal,
    CubeAnimationTypeVertical
} CubeAnimationType;

@interface CubeAnimator : BaseControllerAnimatedTransitioningDelegate

@property (nonatomic, assign) CubeAnimationType cubeAnimationType;

@end
