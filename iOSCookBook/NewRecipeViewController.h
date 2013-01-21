//
//  NewRecipeViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//
// This view provides the form to enter the recipe details from, and then saves them when the save button is pressed

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "iOSCookBookModel.h"
#import "Recipe.h"
#import "ingredient.h"
#import "instruction.h"

@interface NewRecipeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;


- (IBAction)addIngredient;
- (IBAction)addInstruction;
- (IBAction)addCategory;
- (IBAction)addPhoto;
- (IBAction)savePressed;
@end
