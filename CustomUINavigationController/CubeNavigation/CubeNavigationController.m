//
//  CubeNavigationController.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 8/8/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "CubeNavigationController.h"
#import "UIView+ABExtras.h"
#import "UIImageView+ABExtras.h"
#import "UINavigationController+ABExtras.h"

#define TIME_ANIMATION 1.0
#define PERSPECTIVE -1.0 / 200.0
#define ROTATION_ANGLE M_PI_2

@interface CubeNavigationController (){
    BOOL pushingVC;
}
@end

@implementation CubeNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.cubeAnimationType = CubeAnimationTypeHorizontal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overwrite UINavigationController methods

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    pushingVC=YES;
    
    if (animated) {
        
        UIViewController *currentVC = [self visibleViewController];
        
        UIImageView *fromImageView = [currentVC.view imageInNavController:self];
        
        //Issue with autosizing, we nned to set the frame before take the image
        [viewController.view setFrame:currentVC.view.frame];    //Resize new view manually
        UIImageView *toImageView = [viewController.view imageInNavController:self];
        
        [currentVC.view setAlpha:0.0];
        
        [self makeCubeAnimationFrom:fromImageView to:toImageView direction:self.cubeAnimationType withCompletion:^{
            
            //Do the push
            [super pushViewController:viewController animated:NO];
            
            [currentVC.view setAlpha:1.0];
            
        }];
    }else{
        [super pushViewController:viewController animated:NO];
    }
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    pushingVC=NO;
    
    //Find the previous vc in stack
    if([self.viewControllers count]>1){
        if (animated) {
            UIViewController *currentVC = [self visibleViewController];
            
            UIImageView *fromImageView = [currentVC.view imageInNavController:self];
            
            int index = [self.viewControllers indexOfObject:currentVC];
            
            if (index>0) {
                
                //Issue with autosizing, we nned to set the frame before take the image
                UIViewController *toViewController = [self.viewControllers objectAtIndex:index-1];
                [toViewController.view setFrame:currentVC.view.frame];    //Resize new view manually
                UIImageView *toImageView = [toViewController.view imageInNavController:self];
                
                [currentVC.view setAlpha:0.0];
                
                __block UIViewController *returnedVC;
                [self makeCubeAnimationFrom:fromImageView to:toImageView direction:self.cubeAnimationType withCompletion:^{
                    
                    returnedVC = [super popViewControllerAnimated:NO];
                    
                }];
                
                return returnedVC;
            }else{
                return [super popViewControllerAnimated:NO];
            }
            
        }else{
            return [super popViewControllerAnimated:NO];
        }
    }else{
        return [super popViewControllerAnimated:animated];
    }
    
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    pushingVC=NO;
    
    //Find the root view controller
    if([self.viewControllers count]>1){
        if (animated) {
            UIViewController *currentVC = [self visibleViewController];
            UIViewController *rootVC = [self.viewControllers objectAtIndex:0];
            
            //Issue with autosizing, we nned to set the frame before take the image
            [rootVC.view setFrame:currentVC.view.frame];    //Resize new view manually
            
            UIImageView *fromImageView = [currentVC.view imageInNavController:self];
            UIImageView *toImageView = [rootVC.view imageInNavController:self];
            
            [currentVC.view setAlpha:0.0];
            
            __block NSArray *stackVCs;
            [self makeCubeAnimationFrom:fromImageView to:toImageView direction:self.cubeAnimationType withCompletion:^{
                
                stackVCs = [super popToRootViewControllerAnimated:NO];
            }];
            
            return stackVCs;
            
        }else{
            return [super popToRootViewControllerAnimated:NO];
        }
    }else{
        return [super popToRootViewControllerAnimated:animated];
    }
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    pushingVC=NO;
    
    //Find the root view controller
    if([self.viewControllers count]>1){
        if (animated) {
            UIViewController *currentVC = [self visibleViewController];
            
            //Issue with autosizing, we nned to set the frame before take the image
            [viewController.view setFrame:currentVC.view.frame];    //Resize new view manually
            
            UIImageView *fromImageView = [currentVC.view imageInNavController:self];
            UIImageView *toImageView = [viewController.view imageInNavController:self];
            
            [currentVC.view setAlpha:0.0];
            
            __block NSArray *stackVCs;
            [self makeCubeAnimationFrom:fromImageView to:toImageView direction:self.cubeAnimationType withCompletion:^{
                
                stackVCs = [super popToViewController:viewController animated:NO];
            }];
            
            return stackVCs;
            
        }else{
            return [super popToViewController:viewController animated:NO];
        }
    }else{
        return [super popToViewController:viewController animated:animated];
    }
}


#pragma mark - Cube animating methods
/**
 Function that creates the cube animation transition between fromImage and toImage
 */
- (void) makeCubeAnimationFrom: (UIImageView *) fromImage to: (UIImageView *) toImage direction: (CubeAnimationType) animationType withCompletion: (void(^)(void))completion
{
    //We need to calculate the animation direcction
    int dir=pushingVC?1:-1;
    
    //We create a content view for do the translate animation
    UIView *generalContentView = [[UIView alloc] initWithFrame:self.view.bounds];
    
    //Crete the differents 3D animations
    CATransform3D viewFromTransform;
    CATransform3D viewToTransform;
    
    switch (animationType) {
        case CubeAnimationTypeHorizontal:
            viewFromTransform = CATransform3DMakeRotation(dir*ROTATION_ANGLE, 0.0, 1.0, 0.0);
            viewToTransform = CATransform3DMakeRotation(-dir*ROTATION_ANGLE, 0.0, 1.0, 0.0);
            [toImage.layer setAnchorPoint:CGPointMake(pushingVC?0:1, 0.5)];
            [fromImage.layer setAnchorPoint:CGPointMake(pushingVC?1:0, 0.5)];
            
            [generalContentView setTransform:CGAffineTransformMakeTranslation(dir*(generalContentView.frame.size.width)/2.0, 0)];
            break;
            
        case CubeAnimationTypeVertical:
            viewFromTransform = CATransform3DMakeRotation(-dir*ROTATION_ANGLE, 1.0, 0.0, 0.0);
            viewToTransform = CATransform3DMakeRotation(dir*ROTATION_ANGLE, 1.0, 0.0, 0.0);
            [toImage.layer setAnchorPoint:CGPointMake(0.5, pushingVC?0:1)];
            [fromImage.layer setAnchorPoint:CGPointMake(0.5, pushingVC?1:0)];
            
            [generalContentView setTransform:CGAffineTransformMakeTranslation(0, dir*(generalContentView.frame.size.height-[self calculateYPosition])/2.0)];
            break;
            
        default:
            break;
    }
    
    viewFromTransform.m34 = PERSPECTIVE;
    viewToTransform.m34 = PERSPECTIVE;
    
    toImage.layer.transform = viewToTransform;
    
    //Add the subviews
    [generalContentView addSubview:fromImage];
    [generalContentView addSubview:toImage];
    [self.view addSubview:generalContentView];
    
    //Create the shadow
    UIView *fromShadow = [fromImage addOpacityWithColor:[UIColor blackColor]];
    UIView *toShadow = [toImage addOpacityWithColor:[UIColor blackColor]];
    
    [fromShadow setAlpha:0.0];
    [toShadow setAlpha:1.0];
        
    //Make the animation
    [UIView animateWithDuration:TIME_ANIMATION animations:^{
        
        switch (animationType) {
            case CubeAnimationTypeHorizontal:
                [generalContentView setTransform:CGAffineTransformMakeTranslation(-dir*generalContentView.frame.size.width/2.0, 0)];
                break;
                
            case CubeAnimationTypeVertical:
                [generalContentView setTransform:CGAffineTransformMakeTranslation(0, -dir*(generalContentView.frame.size.height-[self calculateYPosition])/2.0)];
                break;
                
            default:
                break;
        }
        
        fromImage.layer.transform = viewFromTransform;
        toImage.layer.transform = CATransform3DIdentity;
        
        [fromShadow setAlpha:1.0];
        [toShadow setAlpha:0.0];
        
    }completion:^(BOOL finished) {
                
        [fromImage removeFromSuperview];
        [toImage removeFromSuperview];
        
        [generalContentView removeFromSuperview];
        
        completion();
    }];
}

@end
