//
//  NSNumber+ABGenerator.m
//  ABCustomUINavigationController
//
//  Created by Andres Brun Moreno on 28/02/15.
//  Copyright (c) 2015 Andrés Brun. All rights reserved.
//


#import "NSNumber+ABGenerator.h"

#define ARC4RANDOM_MAX 0x100000000

@implementation NSNumber (ABGenerator)

+ (CGFloat) getRandomFloat01 {
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

@end
