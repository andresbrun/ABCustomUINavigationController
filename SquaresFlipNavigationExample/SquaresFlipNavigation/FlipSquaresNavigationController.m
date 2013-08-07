//
//  FlipSquaresNavigationController.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 7/14/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "FlipSquaresNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSObject+Extras.h"

#define TAG_IMAGE_VIEW 999
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

- (CAGradientLayer *)addLinearGradientToView:(UIView *)theView withColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque;

//Auxiliar methods
- (UIImageView *) imageWithView:(UIView *)view;
- (UIImageView *) createCrop: (CGRect) crop withImage: (UIImageView *)imageView;
- (NSMutableArray *) shuffleArray: (NSMutableArray *)array;
- (NSMutableArray *) sortFrom: (BOOL) leftToRight array: (NSMutableArray *) array;
- (NSMutableArray *) sortRandomArray:(NSMutableArray *)array;
- (float) getRandomFloat01;
- (float) calculateYPosition;

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
	// Do any additional setup after loading the view.
    
    //[self setNavigationBarHidden:YES];
    //[self setToolbarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Overwrite UINAvigationController methods

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    pushingVC=YES;
    
    if (animated) {
        
        UIViewController *currentVC = [self visibleViewController];

        UIImageView *currentView = [self imageWithView: currentVC.view];
        
        //Issue with autosizing, we nned to set the frame before take the image
        [viewController.view setFrame:currentVC.view.frame];    //Resize new view manually
        UIImageView *newView = [self imageWithView: viewController.view];
        
        [currentVC.view setAlpha:0.0];
        
        [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromLeft withCompletion:^{
            
            //Do the push
            [super pushViewController:viewController animated:NO];
            
            //Clean the others views
            [self releaseImagesArray];
            
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
            
            UIImageView *currentView = [self imageWithView: currentVC.view];
            
            int index = [self.viewControllers indexOfObject:currentVC];
            
            if (index>0) {
                
                //Issue with autosizing, we nned to set the frame before take the image
                UIViewController *toViewController = [self.viewControllers objectAtIndex:index-1];
                [toViewController.view setFrame:currentVC.view.frame];    //Resize new view manually
                UIImageView *newView = [self imageWithView: toViewController.view];
                
                [currentVC.view setAlpha:0.0];
                
                __block UIViewController *returnedVC;
                [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromRight withCompletion:^{
                    
                    //Clean the others views
                    [self releaseImagesArray];
                    
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
            
            UIImageView *currentView = [self imageWithView: currentVC.view];
            UIImageView *newView = [self imageWithView: rootVC.view];
            
            [currentVC.view setAlpha:0.0];
            
            __block NSArray *stackVCs;
            [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromRight withCompletion:^{
                
                //Clean the others views
                [self releaseImagesArray];
                
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
            
            UIImageView *currentView = [self imageWithView: currentVC.view];
            UIImageView *newView = [self imageWithView: viewController.view];
            
            [currentVC.view setAlpha:0.0];
            
            __block NSArray *stackVCs;
            [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromRight withCompletion:^{
                
                //Clean the others views
                [self releaseImagesArray];
                
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
            UIView *fromView = [self createViewWithImageView:[self createCrop:CGRectMake(row*rowsWidth,
                                                                                         col*columnsHeight,
                                                                                         rowsWidth,
                                                                                         columnsHeight)
                                                                    withImage:fromImage]];
            UIView *toView = [self createViewWithImageView:[self createCrop:CGRectMake(row*rowsWidth,
                                                                                       col*columnsHeight,
                                                                                       rowsWidth,
                                                                                       columnsHeight)
                                                                  withImage:toImage]];
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
            
            CAGradientLayer *fromGradient = [self addLinearGradientToView:fromViewCrop withColor:[UIColor blackColor] transparentToOpaque:YES];
            CAGradientLayer *toGradient = [self addLinearGradientToView:fromViewCrop withColor:[UIColor blackColor] transparentToOpaque:YES];
            
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
        completion();
    } afterDelay:maxDelay+TIME_ANIMATION*0.3];

}

#pragma mark - Images methods

- (UIImageView *) imageWithView:(UIView *)view
{    
    [view.layer setContentsScale:[[UIScreen mainScreen] scale]];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *currentView = [[UIImageView alloc] initWithImage: img];
    
    //Fix the position to handle status bar and navigation bar
    float yPosition = [self calculateYPosition];
    //float yPosition = self.view.frame.size.height - view.frame.size.height;
    [currentView setFrame:CGRectMake(0, yPosition, currentView.frame.size.width, currentView.frame.size.height)];
    
    return currentView;
}

- (UIImageView *) createCrop: (CGRect) crop withImage: (UIImageView *)imageView
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageView.image.CGImage, crop);
    UIImageView *imageViewCropped = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageRef]];
    [imageViewCropped setFrame:crop];
    
    [imageViewCropped setFrame:CGRectMake(imageViewCropped.frame.origin.x,
                                          imageViewCropped.frame.origin.y+imageView.frame.origin.y,
                                          imageViewCropped.frame.size.width,
                                          imageViewCropped.frame.size.height)];
    CGImageRelease(imageRef);
    return imageViewCropped;
}

- (CAGradientLayer *)addLinearGradientToView:(UIView *)theView withColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    //the gradient layer must be positioned at the origin of the view
    CGRect gradientFrame = theView.frame;
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
    
    [theView.layer insertSublayer:gradient atIndex:0];
    
    return gradient;
}

- (UIView *)createViewWithImageView: (UIImageView *)imageView
{
    UIView *newView = [[UIView alloc] initWithFrame:imageView.frame];
    [imageView setTag:TAG_IMAGE_VIEW];
    [imageView setFrame:imageView.bounds];
    [newView addSubview:imageView];
    
    return newView;
}

#pragma mark - Auxiliar methods
- (float) getRandomFloat01
{
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

- (float) calculateYPosition
{
    float yPosition=0;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (!self.navigationBarHidden) {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
            yPosition += self.navigationBar.frame.size.height;
        }else{
            yPosition += self.navigationBar.frame.size.width;
        }
    }
    
    if (![UIApplication sharedApplication].statusBarHidden){
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)){
            yPosition += [UIApplication sharedApplication].statusBarFrame.size.height;
        }else{
            yPosition += [UIApplication sharedApplication].statusBarFrame.size.width;
        }
    }
    
    return yPosition;
    
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
