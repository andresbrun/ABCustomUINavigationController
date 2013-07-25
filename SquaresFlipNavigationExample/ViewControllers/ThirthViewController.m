//
//  ThirthViewController.m
//  SquaresFlipNavigationExample
//
//  Created by Andrés Brun on 7/25/13.
//  Copyright (c) 2013 Andrés Brun. All rights reserved.
//

#import "ThirthViewController.h"
#import "ViewController.h"

@interface ThirthViewController ()

@end

@implementation ThirthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popViewController:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)popToFirstViewController:(id)sender
{
    ViewController *firstVC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:firstVC animated:YES];
}

- (IBAction)popToRootViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
