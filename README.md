SquaresFlipNavigation
=====================

Class inherate from UINavigationController for overwrite push and pop methods in order to create a new transition effect. The screen is split in squares and change every one for the new controller rotating it.

For using that component you only have to copy the SquaresFlipNavigation folder into your project and create the navigation controller as:

    import "FlipSquaresNavigationController.h"
    [[FlipSquaresNavigationController alloc] initWithRootViewController:self.viewController];
  
and pushing and pop normally with navigation methods:

    - (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
    - (UIViewController *)popViewControllerAnimated:(BOOL)animated
    - (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
    - (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
  
Also it have differents ways to sort the squares animations:
- Randomly
- FromLeftToRight

##Requirements
This component need these two frameworks to work:
- QuartCore.framework 
- CoreGraphic.framework

##Limitations
It doesn't work fine with autosizing :(.

## Example

![alt tag](https://raw.github.com/andresbrun/SquaresFlipNavigation/origin/example_images/example.gif)

