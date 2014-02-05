ABCustomUINavigationController
=====================
[![License MIT](https://go-shields.herokuapp.com/license-MIT-blue.png)](https://github.com/andresbrun/ABCustomUINavigationController/blob/master/LICENSE)
[![Build Platform](https://cocoapod-badges.herokuapp.com/p/ABCustomUINavigationController/badge.png)](https://github.com/andresbrun/ABCustomUINavigationController)
[![Build Version](https://cocoapod-badges.herokuapp.com/v/ABCustomUINavigationController/badge.png)](https://github.com/andresbrun/ABCustomUINavigationController)
[![Build Status](https://travis-ci.org/andresbrun/ABCustomUINavigationController.png?branch=origin)](https://github.com/andresbrun/ABCustomUINavigationController) 
[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/andresbrun/abcustomuinavigationcontroller/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

Subclass of UINavigationController for overwriting push and pop methods to create new transitions effects. Currently it has been implemented two transition animations:

### SquaresFlip 
The screen is split in squares and each one rotates until showing the new controller. It has two animation variation: 
- Randomly 
- Horizontally

### Cube effect
The views are showns in differents cube's faces. It has two animation variation: 
- Horizontal 
- vertical

## Use
For using that component you only have to copy the SquaresFlipNavigation folder into your project and create the navigation controller as:

    import "FlipSquaresNavigationController.h"
    [[FlipSquaresNavigationController alloc] initWithRootViewController:self.viewController];
    
or

    #import "CubeNavigationController.h"
    [[CubeNavigationController alloc] initWithRootViewController:self.viewController];
  
and pushing and pop normally with navigation methods:

    - (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
    - (UIViewController *)popViewControllerAnimated:(BOOL)animated
    - (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
    - (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated

It works with every screen size in iPhone and iPad. Also it supports rotations. And it supports Statusbar, NavigationBar and NavigationToolbar.

## Requirements
This component need these two frameworks to work:
- QuartCore.framework 
- CoreGraphic.framework

## Examples

### SquaresFlip
![alt tag](https://raw.github.com/andresbrun/SquaresFlipNavigation/origin/example_images/example.gif)
### Cube
![alt tag](https://raw.github.com/andresbrun/SquaresFlipNavigation/origin/example_images/example_cube.gif)

