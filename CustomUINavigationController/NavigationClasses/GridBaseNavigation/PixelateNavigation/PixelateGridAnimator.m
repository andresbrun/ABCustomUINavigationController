//
//  PixelateGridAnimator.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 28/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "PixelateGridAnimator.h"

#import "UIView+ABExtras.h"
#import "NSNumber+ABGenerator.h"
#import "NSArrayMatrix.h"
#import "NSObject+ABExtras.h"

@implementation PixelateGridAnimator

- (NSUInteger)rowsNumber {
    return 25;
}

- (NSUInteger)columnsNumber {
    return 28;
}

- (void)animateFromCellView:(UIView *)fromCell toCellView:(UIView *)toCell inTime:(NSTimeInterval)time {
    [UIView animateWithDuration:time animations:^{
        [fromCell setAlpha:0.0];
        [toCell setAlpha:1.0];
    }];
}

@end
