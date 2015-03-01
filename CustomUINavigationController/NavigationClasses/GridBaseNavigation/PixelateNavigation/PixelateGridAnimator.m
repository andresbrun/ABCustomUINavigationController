//
//  PixelateGridAnimator.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 28/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "PixelateGridAnimator.h"

@implementation PixelateGridAnimator

- (NSUInteger)rowsNumber {
    return 22;
}

- (NSUInteger)columnsNumber {
    return 32;
}

- (void)animateFromCellView:(UIView *)fromCell toCellView:(UIView *)toCell inTime:(NSTimeInterval)time {
    
    [toCell setAlpha:0.0];
    [self.containerView addSubview:toCell];
    
    [UIView animateWithDuration:time animations:^{
        [fromCell setAlpha:0.0];
        [toCell setAlpha:1.0];
    }];
}

@end
