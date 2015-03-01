//
//  NSArrayMatrix.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 28/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//

#import "NSArrayMatrix.h"

@interface NSArrayMatrix ()
@property(nonatomic, assign) NSUInteger rows;
@property(nonatomic, assign) NSUInteger columns;
@property(nonatomic, strong) NSMutableArray *elements;
@end

@implementation NSArrayMatrix

- (instancetype)initWithRows:(NSUInteger)rows columns:(NSUInteger)columns {
    self = [super init];
    if (self) {
        self.rows = rows;
        self.columns = columns;
        self.elements = [NSMutableArray array];
    }
    return self;
}

- (void) fillWithOrderData {
    for (int i=0; i<self.rows*self.columns; i++) {
        [self.elements addObject:[NSNumber numberWithInt:i]];
    }
}

- (void)iterateOverElementsWithBlock:(void (^)(NSUInteger, NSUInteger))iterationBlock {
    for (NSUInteger col=0; col<self.columns; col++) {
        for (NSUInteger row=0; row<self.rows; row++) {
            iterationBlock(row, col);
        }
    }
}

#pragma mark - Random methods
- (void)randomize {
    NSUInteger count = [self.elements count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        NSInteger nElements = count - i;
        NSInteger n = (random() % nElements) + i;
        [self.elements exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

- (void) sortRightScanning {
    NSMutableArray *sortedArray = [NSMutableArray array];
    
    //Get an array sort the elements by columns
    for (NSInteger index=0; index<[self.elements count]; index++) {
        NSInteger auxPos = ((index%self.columns) * self.rows) + index/self.columns;
        [sortedArray addObject:self.elements[auxPos]];
    }
    
    self.elements = sortedArray;
}

- (void) sortLeftScanning {
    [self sortRightScanning];
    self.elements = [NSMutableArray arrayWithArray:[[self.elements reverseObjectEnumerator] allObjects]];
}

@end
