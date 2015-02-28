//
//  GridBaseNavigationController.h
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 27/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseControllerAnimatedTransitioningDelegate.h"

typedef enum {FSNavSortMethodRandom, FSNavSortMethodHorizontal} FSNavSortMethod;

@interface GridBaseNavigationController : BaseControllerAnimatedTransitioningDelegate

@property (nonatomic, assign) FSNavSortMethod sortMethod;

@end
