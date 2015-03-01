//
//  UIView+ABExtras.h
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (ABExtras)

/**
 Method that adds a gradient sublayer inthat view
 */
- (CAGradientLayer *)addLinearGradientWithColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque;

/**
 Create an snapshot view of the current view
 */
- (UIView *) createSnapshotView;

/**
 Method that adds a view with color in that view
 */
- (UIView *)addOpacityWithColor:(UIColor *)theColor;

/**
 Method that generate a new view adding self as subview
 */
- (UIView *)embedView;

/**
 Method that return the embedded view if exists
 */
- (UIView *)getEmbeddedView;

/**
 Method that generate a new view by cropping an area
 */
- (UIView *)viewByCroppingInRect:(CGRect)rect;

@end
