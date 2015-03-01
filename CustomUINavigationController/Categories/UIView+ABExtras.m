//
//  UIView+ABExtras.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "UIView+ABExtras.h"

const NSInteger TAG_EMBEDDED_VIEW = 999;

@implementation UIView (ABExtras)

- (CAGradientLayer *)addLinearGradientWithColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //the gradient layer must be positioned at the origin of the view
    CGRect gradientFrame = self.frame;
    gradientFrame.origin.x = 0;
    gradientFrame.origin.y = 0;
    gradient.frame = gradientFrame;
    
    //build the colors array for the gradient
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[theColor CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.9f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.6f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.4f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[UIColor clearColor] CGColor],
                       nil];
    
    //reverse the color array if needed
    if(transparentToOpaque) {
        colors = [[colors reverseObjectEnumerator] allObjects];
    }
    
    //apply the colors and the gradient to the view
    gradient.colors = colors;
    
    unsigned index = (unsigned)[self.layer.sublayers count];
    [self.layer insertSublayer:gradient atIndex:index];
    
    return gradient;
}

- (UIView *)addOpacityWithColor:(UIColor *)theColor
{
    UIView *shadowView = [[UIView alloc] initWithFrame:self.bounds];
    
    [shadowView setBackgroundColor:theColor];
    
    [self addSubview:shadowView];
    
    return shadowView;
}

- (UIView *)embedView
{
    UIView *newView = [[UIView alloc] initWithFrame:self.frame];
    [self setTag:TAG_EMBEDDED_VIEW];
    [self setFrame:self.bounds];
    [newView addSubview:self];
    
    return newView;
}

- (UIView *)getEmbeddedView {
    return [self viewWithTag:TAG_EMBEDDED_VIEW];
}

- (UIView *)viewByCroppingInRect:(CGRect)rect {
    return [self resizableSnapshotViewFromRect:rect afterScreenUpdates:YES withCapInsets:UIEdgeInsetsZero];
}

- (UIView *) createSnapshotView
{
    UIView *currentView = [self snapshotViewAfterScreenUpdates:YES];
    
    return currentView;
}

@end
