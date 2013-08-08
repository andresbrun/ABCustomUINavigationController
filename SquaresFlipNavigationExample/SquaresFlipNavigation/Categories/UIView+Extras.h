//
//  UIView+Extras.h
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (Extras)

- (CAGradientLayer *)addLinearGradientWithColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque;
- (UIImageView *) imageInNavController: (UINavigationController *) navController;
- (UIView *)addOpacityWithColor:(UIColor *)theColor;

@end
