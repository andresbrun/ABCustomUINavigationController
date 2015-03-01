//
//  GridBaseAnimator.h
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 28/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "BaseControllerAnimatedTransitioningDelegate.h"

typedef enum {
    ScanningSortMethodRandom,
    ScanningSortMethodHorizontal
} ScanningSortMethod;

@interface GridBaseAnimator : BaseControllerAnimatedTransitioningDelegate

@property (nonatomic, assign) ScanningSortMethod sortMethod;
@property (nonatomic, assign) NSUInteger rowsNumber;
@property (nonatomic, assign) NSUInteger columnsNumber;

- (void)animateFromCellView:(UIView *)fromCell
                 toCellView:(UIView *)toCell
                     inTime:(NSTimeInterval)time;


@end
