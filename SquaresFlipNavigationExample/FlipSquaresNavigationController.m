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

#define SQUARE_ROWS 7
#define SQUARE_COLUMNS 5
#define TAG_IMAGE_VIEW 999

#define TIME_ANIMATION 1.0

#define ARC4RANDOM_MAX      0x100000000

@interface FlipSquaresNavigationController (){
    NSMutableArray *fromViewImagesArray;
    NSMutableArray *toViewImagesArray;
    
}

- (void) makeSquaresFlipAnimationFrom: (UIImageView *) fromImage to: (UIImageView *) toImage option: (UIViewAnimationOptions) options withCompletion: (void(^)(void))completion;

- (float) getRandomFloat01;

@end

@implementation FlipSquaresNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (animated) {
        UIViewController *currentVC = [self visibleViewController];

        UIImageView *currentView = [self imageWithView: currentVC.view];
        
        UIImageView *newView = [self imageWithView: viewController.view];
        
        //[UIView animateWithDuration:0.1 animations:^{
        [currentVC.view setAlpha:0.0];
        //}];
        
        [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromLeft withCompletion:^{
            [super pushViewController:viewController animated:NO];
            
            //Clean the others view
            for (UIImageView *currentView in fromViewImagesArray) {
                [currentView removeFromSuperview];
            }
            for (UIImageView *currentView in toViewImagesArray) {
                [UIView animateWithDuration:0.1 animations:^{
                    [currentView setAlpha:0.0];
                }completion:^(BOOL finished) {
                    [currentView removeFromSuperview];
                }];

            }
            [currentVC.view setAlpha:1.0];
        }];
    }else{
        [super pushViewController:viewController animated:NO];
    }
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    //Find the preious vc in stack
    if([self.viewControllers count]>1){
        if (animated) {
            UIViewController *currentVC = [self visibleViewController];
            
            UIImageView *currentView = [self imageWithView: currentVC.view];
            
            UIImageView *newView = [self imageWithView: ((UIViewController *)[self.viewControllers objectAtIndex:0]).view];
            
            //[UIView animateWithDuration:0.1 animations:^{
            [currentVC.view setAlpha:0.0];
            //}];
            
            __block UIViewController *returnedVC;
            [self makeSquaresFlipAnimationFrom:currentView to:newView option:UIViewAnimationOptionTransitionFlipFromRight withCompletion:^{
                
                //Clean the others view
                for (UIImageView *currentViewR in fromViewImagesArray) {
                    [currentViewR removeFromSuperview];
                }
                for (UIImageView *currentViewR in toViewImagesArray) {
                    [UIView animateWithDuration:0.3 animations:^{
                        [currentViewR setAlpha:0.0];
                    }completion:^(BOOL finished) {
                        [currentViewR removeFromSuperview];
                    }];
                    
                }
                
                returnedVC = [super popViewControllerAnimated:NO];

            }];
            
            return returnedVC;
            
        }else{
            return [super popViewControllerAnimated:NO];
        }
    }else{
        return [super popViewControllerAnimated:NO];
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
    
    //Create theimages
    
    for (int row=0; row<SQUARE_ROWS; row++) {
        for (int col=0; col<SQUARE_COLUMNS; col++) {
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
    [self shuffleArray:orderArray];
    
    float maxDelay=0;
    for (NSNumber *currentPos in orderArray) {
    //NSNumber *currentPos= [[NSNumber alloc] initWithInt:10];
        UIView *fromViewCrop = [fromViewImagesArray objectAtIndex:[currentPos intValue]];
        UIView *toViewCrop = [toViewImagesArray objectAtIndex:[currentPos intValue]];
    
        float delay = [self getRandomFloat01]*TIME_ANIMATION*0.7;
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
    
    [self performBlock:^{
        completion();
    } afterDelay:maxDelay+TIME_ANIMATION*0.3];

}

#pragma mark - Images methods
- (UIImageView *) imageWithView:(UIView *)view
{
    [view setContentScaleFactor:2.0];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 1.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *currentView = [[UIImageView alloc] initWithImage: img];
    
    float yPosition = self.view.frame.size.height - view.frame.size.height;
    [currentView setFrame:CGRectMake(0, yPosition, currentView.frame.size.width, currentView.frame.size.height)];
    
    return currentView;
}

- (UIImageView *) createCrop: (CGRect) crop withImage: (UIImageView *)imageView
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageView.image.CGImage, crop);
    // or use the UIImage wherever you like
    UIImageView *imageViewCropped = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:imageRef]];
    [imageViewCropped setFrame:crop];
    
    [imageViewCropped setFrame:CGRectMake(imageViewCropped.frame.origin.x,
                                          imageViewCropped.frame.origin.y+imageView.frame.origin.y,
                                          imageViewCropped.frame.size.width,
                                          imageViewCropped.frame.size.height)];
    
    return imageViewCropped;
}

#pragma mark - Auxiliar methods
- (void)shuffleArray: (NSMutableArray *)array
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
}

- (UIView *)createViewWithImageView: (UIImageView *)imageView
{
    UIView *newView = [[UIView alloc] initWithFrame:imageView.frame];
    [imageView setTag:TAG_IMAGE_VIEW];
    [imageView setFrame:imageView.bounds];
    [newView addSubview:imageView];
    
//    [newView.layer setCornerRadius:2.0];
//    [newView.layer setBorderWidth:0.5];
//    [newView.layer setBorderColor:[UIColor grayColor].CGColor];
    
    return newView;
}

- (float) getRandomFloat01
{
    return ((double)arc4random() / ARC4RANDOM_MAX);
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
    if(transparentToOpaque)
    {
        colors = [[colors reverseObjectEnumerator] allObjects];
    }
    
    //apply the colors and the gradient to the view
    gradient.colors = colors;
        
    [theView.layer insertSublayer:gradient atIndex:0];
    
    return gradient;
}

@end
