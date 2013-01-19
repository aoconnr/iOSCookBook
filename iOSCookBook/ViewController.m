//
//  ViewController.m
//  iOSCookBook
//
//  Created by Andrew O'Connor on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import "ViewController.h"
#import "NewRecipeViewController.h"
#import "BrowseCategoriesViewController.h"
#import "BrowseFavouritesViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(IBAction)newRecipeButton:(id)sender{
  NewRecipeViewController *nextView = [[NewRecipeViewController alloc] initWithNibName:@"NewRecipeViewController" bundle:nil];
  [self.navigationController pushViewController:nextView animated:TRUE];
}

//Temp directs to a view recipe page
-(IBAction)favouriteButton:(id)sender{
  BrowseFavouritesViewController *nextView = [[BrowseFavouritesViewController alloc] initWithNibName:@"BrowseFavouritesViewController" bundle:nil];
  [self.navigationController pushViewController:nextView animated:TRUE];
//  RecipeViewController *next = [[RecipeViewController alloc] initWithNibName:nil bundle:nil];
//  [self presentViewController:next animated:TRUE completion:nil];
}

-(IBAction)browseButton:(id)sender{
  BrowseCategoriesViewController *nextView = [[BrowseCategoriesViewController alloc] initWithNibName:@"BrowseRecipesViewController" bundle:nil];
  [self.navigationController pushViewController:nextView animated:TRUE];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  self.title = @"Main Menu";
  [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
