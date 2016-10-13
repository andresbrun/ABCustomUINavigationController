//
//  UIImage+ABExtras.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 13/10/2016.
//  Copyright © 2016 Andrés Brun. All rights reserved.
//

#import "UIImage+ABExtras.h"

@implementation UIImage (ABExtras)

- (UIImageView *)imageViewByCroppingInRect:(CGRect)rect
{
    UIImage *imageCropped = [self cropImageInRect:rect];
    UIImageView* imageViewCropped = [[UIImageView alloc] initWithImage:imageCropped];
    [imageViewCropped setFrame:rect];
    return imageViewCropped;
}

- (UIImage *)cropImageInRect:(CGRect)rect
{
    double (^rad)(double) = ^(double deg) {
        return deg / 180.0 * M_PI;
    };
    
    CGAffineTransform rectTransform;
    switch (self.imageOrientation) {
    case UIImageOrientationLeft:
        rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(90)), 0, -self.size.height);
    break;
    case UIImageOrientationRight:
        rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-90)), -self.size.width, 0);
    break;
    case UIImageOrientationDown:
        rectTransform = CGAffineTransformTranslate(CGAffineTransformMakeRotation(rad(-180)), -self.size.width, -self.size.height);
    break;
    default:
        rectTransform = CGAffineTransformIdentity;
    };
    rectTransform = CGAffineTransformScale(rectTransform, self.scale, self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectApplyAffineTransform(rect, rectTransform));
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return result;
}

@end
