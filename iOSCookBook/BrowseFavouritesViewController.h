//
//  BrowseFavouritesViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 19/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//
//  Displays the favourited recipes' names and photos to be selected, which takes the user to the recipe details

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#import "iOSCookBookModel.h"

@interface BrowseFavouritesViewController : UIViewController{
  NSMutableArray *tableViewData; //The data to be displayed
}

@property (strong, nonatomic) iOSCookBookModel *model;

@end
