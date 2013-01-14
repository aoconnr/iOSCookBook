//
//  ViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "ViewController.h"
#import "NewRecipeViewController.h"
//TEMP
#import "RecipeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(IBAction)newRecipeButton:(id)sender{
  NewRecipeViewController *next = [[NewRecipeViewController alloc] initWithNibName:nil bundle:nil];
  [self presentViewController:next animated:TRUE completion:nil];
}

//Temp directs to a view recipe page
-(IBAction)favouriteButton:(id)sender{
  RecipeViewController *next = [[RecipeViewController alloc] initWithNibName:nil bundle:nil];
  [self presentViewController:next animated:TRUE completion:nil];
}

-(IBAction)browseButton:(id)sender{
  
}

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

@end
