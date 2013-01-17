//
//  NewRecipeViewController.h
//  iOSCookBook
//
//  Created by Andrew O'Connor on 11/01/2013.
//  Copyright (c) 2013 Andrew O'Connor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRecipeViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;


- (IBAction)addIngredient;
- (IBAction)addInstruction;
- (IBAction)addCategory;
- (IBAction)addPhoto;
- (IBAction)savePressed;
@end
