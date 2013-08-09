//
//  FlipSquaresNavigationController.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 7/14/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "FlipSquaresNavigationController.h"
#import <QuartzCore/QuartzCore.h>

#import "NSObject+ABExtras.h"
#import "UIImageView+ABExtras.h"
#import "UIView+ABExtras.h"
#import "UINavigationController+ABExtras.h"

#define ARC4RANDOM_MAX 0x100000000

//Configure params
#define SQUARE_ROWS 5
#define SQUARE_COLUMNS 8
#define TIME_ANIMATION 1.0

@interface FlipSquaresNavigationController (){
    NSMutableArray *fromViewImagesArray;
    NSMutableArray *toViewImagesArray;
    BOOL pushingVC;
}

- (void) makeSquaresFlipAnimationFrom: (UIImageView *) fromImage to: (UIImageView *) toImage option: (UIViewAnimationOptions) options withCompletion: (void(^)(void))completion;

//Array methods
- (NSMutableArray *) shuffleArray: (NSMutableArray *)array;
- (NSMutableArray *) sortFrom: (BOOL) leftToRight array: (NSMutableArray *) array;
- (NSMutableArray *) sortRandomArray:(NSMutableArray *)array;
- (float) getRandomFloat01;

//Aux methods
- (void) releaseImagesArray;

@end

@implementation FlipSquaresNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.sortMethod = FSNavSortMethodHorizontal;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        
        [self makeSquaresFlipAnimationFrom:fromImageView to:toImageView option:UIViewAnimationOptionTransitionFlipFromLeft withCompletion:^{
            
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
            
            UIImageView *currentView = [currentVC.view imageInNavController:self];
            
            int index = [self.viewControllers indexOfObject:currentVC];
            
            if (index>0) {
                
                //Issue with autosizing, we nned to set the frame before take the image
                UIViewController *toViewController = [self.viewControllers objectAtIndex:index-1];
                [toViewController.view setFrame:currentVC.view.frame];    //Resize new view manually
                UIImageView *newView = [toViewController.view imageInNavController:self];
                
                [currentVC.view setAlpha:0.0];
                
                __block UIViewController *returnedVC;
                [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromRight withCompletion:^{
                    
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
            
            UIImageView *currentView = [currentVC.view imageInNavController:self];
            UIImageView *newView = [rootVC.view imageInNavController:self];
            
            [currentVC.view setAlpha:0.0];
            
            __block NSArray *stackVCs;
            [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromRight withCompletion:^{
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
            
            UIImageView *currentView = [currentVC.view imageInNavController:self];
            UIImageView *newView = [viewController.view imageInNavController:self];
            
            [currentVC.view setAlpha:0.0];
            
            __block NSArray *stackVCs;
            [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromRight withCompletion:^{
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


#pragma mark - animate methods
- (void) makeSquaresFlipAnimationFrom: (UIImageView *) fromImage to: (UIImageView *) toImage option: (UIViewAnimationOptions) options withCompletion: (void(^)(void))completion
{
    fromViewImagesArray = [NSMutableArray array];
    toViewImagesArray = [NSMutableArray array];
    
    //Make the matrix and add the images
    float rowsWidth = fromImage.frame.size.width / SQUARE_ROWS;
    float columnsHeight = fromImage.frame.size.height / SQUARE_COLUMNS;
    
    //Create the cropped images
    
    for (int col=0; col<SQUARE_COLUMNS; col++) {
        for (int row=0; row<SQUARE_ROWS; row++) {
            CGRect currentRect = CGRectMake(row*rowsWidth,col*columnsHeight,rowsWidth,columnsHeight);
            UIView *fromView =[[fromImage createCrop:currentRect] createView];
            UIView *toView =[[toImage createCrop:currentRect] createView];

            [fromViewImagesArray addObject:fromView];
            [toViewImagesArray addObject:toView];
        }
    }
    
    //Add the images
    for (UIView *currentView in fromViewImagesArray) {
        [self.view addSubview:currentView];
    }
        
    //Create a array with all the number and unsort after
    NSMutableArray *orderArray = [NSMutableArray array];
    for (int i=0; i<[toViewImagesArray count]; i++) {
        [orderArray addObject:[NSNumber numberWithInt:i]];
    }
    
    orderArray=[self shuffleArray:orderArray];
    
    float maxDelay=0;
    for (NSNumber *currentPos in orderArray) {
        int posIndex = [orderArray indexOfObject:currentPos];
        
        UIView *fromViewCrop = [fromViewImagesArray objectAtIndex:[currentPos intValue]];
        UIView *toViewCrop = [toViewImagesArray objectAtIndex:[currentPos intValue]];
    
        //we "order" the delays for sort the animation in time
        float ratio = posIndex/([orderArray count]*1.0);
        float delay = [self getRandomFloat01]*TIME_ANIMATION*0.4*ratio + TIME_ANIMATION*0.3*ratio;//Random + Fix -> MAX 70% of TIME_ANIMATION
        //NSLog(@"PosIndex: %d Element: %d delay: %f", posIndex, [currentPos intValue], delay);
        maxDelay = MAX(delay, maxDelay);
        [self performBlock:^{
            
            CAGradientLayer *fromGradient = [fromViewCrop addLinearGradientWithColor:[UIColor blackColor] transparentToOpaque:YES];
            CAGradientLayer *toGradient = [fromViewCrop addLinearGradientWithColor:[UIColor blackColor] transparentToOpaque:YES];
            
            [fromGradient setOpacity:1.0];
            [toGradient setOpacity:0.0];
            [UIView animateWithDuration:TIME_ANIMATION*0.3 animations:^{
                [fromGradient setOpacity:0.0];
                [toGradient setOpacity:1.0];
            }];
            
            [UIView transitionFromView:[fromViewCrop viewWithTag:TAG_IMAGE_VIEW]
                                toView:[toViewCrop viewWithTag:TAG_IMAGE_VIEW]
                              duration:TIME_ANIMATION*0.3
                               options:options
                            completion:^(BOOL finished) {
                                
                            }];
        } afterDelay:delay];
        
    }
    
    //Perform the completion when the animation is finished. Calculate that with the 30% remain of TIME_ANIMATION
    [self performBlock:^{
        //Clean the others views
        [self releaseImagesArray];
        
        completion();
    } afterDelay:maxDelay+TIME_ANIMATION*0.3];

}


#pragma mark - Auxiliar methods
- (float) getRandomFloat01
{
    return ((double)arc4random() / ARC4RANDOM_MAX);
}


- (void) releaseImagesArray
{
    //Clean the others views
    for (UIImageView *currentView in fromViewImagesArray) {
        [[currentView viewWithTag:TAG_IMAGE_VIEW] removeFromSuperview];
        [currentView removeFromSuperview];
    }
    for (UIImageView *currentView in toViewImagesArray) {
        [UIView animateWithDuration:0.1 animations:^{
            [currentView setAlpha:0.0];
        }completion:^(BOOL finished) {
            [[currentView viewWithTag:TAG_IMAGE_VIEW] removeFromSuperview];
            [currentView removeFromSuperview];
        }];
    }
    
    [fromViewImagesArray removeAllObjects];
    [toViewImagesArray removeAllObjects];
}

#pragma mark - Sort Array methods
- (NSMutableArray *)shuffleArray: (NSMutableArray *)array
{
    switch (self.sortMethod) {
        case FSNavSortMethodRandom:{
            array=[self sortRandomArray:array];
        }break;
            
        case FSNavSortMethodHorizontal:
            array=[self sortFrom:pushingVC array:array];
            break;
            
        default:
            break;
    }
    return array;
}

/**
 Sort the elements randomly
 */
- (NSMutableArray *) sortRandomArray:(NSMutableArray *)array
{
    static BOOL seeded = NO;
    if(!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
    
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [array exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    return array;
}

/**
 Sort the elements for colums
 */
- (NSMutableArray *) sortFrom: (BOOL) leftToRight array: (NSMutableArray *) array
{
    NSMutableArray *sortedArray = [NSMutableArray array];
    
    //Get an array sort the elements by columns
    for (int index=0; index<[array count]; index++) {
        int auxPos = ((index%SQUARE_COLUMNS)*SQUARE_ROWS) + index/SQUARE_COLUMNS;       
        [sortedArray addObject:[array objectAtIndex:auxPos]];
    }
    
    if (leftToRight) {
        array = sortedArray;
    }else{
        array = [NSMutableArray arrayWithArray:[[sortedArray reverseObjectEnumerator] allObjects]];
    }
    
    return array;
}

@end
