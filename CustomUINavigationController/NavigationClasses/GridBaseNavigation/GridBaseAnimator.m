//
//  GridBaseAnimator.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 28/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "GridBaseAnimator.h"

#import "UIView+ABExtras.h"
#import "NSObject+ABExtras.h"
#import "NSNumber+ABGenerator.h"

#import "NSArrayMatrix.h"

@interface GridBaseAnimator ()
@property(nonatomic, strong) NSMutableArray *fromGridCellViewArray;
@property(nonatomic, strong) NSMutableArray *toGridCellViewArray;
@property(nonatomic, strong) NSArrayMatrix *orderMatrix;

@property (nonatomic,copy)void (^completionBlock)();
@end

@implementation GridBaseAnimator

- (NSUInteger)rowsNumber {
    return 5;
}

- (NSUInteger)columnsNumber {
    return 5;
}

- (void)animateWithCompletion:(void (^)(void))completion {
    self.completionBlock = completion;
    
    [self setUpOrderMatrix];
    [self startOperationsToAnimate];
}

- (void)startOperationsToAnimate {
    NSInvocationOperation *createGridOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(createGridViews) object:nil];
    [createGridOperation setQualityOfService:NSQualityOfServiceBackground];
    
    NSInvocationOperation *prepareEnvironmentOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(prepareEnvironment) object:nil];
    [prepareEnvironmentOperation setQualityOfService:NSQualityOfServiceBackground];
    [prepareEnvironmentOperation addDependency:createGridOperation];
    
    NSInvocationOperation *animateOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(animate) object:nil];
    [animateOperation setQualityOfService:NSQualityOfServiceUserInteractive];
    [animateOperation addDependency:prepareEnvironmentOperation];
    
    [[NSOperationQueue mainQueue] addOperations:@[createGridOperation, prepareEnvironmentOperation, animateOperation] waitUntilFinished:NO];
}

- (void)createGridViews {
    self.fromGridCellViewArray = [NSMutableArray array];
    self.toGridCellViewArray = [NSMutableArray array];
    
    [self.orderMatrix iterateOverElementsWithBlock:^(NSUInteger row, NSUInteger col) {
        CGRect croppedRect = [self gridCellRectForRow:row column:col];

        UIView *fromViewCrop = [self createCellForView:self.fromView withRect:croppedRect];
        UIView *toViewCrop = [self createCellForView:self.toView withRect:croppedRect];

        [self.fromGridCellViewArray addObject:fromViewCrop];
        [self.toGridCellViewArray addObject:toViewCrop];
    }];
}

- (UIView *) createCellForView:(UIView *)view withRect:(CGRect)croppedRect {
    UIView *viewCropped = [[view viewByCroppingInRect:croppedRect] embedView];
    [viewCropped setFrame:croppedRect];
    return viewCropped;
}

- (void)setUpOrderMatrix {
    self.orderMatrix = [[NSArrayMatrix alloc] initWithRows:self.rowsNumber columns:self.columnsNumber];
    [self.orderMatrix fillWithOrderData];
    
    [self shuffleOrderMatrix];
}

- (void)prepareEnvironment {
    [self addFromGridViewsToContainer];
    [self hideSourceView];
}

- (void)animate {
    [self doAnimationWithCompletion:^{
        [self finishAnimation];
    }];
}

- (void)shuffleOrderMatrix {
    switch (self.sortMethod) {
        case ScanningSortMethodRandom:
            [self.orderMatrix randomize];
            break;
        case ScanningSortMethodHorizontal:
            if (self.presenting) {
                [self.orderMatrix sortRightScanning];
            } else {
                [self.orderMatrix sortLeftScanning];
            }
            break;
    }
}

- (CGRect)gridCellRectForRow:(NSUInteger)row column:(NSUInteger)column {
    float rowsWidth = self.fromView.frame.size.width / self.orderMatrix.rows;
    float columnsHeight = self.fromView.frame.size.height / self.orderMatrix.columns;
    CGRect croppedRect = CGRectMake(row * rowsWidth,
                                    column * columnsHeight,
                                    rowsWidth,
                                    columnsHeight);
    return croppedRect;
}

- (void)hideSourceView {
    [self.fromView setHidden:YES];
}

- (void)restoreSourceView {
    [self.fromView setHidden:NO];
}

- (void)addFromGridViewsToContainer {
    for (UIView *currentView in self.fromGridCellViewArray) {
        [self.containerView addSubview:currentView];
    }
}

- (void)doAnimationWithCompletion:(void(^)(void))completion {
    float cellAnimationTime = self.animationDuration*0.3;
    
    for (NSNumber *currentPos in self.orderMatrix.elements) {
        NSInteger posIndex = [self.orderMatrix.elements indexOfObject:currentPos];
        UIView *fromViewCrop = [self.fromGridCellViewArray objectAtIndex:[currentPos intValue]];
        UIView *toViewCrop = [self.toGridCellViewArray objectAtIndex:[currentPos intValue]];
        NSTimeInterval delay = [self calculateDelayForIndex:posIndex];
        
        [self performBlock:^{
            [self animateFromCellView:fromViewCrop toCellView:toViewCrop inTime:cellAnimationTime];
        } afterDelay:delay];
    }
    
    [self performBlock:^{
        completion();
    } afterDelay:self.animationDuration];
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

- (void)finishAnimation {
    [self removeCellViews];
    [self restoreSourceView];
    self.completionBlock();
}

#pragma mark - Auxiliar methods
- (void) removeCellViews {
    for (UIImageView *currentView in self.fromGridCellViewArray) {
        [[currentView getEmbeddedView] removeFromSuperview];
        [currentView removeFromSuperview];
    }
    for (UIImageView *currentView in self.toGridCellViewArray) {
        [UIView animateWithDuration:0.1 animations:^{
            [currentView setAlpha:0.0];
        }completion:^(BOOL finished) {
            [[currentView getEmbeddedView] removeFromSuperview];
            [currentView removeFromSuperview];
        }];
    }
    
    [self.fromGridCellViewArray removeAllObjects];
    [self.toGridCellViewArray removeAllObjects];
}

@end
