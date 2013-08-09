//
//  FlipSquaresNavigationController.h
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 7/14/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {FSNavSortMethodRandom, FSNavSortMethodHorizontal} FSNavSortMethod;

@interface FlipSquaresNavigationController : UINavigationController

@property (nonatomic, assign) FSNavSortMethod sortMethod;

@end
