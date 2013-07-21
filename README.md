SquaresFlipNavigation
=====================

Class inherate from UINavigationController for overwrite push and pop methods in order to create a new transition effect. The screen is split in squares and change every one for the new controller rotating it.

For using that component you only have to copy the SquaresFlipNavigation folder into your project and create the navigation controller as:

    import "FlipSquaresNavigationController.h"
    [[FlipSquaresNavigationController alloc] initWithRootViewController:self.viewController];
  
and pushing and pop normally:

    [self.navigationController pushViewController:self.secondVC animated:YES];
  
or
  
    [self.navigationController popViewControllerAnimated:YES];
  
We have just implemented these two methods, we'll implements the remaint methods in the near future.

Note: that component needs QuartCore.framework and CoreGraphic.framework to work.

## Example

![alt tag](https://raw.github.com/andresbrun/SquaresFlipNavigation/origin/example_images/example_1.png)
![alt tag](https://raw.github.com/andresbrun/SquaresFlipNavigation/origin/example_images/example_2.png)
![alt tag](https://raw.github.com/andresbrun/SquaresFlipNavigation/origin/example_images/example_3.png)
