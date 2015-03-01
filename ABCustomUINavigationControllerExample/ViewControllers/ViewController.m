//
//  ViewController.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 7/14/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirthViewController.h"
#import "FlipSquaresNavigationController.h"

@interface ViewController ()
- (IBAction)pushViewController:(id)sender;
@end

@implementation ViewController

- (id)initViewController {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self = [[ViewController alloc] initWithNibName:@"ViewController_iPhone" bundle:nil];
    } else {
        self = [[ViewController alloc] initWithNibName:@"ViewController_iPad" bundle:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotate {
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (IBAction)pushViewController:(id)sender {
    SecondViewController *secondVC = [[SecondViewController alloc] initViewController];
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (IBAction)pushToThirthViewController:(id)sender {
    ThirthViewController *thirthVC = [[ThirthViewController alloc] initViewController];
    [self.navigationController pushViewController:thirthVC animated:YES];
}

@end
