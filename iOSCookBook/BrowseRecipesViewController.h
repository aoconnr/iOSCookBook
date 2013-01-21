//
//  BrowseRecipesViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 18/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//
//  With this view the recipes within a chosen category are displayed by name, with the associated picture.

#import <UIKit/UIKit.h>
#import "RecipeViewController.h"
#import "Recipe.h"
#import "iOSCookBookModel.h"

@interface BrowseRecipesViewController : UIViewController{
  NSMutableArray *tableViewData; // holds the data to be displayed
  
}

@property (strong) NSMutableArray* recipeList;
@property (strong) iOSCookBookModel *model;

@end
