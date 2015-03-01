//
//  GridBaseAnimator.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 28/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "GridBaseAnimator.h"

#import "NSArrayMatrix.h"
#import "UIView+ABExtras.h"
#import "NSObject+ABExtras.h"
#import "NSNumber+ABGenerator.h"

@interface GridBaseAnimator ()
@property(nonatomic, strong) NSMutableArray *fromViewImagesArray;
@property(nonatomic, strong) NSMutableArray *toViewImagesArray;

@property(nonatomic,strong) NSArrayMatrix *orderMatrix;

@property (nonatomic,copy)void (^completionBlock)();
@end

@implementation GridBaseAnimator

- (NSUInteger)rowsNumber {
    return 25;
}

- (NSUInteger)columnsNumber {
    return 28;
}

- (void)animateWithCompletion:(void (^)(void))completion {
    self.completionBlock = completion;
    
    [self setUpOrderMatrix];
    
    [self createGridViews];
    [self addFromGridViewsToContainer];
    
    CGFloat maxDelay = [self doAnimation];
    
    [self finishAnimationWithDelay:maxDelay];
    
}

- (void)setUpOrderMatrix {
    self.orderMatrix = [[NSArrayMatrix alloc] initWithRows:self.rowsNumber columns:self.columnsNumber];
    [self.orderMatrix fillWithOrderData];
    
    [self shuffleOrderMatrix];
}

- (void)shuffleOrderMatrix {
    switch (self.sortMethod) {
        case FSNavSortMethodRandom:
            [self.orderMatrix randomize];
            break;
        case FSNavSortMethodHorizontal:
            if (self.presenting) {
                [self.orderMatrix sortRightScanning];
            } else {
                [self.orderMatrix sortLeftScanning];
            }
            break;
    }
}

- (void)createGridViews {
    self.fromViewImagesArray = [NSMutableArray array];
    self.toViewImagesArray = [NSMutableArray array];
    
    [self.orderMatrix iterateOverElementsWithBlock:^(NSUInteger row, NSUInteger col) {
        CGRect croppedRect = [self gridCellRectForRow:row column:col];
        UIView *fromViewCrop = [[self.fromView viewByCroppingInRect:croppedRect] embedView];
        UIView *toViewCrop = [[self.toView viewByCroppingInRect:croppedRect] embedView];
        
        [self.fromViewImagesArray addObject:fromViewCrop];
        [self.toViewImagesArray addObject:toViewCrop];
    }];
}

- (CGRect)gridCellRectForRow:(NSUInteger)row column:(NSUInteger)column {
    float rowsWidth = self.fromView.frame.size.width / self.orderMatrix.rows;
    float columnsHeight = self.fromView.frame.size.height / self.orderMatrix.columns;
    CGRect croppedRect = CGRectMake(row*rowsWidth,
                                    column*columnsHeight,
                                    rowsWidth,
                                    columnsHeight);
    return croppedRect;
}

- (void)addFromGridViewsToContainer {
    for (UIView *currentView in self.fromViewImagesArray) {
        [self.containerView addSubview:currentView];
    }
}

- (CGFloat)doAnimation {
    float maxDelay=0;
    for (NSNumber *currentPos in self.orderMatrix.elements) {
        NSInteger posIndex = [self.orderMatrix.elements indexOfObject:currentPos];
        UIView *fromViewCrop = [self.fromViewImagesArray objectAtIndex:[currentPos intValue]];
        UIView *toViewCrop = [self.toViewImagesArray objectAtIndex:[currentPos intValue]];
        NSTimeInterval delay = [self calculateDelayForIndex:posIndex];
        
        maxDelay = MAX(delay, maxDelay);
        [self performBlock:^{
            [self animateFromCellView:fromViewCrop toCellView:toViewCrop inTime:self.animationDuration*0.3];
        } afterDelay:delay];
    }
    
    return maxDelay;
}

- (NSTimeInterval)calculateDelayForIndex:(NSUInteger)posIndex {
    //we "order" the delays for sort the animation in time
    float positionPercent = posIndex / ([self.orderMatrix.elements count]*1.0);
    //Random + Fix -> MAX 70% of TIME_ANIMATION
    float delay = [NSNumber getRandomFloat01]*self.animationDuration*0.4*positionPercent + self.animationDuration*0.3*positionPercent;
    
    return delay;
}

-(void)animateFromCellView:(UIView *)fromCell toCellView:(UIView *)toCell inTime:(NSTimeInterval)time {
    NSAssert(YES, @"This methos has to be inherated in order to get some animation");
}

- (void)finishAnimationWithDelay:(CGFloat)maxDelay {
    NSTimeInterval safesDelay = maxDelay+self.animationDuration*0.5;
    //Perform the completion when the animation is finished. Calculate that with the 50% remain of TIME_ANIMATION
    [self performBlock:^{
        [self releaseImagesArray];
        self.completionBlock();
    } afterDelay:safesDelay];
}

#pragma mark - Auxiliar methods
- (void) releaseImagesArray {
    //Clean the others views
    for (UIImageView *currentView in self.fromViewImagesArray) {
        [[currentView getEmbeddedView] removeFromSuperview];
        [currentView removeFromSuperview];
    }
    for (UIImageView *currentView in self.toViewImagesArray) {
        [UIView animateWithDuration:0.1 animations:^{
            [currentView setAlpha:0.0];
        }completion:^(BOOL finished) {
            [[currentView getEmbeddedView] removeFromSuperview];
            [currentView removeFromSuperview];
        }];
    }
    
    [self.fromViewImagesArray removeAllObjects];
}

@end
