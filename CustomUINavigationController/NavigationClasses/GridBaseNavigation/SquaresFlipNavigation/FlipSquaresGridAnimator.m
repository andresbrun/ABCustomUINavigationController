//
//  FlipSquaresGridAnimator.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 01/03/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "FlipSquaresGridAnimator.h"
#import "UIView+ABExtras.h"

@interface FlipSquaresGridAnimator ()
@property(nonatomic, strong) CAGradientLayer *fromGradient;
@property(nonatomic, strong) CAGradientLayer *toGradient;
@end

@implementation FlipSquaresGridAnimator

- (NSUInteger)columnsNumber {
    return 8;
}

- (NSUInteger)rowsNumber {
    return 5;
}
 
-(void)animateFromCellView:(UIView *)fromCell toCellView:(UIView *)toCell inTime:(NSTimeInterval)time {
    self.fromGradient = [fromCell addLinearGradientWithColor:[UIColor blackColor] transparentToOpaque:YES];
    self.toGradient = [toCell addLinearGradientWithColor:[UIColor blackColor] transparentToOpaque:YES];
    
    [self animateLighting:self.fromGradient darking:self.toGradient inTime:time];
    
    [UIView transitionFromView:[fromCell getEmbeddedView]
                        toView:[toCell getEmbeddedView]
                      duration:time
                       options:[self optionsFromFlip]
                    completion:^(BOOL finished) {
                        [self removeShadowGradients];
                    }];

}

- (void) removeShadowGradients {
    [self.fromGradient removeFromSuperlayer];
    [self.toGradient removeFromSuperlayer];
}

- (void) animateLighting:(CAGradientLayer *)fromGradient darking:(CAGradientLayer *)toGradient inTime:(NSTimeInterval)time {
    [fromGradient setOpacity:1.0];
    [toGradient setOpacity:0.0];
    
    [UIView animateWithDuration:time animations:^{
        [fromGradient setOpacity:0.0];
        [toGradient setOpacity:1.0];
    }];
}

- (UIViewAnimationOptions) optionsFromFlip {
    if (self.presenting) {
        return UIViewAnimationOptionTransitionFlipFromLeft;
    } else {
        return UIViewAnimationOptionTransitionFlipFromRight;
    }
}

@end
