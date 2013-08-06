//
//  ViewController.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 7/14/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "ViewController_iPad.h"
#import "SecondViewController_iPad.h"
#import "ThirthViewController_iPad.h"
#import "FlipSquaresNavigationController.h"

@interface ViewController_iPad ()
- (IBAction)pushViewController:(id)sender;
@end

@implementation ViewController_iPad

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushViewController:(id)sender {
    SecondViewController_iPad *secondVC = [[SecondViewController_iPad alloc] initWithNibName:@"SecondViewController" bundle:nil];
    [self.navigationController pushViewController:secondVC animated:YES];
}
- (IBAction)pushToThirthViewController:(id)sender {
    ThirthViewController_iPad *thirthVC = [[ThirthViewController_iPad alloc] initWithNibName:@"ThirthViewController" bundle:nil];
    [self.navigationController pushViewController:thirthVC animated:YES];
}

@end
