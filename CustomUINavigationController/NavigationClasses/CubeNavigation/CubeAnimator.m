//
//  CubeNavigationController.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "CubeAnimator.h"
#import "UIView+ABExtras.h"

const NSTimeInterval TIME_ANIMATION = 1.0;
const CGFloat PERSPECTIVE = -1.0 / 200.0;
const CGFloat ROTATION_ANGLE = M_PI_2;

@interface CubeAnimator ()
@property (nonatomic, assign) CATransform3D viewFromTransform;
@property (nonatomic, assign) CATransform3D viewToTransform;
@property (nonatomic, strong) UIView *auxiliarContainerView;
@property (nonatomic, weak) UIView *fromShadow;
@property (nonatomic, weak) UIView *toShadow;

@property (nonatomic,copy)void (^completionBlock)();
@end

@implementation CubeAnimator

#pragma mark - Inhereted Methods
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cubeAnimationType = CubeAnimationTypeHorizontal;
    }
    return self;
}

- (NSTimeInterval)animationDuration {
    return TIME_ANIMATION;
}

- (void)animateWithCompletion:(void (^)(void))completion {
    
    self.completionBlock = completion;
    
    [self setUpTransition];
    
    [self doAnimation];
}

#pragma mark - Private methods
- (void)setUpTransition {
    self.auxiliarContainerView = [self createAuxiliarContainerView];
    [self create3DTransforms];
    [self setToViewInitialTransform];
    [self setUpViewsHierarchyInContainer:self.auxiliarContainerView];
    [self addShadows];
    [self shadowsDarkenFromViewLightToView];
}

- (UIView *) createAuxiliarContainerView {
    return [[UIView alloc] initWithFrame:self.containerView.bounds];
}

- (void)create3DTransforms {
    switch (self.cubeAnimationType) {
        case CubeAnimationTypeHorizontal:
            [self prepareHorizontalAnimation];
            break;
            
        case CubeAnimationTypeVertical:
            [self prepareVerticalAnimation];
            break;
    }
}

- (void)prepareHorizontalAnimation {
    CATransform3D viewFromTransform = CATransform3DMakeRotation(self.transitionDirection * ROTATION_ANGLE, 0.0, 1.0, 0.0);
    CATransform3D viewToTransform = CATransform3DMakeRotation(-self.transitionDirection * ROTATION_ANGLE, 0.0, 1.0, 0.0);
    viewToTransform.m34 = viewFromTransform.m34 = PERSPECTIVE;
    self.viewFromTransform = viewFromTransform;
    self.viewToTransform = viewToTransform;
    
    [self.toView.layer setAnchorPoint:CGPointMake(self.presenting?0:1, 0.5)];
    [self.fromView.layer setAnchorPoint:CGPointMake(self.presenting?1:0, 0.5)];
    
    [self.auxiliarContainerView setTransform:CGAffineTransformMakeTranslation(self.transitionDirection * (self.auxiliarContainerView.frame.size.width)/2.0, 0)];
}

- (void)prepareVerticalAnimation {
    CATransform3D viewFromTransform = CATransform3DMakeRotation(-self.transitionDirection * ROTATION_ANGLE, 1.0, 0.0, 0.0);
    CATransform3D viewToTransform = CATransform3DMakeRotation(self.transitionDirection * ROTATION_ANGLE, 1.0, 0.0, 0.0);
    viewToTransform.m34 = viewFromTransform.m34 = PERSPECTIVE;
    self.viewFromTransform = viewFromTransform;
    self.viewToTransform = viewToTransform;
    
    [self.toView.layer setAnchorPoint:CGPointMake(0.5, self.presenting?0:1)];
    [self.fromView.layer setAnchorPoint:CGPointMake(0.5, self.presenting?1:0)];
    
    // TODO: check y position
    [self.auxiliarContainerView setTransform:CGAffineTransformMakeTranslation(0, self.transitionDirection * (self.auxiliarContainerView.frame.size.height)/2.0)];
}

- (void)setToViewInitialTransform {
    self.toView.layer.transform = self.viewToTransform;
}

- (void)setUpViewsHierarchyInContainer: (UIView *) auxiliarContainer {
    [auxiliarContainer addSubview:self.toView];
    [auxiliarContainer addSubview:self.fromView];
    [self.containerView addSubview:auxiliarContainer];
}

- (NSInteger)transitionDirection {
    return [self isPresenting] ? 1 : -1;
}

- (void)addShadows {
    self.fromShadow = [self.fromView addOpacityWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
    self.toShadow = [self.toView addOpacityWithColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
}

- (void)doAnimation {
    [UIView animateWithDuration:[self animationDuration] animations:^{
        [self moveCube];
        [self shadowsLightFromViewDarkenToView];
    }completion:^(BOOL finished) {
        [self cleanContext];
        self.completionBlock();
    }];
}

- (void)shadowsDarkenFromViewLightToView {
    [self.fromShadow setAlpha:0.0];
    [self.toShadow setAlpha:1.0];
}

- (void)shadowsLightFromViewDarkenToView {
    [self.fromShadow setAlpha:1.0];
    [self.toShadow setAlpha:0.0];
}

- (void)moveCube {
    switch (self.cubeAnimationType) {
        case CubeAnimationTypeHorizontal:
            [self.auxiliarContainerView setTransform:CGAffineTransformMakeTranslation(-self.transitionDirection * self.auxiliarContainerView.frame.size.width/2.0, 0)];
            break;
            
        case CubeAnimationTypeVertical:
            //TODO: check Y position
            [self.auxiliarContainerView setTransform:CGAffineTransformMakeTranslation(0, -self.transitionDirection * (self.auxiliarContainerView.frame.size.height)/2.0)];
            break;
            
        default:
            break;
    }
    
    self.fromView.layer.transform = self.viewFromTransform;
    self.toView.layer.transform = CATransform3DIdentity;
}

- (void)cleanContext {
    for (UIView *view in @[self.fromView, self.toView, self.fromShadow, self.toShadow, self.auxiliarContainerView]) {
        [view.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
        [view removeFromSuperview];
        [view setTransform:CGAffineTransformIdentity];
    }
}

@end
