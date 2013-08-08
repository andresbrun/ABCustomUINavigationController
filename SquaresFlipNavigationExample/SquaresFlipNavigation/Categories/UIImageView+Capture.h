//
//  UIImageView+Capture.h
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_IMAGE_VIEW 999

@interface UIImageView (Capture)

- (UIImageView *) createCrop: (CGRect) crop;
- (UIView *)createView;

@end
