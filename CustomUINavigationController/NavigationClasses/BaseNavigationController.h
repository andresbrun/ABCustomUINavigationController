//
//  BaseNavigationController.h
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseControllerAnimatedTransitioningDelegate;

@interface BaseNavigationController : UINavigationController

- (BaseControllerAnimatedTransitioningDelegate *)createAnimatedTransitioningUsed;

@end
