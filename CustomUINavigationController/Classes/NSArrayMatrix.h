//
//  NSArrayMatrix.h
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 28/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

@interface NSArrayMatrix : NSObject

@property(nonatomic, assign, readonly) NSUInteger rows;
@property(nonatomic, assign, readonly) NSUInteger columns;
@property(nonatomic, strong, readonly) NSMutableArray *elements;

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns;

- (void) fillWithOrderData;
- (void) iterateOverElementsWithBlock: (void (^)(NSUInteger row, NSUInteger col))iterationBlock;

- (void) randomize;
- (void) sortRightScanning;
- (void) sortLeftScanning;

@end
